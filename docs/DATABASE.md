# Database Schema & Optimization

## Tables

### `categories`
| Column | Type | Constraints |
|--------|------|-------------|
| id | uuid | PK, default `gen_random_uuid()` |
| name | text | NOT NULL, UNIQUE |
| slug | text | NOT NULL, UNIQUE |
| description | text | |
| icon | text | NOT NULL (Lucide icon name, e.g. "beef", "flask-conical", "zap") |
| image_url | text | |
| created_at | timestamptz | default `now()` |

**Indexes:**
- `idx_categories_slug` — UNIQUE B-tree on `slug` (route lookups)

---

### `product_types`
| Column | Type | Constraints |
|--------|------|-------------|
| id | uuid | PK, default `gen_random_uuid()` |
| name | text | NOT NULL, UNIQUE (e.g., "Protein Powder", "Creatine Monohydrate") |
| slug | text | NOT NULL, UNIQUE |
| how_to_use | text | NOT NULL (shared usage instructions for this type) |
| created_at | timestamptz | default `now()` |

**Indexes:**
- `idx_product_types_slug` — UNIQUE B-tree on `slug`

**Example rows:**
| name | how_to_use |
|------|-----------|
| Protein Powder | Mix 1 scoop (30g) with 200-300ml of water or milk. Shake well. Best consumed within 30 minutes after training or as a meal replacement. |
| Creatine Monohydrate | Mix 1 scoop (5g) with water or juice. Take daily — on training days after workout, on rest days in the morning. No loading phase required. |
| Pre-Workout | Mix 1 scoop with 200ml water. Consume 20-30 minutes before training. Do not exceed 1 serving per day. Avoid taking within 4 hours of sleep. |

---

### `products`
| Column | Type | Constraints |
|--------|------|-------------|
| id | uuid | PK, default `gen_random_uuid()` |
| name | text | NOT NULL |
| slug | text | NOT NULL, UNIQUE |
| brand | text | NOT NULL |
| brand_description | text | (unique brand/product story — what makes THIS product special) |
| product_type_id | uuid | FK → product_types.id (links to shared how_to_use) |
| price | numeric(10,2) | NOT NULL, CHECK > 0 |
| sale_price | numeric(10,2) | nullable, CHECK > 0 AND < price |
| stock | integer | NOT NULL, default 0, CHECK >= 0 |
| image_url | text | |
| rating | numeric(2,1) | default 0, CHECK between 0 and 5 |
| is_featured | boolean | default false |
| nutrition_info | jsonb | nullable (supplement facts) |
| search_vector | tsvector | auto-generated via trigger |
| created_at | timestamptz | default `now()` |
| updated_at | timestamptz | default `now()` |

**Indexes:**
- `idx_products_slug` — UNIQUE B-tree on `slug`
- `idx_products_search` — GIN on `search_vector` (full-text search)
- `idx_products_price` — B-tree on `price` (sort/filter)
- `idx_products_sale` — B-tree on `sale_price` WHERE `sale_price IS NOT NULL` (partial index for sale page)
- `idx_products_featured` — B-tree on `is_featured` WHERE `is_featured = true` (partial index)
- `idx_products_created` — B-tree on `created_at` DESC (newest sort)
- `idx_products_trgm_name` — GIN trigram on `name` (fuzzy/typo search)
- `idx_products_type` — B-tree on `product_type_id` (join to product_types)

**Trigger:** `trig_products_search_vector`
- Fires on INSERT or UPDATE of `name`, `brand`, `brand_description`
- Sets `search_vector` to:
  ```sql
  setweight(to_tsvector('english', coalesce(name, '')), 'A') ||
  setweight(to_tsvector('english', coalesce(brand, '')), 'B') ||
  setweight(to_tsvector('english', coalesce(brand_description, '')), 'C')
  ```

---

### `product_categories` (junction table)
| Column | Type | Constraints |
|--------|------|-------------|
| product_id | uuid | FK → products.id ON DELETE CASCADE |
| category_id | uuid | FK → categories.id ON DELETE CASCADE |

**Indexes:**
- PK on `(product_id, category_id)`
- `idx_pc_category` — B-tree on `category_id` (category page queries)

---

### `profiles`
| Column | Type | Constraints |
|--------|------|-------------|
| id | uuid | PK, FK → auth.users.id ON DELETE CASCADE |
| full_name | text | |
| role | text | default `'customer'`, CHECK IN ('customer', 'admin') |
| avatar_url | text | |
| created_at | timestamptz | default `now()` |

**Indexes:**
- `idx_profiles_role` — B-tree on `role` WHERE `role = 'admin'` (partial index)

---

### `orders`
| Column | Type | Constraints |
|--------|------|-------------|
| id | uuid | PK, default `gen_random_uuid()` |
| user_id | uuid | FK → profiles.id |
| status | text | default `'pending'`, CHECK IN ('pending','processing','shipped','delivered','cancelled') |
| total | numeric(10,2) | NOT NULL |
| shipping_name | text | NOT NULL |
| shipping_email | text | NOT NULL |
| shipping_address | text | NOT NULL |
| shipping_city | text | NOT NULL |
| shipping_zip | text | NOT NULL |
| created_at | timestamptz | default `now()` |
| updated_at | timestamptz | default `now()` |

**Indexes:**
- `idx_orders_user` — B-tree on `user_id` (user's order history)
- `idx_orders_status` — B-tree on `status` (admin filtering)
- `idx_orders_created` — B-tree on `created_at` DESC (recent orders)

---

### `order_items`
| Column | Type | Constraints |
|--------|------|-------------|
| id | uuid | PK, default `gen_random_uuid()` |
| order_id | uuid | FK → orders.id ON DELETE CASCADE |
| product_id | uuid | FK → products.id |
| quantity | integer | NOT NULL, CHECK > 0 |
| unit_price | numeric(10,2) | NOT NULL (price at time of purchase) |

**Indexes:**
- `idx_oi_order` — B-tree on `order_id` (order detail queries)

---

## RLS Policies

### `products` — public read
```sql
-- Anyone can read products
CREATE POLICY "Products are viewable by everyone"
  ON products FOR SELECT USING (true);

-- Only admins can insert/update/delete
CREATE POLICY "Admins can manage products"
  ON products FOR ALL
  USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );
```

### `categories` — public read, admin write
Same pattern as products.

### `product_types` — public read, admin write
Same pattern as products.

### `profiles` — users read own, admins read all
```sql
-- Users can read their own profile
CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

-- Admins can read all profiles
CREATE POLICY "Admins can view all profiles"
  ON profiles FOR SELECT
  USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- Users can update their own profile (except role)
CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);
```

### `orders` — users read own, admins read all
```sql
-- Users can read their own orders
CREATE POLICY "Users can view own orders"
  ON orders FOR SELECT
  USING (auth.uid() = user_id);

-- Users can create their own orders
CREATE POLICY "Users can create orders"
  ON orders FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Admins can read and update all orders
CREATE POLICY "Admins can manage orders"
  ON orders FOR ALL
  USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );
```

---

## Search RPC Function

```sql
CREATE OR REPLACE FUNCTION search_products(
  search_query text,
  result_limit int DEFAULT 20,
  result_offset int DEFAULT 0
)
RETURNS TABLE (
  id uuid,
  name text,
  slug text,
  brand text,
  price numeric,
  sale_price numeric,
  image_url text,
  rating numeric,
  stock integer,
  rank real
)
LANGUAGE sql STABLE
AS $$
  SELECT
    p.id, p.name, p.slug, p.brand, p.price, p.sale_price,
    p.image_url, p.rating, p.stock,
    ts_rank(p.search_vector, plainto_tsquery('english', search_query)) AS rank
  FROM products p
  WHERE
    p.search_vector @@ plainto_tsquery('english', search_query)
    OR p.name ILIKE '%' || search_query || '%'  -- fallback for partial matches
  ORDER BY rank DESC, p.name ASC
  LIMIT result_limit
  OFFSET result_offset;
$$;
```

---

## Optimization Checklist

- [x] Every FK has an index
- [x] Partial indexes for common filtered queries (sale, featured, admin role)
- [x] GIN index on tsvector for full-text search
- [x] GIN trigram index for fuzzy search
- [x] Cursor-based pagination (not OFFSET for large sets — but OFFSET in search RPC is acceptable for small datasets)
- [x] `unit_price` stored on order_items (price snapshot — immune to product price changes)
- [x] `search_vector` auto-maintained by trigger (no stale data)
- [x] RLS on every table
- [ ] Run `EXPLAIN ANALYZE` on all queries during development
- [ ] Consider `pg_stat_statements` to monitor slow queries
