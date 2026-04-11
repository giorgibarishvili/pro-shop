# Database Schema

## Design Decisions
- Plural table names (consistent throughout)
- Supabase Auth handles `auth.users` (email, password, sessions) — we only extend it with `profiles`
- All PKs are uuid
- All tables have `created_at`, `updated_at` only where updates are expected

---

## 1. `profiles`

Extends Supabase `auth.users` with app-specific data. 1:1 relationship.

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | uuid | PK, FK → auth.users.id ON DELETE CASCADE | Not auto-generated — matches the auth user's id |
| full_name | text | NOT NULL | Display name, not stored in auth |
| role | text | NOT NULL, default `'customer'`, CHECK IN ('customer', 'admin') | Role, not status — controls access |
| created_at | timestamptz | NOT NULL, default `now()` | |

**Why no email?** Already in `auth.users` — join to get it, don't duplicate.
**Why no updated_at?** Profile data rarely changes. Can add later if needed.
**Why no avatar_url?** Not needed for this project.

---

## 2. `categories`

Flat list of product categories. No subcategories — products can belong to multiple categories via a junction table instead.

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | uuid | PK, default `gen_random_uuid()` | |
| name | text | NOT NULL, UNIQUE | e.g. "Protein Powders" |
| slug | text | NOT NULL, UNIQUE | URL-safe version: "protein-powders" — used in routes `/categories/[slug]` |
| description | text | | Short blurb shown on category page header |
| created_at | timestamptz | NOT NULL, default `now()` | |

**Indexes:**
- `idx_categories_slug` — UNIQUE B-tree on `slug` (every category page visit queries by slug)

**Why no icon column?** Icon mapping lives in frontend code — keeps DB free of UI concerns.
**Why no subcategories?** 10 flat categories + multi-tagging via junction table gives the same flexibility without recursive query complexity.

---

## 3. `products`

The main product table. Categories are linked via a junction table (not a column here) since products can belong to multiple categories. Shared "how to use" instructions come from `product_types` via FK.

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | uuid | PK, default `gen_random_uuid()` | |
| name | text | NOT NULL | e.g. "Gold Standard 100% Whey" |
| slug | text | NOT NULL, UNIQUE | URL-friendly: "gold-standard-100-whey" — used in routes `/products/[slug]` |
| brand | text | NOT NULL | e.g. "Optimum Nutrition" — not a separate table, not enough brand-specific data |
| brand_description | text | | What makes THIS product special — unique per product |
| product_type_id | uuid | FK → product_types.id | Links to shared `how_to_use` instructions |
| price | numeric(10,2) | NOT NULL, CHECK > 0 | Always present |
| sale_price | numeric(10,2) | nullable, CHECK > 0 AND < price | If not null → product is on sale, show strikethrough on original price |
| stock | integer | NOT NULL, default 0, CHECK >= 0 | Derive "In Stock" / "Low Stock" / "Out of Stock" from this |
| image_url | text | | URL pointing to Supabase Storage bucket |
| is_featured | boolean | NOT NULL, default `false` | Admin hand-picks products for homepage "Featured" section |
| search_vector | tsvector | auto-generated via trigger | Never set manually — trigger keeps it in sync |
| created_at | timestamptz | NOT NULL, default `now()` | |
| updated_at | timestamptz | NOT NULL, default `now()` | Products get edited (price changes, stock updates, etc.) |

**Indexes:**
- `idx_products_slug` — UNIQUE B-tree on `slug` (every product page queries by slug)
- `idx_products_search` — GIN on `search_vector` (full-text search — instant lookups instead of scanning every row)
- `idx_products_price` — B-tree on `price` (sort by price, price range filters)
- `idx_products_sale` — B-tree on `sale_price` WHERE `sale_price IS NOT NULL` (partial index — only indexes products on sale, used by `/sale` page)
- `idx_products_featured` — B-tree on `is_featured` WHERE `is_featured = true` (partial index — only indexes featured products, used by homepage)
- `idx_products_created` — B-tree on `created_at` DESC (sort by newest)
- `idx_products_type` — B-tree on `product_type_id` (join to product_types)
- `idx_products_trgm_name` — GIN trigram on `name` (typo-tolerant search: "protien" → "protein")

**Trigger:** `trig_products_search_vector`
- Fires BEFORE INSERT or UPDATE on `name`, `brand`, `brand_description`
- Auto-sets `search_vector` with weighted fields:
  - **A** (highest): `name` — "whey protein" matches on name rank first
  - **B**: `brand` — "optimum nutrition" matches rank second
  - **C** (lowest): `brand_description` — description matches rank last
- No backend needed — Postgres does this automatically

**Why no category column?** A product can belong to multiple categories (e.g. a BCAA in both "BCAAs" and "Recovery"). Junction table `product_categories` handles this.

---

## 4. `product_types`

Groups products by what they physically are. Exists solely to share `how_to_use` instructions — all protein powders get the same usage text instead of duplicating it across 20 rows.

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | uuid | PK, default `gen_random_uuid()` | |
| name | text | NOT NULL, UNIQUE | e.g. "Protein Powder", "Creatine Monohydrate", "Pre-Workout" |
| slug | text | NOT NULL, UNIQUE | URL-friendly: "protein-powder" |
| how_to_use | text | NOT NULL | Shared usage instructions: "Mix 1 scoop with 200-300ml of water..." |
| created_at | timestamptz | NOT NULL, default `now()` | |

**Indexes:**
- `idx_product_types_slug` — UNIQUE B-tree on `slug`

**Why a separate table instead of a column on products?** 20 protein powders would all store identical "how to use" text. One row here, 20 FKs pointing to it — no duplication, easy to update in one place.
**Why no `updated_at`?** Usage instructions rarely change. Can add later if needed.
**Why `NOT NULL` on `how_to_use`?** This table's only purpose is storing instructions — a row without them is pointless.

---

## 5. `product_categories` (junction table)

Links products to categories. Many-to-many — one product can be in multiple categories, one category can contain multiple products.

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| product_id | uuid | FK → products.id ON DELETE CASCADE | If product is deleted, remove the link |
| category_id | uuid | FK → categories.id ON DELETE CASCADE | If category is deleted, remove the link |

**Primary Key:** composite `(product_id, category_id)` — the pair itself is the identity, no separate `id` needed.

**Indexes:**
- PK already indexes `(product_id, category_id)` — covers lookups like "what categories is this product in?"
- `idx_pc_category` — B-tree on `category_id` (covers "what products are in this category?" — the category page query)

**Why ON DELETE CASCADE?** If a product or category is deleted, the links should disappear automatically — no orphan rows.
**Why no `id` column?** A junction table's only job is to link two rows. The composite PK is the identity — adding a separate `id` would be redundant.
**Why no `created_at`?** The link either exists or doesn't. When it was created is irrelevant.

---

**Why no category column on products?** A product can belong to multiple categories (e.g. a BCAA in both "BCAAs" and "Recovery"). This junction table handles that.
**Why `stock` integer instead of `in_stock` boolean?** Enables "Low Stock" warnings, cart quantity limits, and "Out of Stock" — all derived from one number.
**Why no `sale_end_date`?** Adds cron job complexity. Admin manually sets `sale_price` to null when sale ends. Countdown timers can be cosmetic (frontend-only).
**Why `numeric(10,2)` for prices?** Never use float for money — floating point causes rounding errors (e.g. 0.1 + 0.2 ≠ 0.3). `numeric` is exact.

---

## 6. `cart_items`

Persistent cart stored in DB — survives across devices and browser clears. Requires user to be logged in.

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| user_id | uuid | FK → profiles.id ON DELETE CASCADE | User deleted = cart gone |
| product_id | uuid | FK → products.id ON DELETE CASCADE | Product deleted = cart item removed |
| quantity | integer | NOT NULL, CHECK > 0 | Validated at app level: quantity ≤ product.stock |
| created_at | timestamptz | NOT NULL, default `now()` | Useful for "added X days ago" or clearing stale carts |

**Primary Key:** composite `(user_id, product_id)` — one cart entry per product per user. Adding the same product again increments quantity.

**Indexes:**
- PK already indexes `(user_id, product_id)` — covers "show this user's cart"

**Why no separate `id`?** Same logic as `product_categories` — the pair is the identity.
**Why ON DELETE CASCADE on product_id?** Deleted products are rare (admin action). Out of stock is the common case and is handled by the frontend checking `product.stock` when rendering the cart — no schema complexity needed.
**Why no `updated_at`?** The only update is quantity changes — `created_at` is enough context.
**Why quantity check at app level, not DB?** A cross-table CHECK constraint (quantity ≤ products.stock) is complex in Postgres. The app validates before inserting/updating — simpler and just as effective.

---

## 7. `orders`

Created when a user places an order. Cart items become order items, cart is cleared.

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | uuid | PK, default `gen_random_uuid()` | |
| user_id | uuid | FK → profiles.id | Who placed the order |
| status | text | NOT NULL, default `'pending'`, CHECK IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled') | Admin updates this as order progresses |
| total | numeric(10,2) | NOT NULL | Snapshot of order total at time of purchase |
| shipping_name | text | NOT NULL | Recipient name |
| shipping_email | text | NOT NULL | Contact email for order updates |
| shipping_address | text | NOT NULL | Street address |
| shipping_city | text | NOT NULL | City |
| shipping_zip | text | NOT NULL | Postal code |
| created_at | timestamptz | NOT NULL, default `now()` | When the order was placed |
| updated_at | timestamptz | NOT NULL, default `now()` | Changes when status is updated |

**Indexes:**
- `idx_orders_user` — B-tree on `user_id` (user's order history page)
- `idx_orders_status` — B-tree on `status` (admin filtering by status)
- `idx_orders_created` — B-tree on `created_at` DESC (recent orders first)

**Why separate shipping fields instead of one `address` blob?** Lets you filter/sort by city, validate zip format, and display cleanly in the admin panel.
**Why `total` stored instead of calculated?** Same reason as `unit_price` — prices can change, discounts may apply. The order total is frozen at purchase time.
**Why no ON DELETE CASCADE on user_id?** Orders are business records. If a user is deleted, their order history should remain for accounting purposes.

---

## 8. `order_items`

Individual products within an order. One row per product per order.

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | uuid | PK, default `gen_random_uuid()` | Own PK — might need to reference individual items (returns, disputes) |
| order_id | uuid | FK → orders.id ON DELETE CASCADE | Order deleted = items gone |
| product_id | uuid | FK → products.id | Links to the product (for display — name, image) |
| quantity | integer | NOT NULL, CHECK > 0 | How many were purchased |
| unit_price | numeric(10,2) | NOT NULL | **Price snapshot** — frozen at time of purchase, immune to future price changes |

**Indexes:**
- `idx_oi_order` — B-tree on `order_id` (order detail page — "show me all items in this order")

**Why `unit_price` instead of joining to `products.price`?** If the product was $29.99 when purchased and later raised to $34.99, the order must still show $29.99. This is a snapshot, not a reference.
**Why a separate `id` instead of composite PK?** Unlike cart/junction tables, order items may need to be individually referenced (refunds, line-item disputes, analytics).
**Why no ON DELETE CASCADE on product_id?** A deleted product shouldn't erase purchase history. The order item row stays — frontend shows product info from the snapshot or "Product no longer available".
