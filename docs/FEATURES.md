# Feature Breakdown

## 0. Navigation & Layout

### Desktop Header
```
[Logo]  [Home] [Categories ▾] [Products] [Sale]    [Search...]    [🛒 Cart] [Account]
```
- Fixed top bar, dark background (`#0A0A0A`), white text
- **Categories dropdown:** hover or click opens a dropdown listing all categories
- Clicking "Categories" text itself navigates to `/categories` page
- Search bar with debounced instant results dropdown
- Cart icon shows item count badge (lime green)
- Account: logged out → Login/Register links, logged in → user menu with logout

### Mobile Header
```
[☰ Menu]   [Logo]   [🛒 Cart]
```
- Hamburger opens a slide-out drawer from the left
- Drawer contains: nav links, full category list, search bar, account links
- Cart icon always visible in header

---

## 1. Product Listing

### Home Page (`/`)
- Hero banner with CTA ("Shop Supplements", "View Sale")
- Featured products section (top 8 by popularity or hand-picked)
- Popular categories row (circular icons — links to `/categories`)
- "On Sale" preview section

### All Products Page (`/products`)
- Responsive grid of ProductCards (3 cols desktop, 2 tablet, 1 mobile)
- Pagination (cursor-based for performance, not offset-based)
- Sort dropdown: Price Low→High, Price High→Low, Newest, Name A-Z
- Active filter chips with "Clear All"

### ProductCard Component
- Product image (placeholder)
- Product name
- Price (with strikethrough if on sale + sale price)
- "SALE" badge (conditional)
- Star rating (static/random for now)
- "Add to Cart" button
- Hover state: subtle scale + shadow

---

## 2. Categories

### All Categories Page (`/categories`)
- Visual grid of category cards (not a plain list)
- Each card: circular icon with green accent ring, category name, product count
- 4 columns desktop, 3 tablet, 2 mobile
- Clicking a card navigates to `/categories/[slug]`

```
  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐
  │   (○)   │  │   (○)   │  │   (○)   │  │   (○)   │
  │  icon   │  │  icon   │  │  icon   │  │  icon   │
  │         │  │         │  │         │  │         │
  │ Protein │  │Creatine │  │  Pre-   │  │Vitamins │
  │ Powders │  │         │  │Workout  │  │         │
  │14 items │  │ 8 items │  │11 items │  │22 items │
  └─────────┘  └─────────┘  └─────────┘  └─────────┘
```

### Category Detail Page (`/categories/[slug]`)
- Category header with name, description, and icon
- Same product grid as `/products` but filtered to this category
- Breadcrumb: Home > Categories > [Category Name]

### Categories
Predefined set (seeded):
1. Protein Powders
2. Creatine
3. Pre-Workout
4. BCAAs & Amino Acids
5. Vitamins & Minerals
6. Weight Gainers
7. Fat Burners
8. Energy & Endurance
9. Recovery & Joint Support
10. Snacks & Bars

---

## 3. Search

### SearchBar
- Lives in the header, always visible
- Debounced input (300ms)
- Dropdown with instant results (top 5 matches) as user types
- "View all results" link → navigates to `/products?q=...`
- Keyboard accessible (Esc to close, Enter to search)

### Search Implementation (Supabase)
- Postgres `tsvector` column on `products` table
- Weighted: name (A), brand (B), description (C), category names (D)
- `ts_rank` for relevance scoring
- `plainto_tsquery` with prefix matching for partial words
- Trigram index (`pg_trgm`) as fallback for typo tolerance
- Supabase RPC function: `search_products(query text, limit int)`

### Filters (on `/products` page)
- Price range (min/max input or slider)
- Category (multi-select checkboxes)
- On sale only (toggle)
- In stock only (toggle)
- All filters sync to URL search params

---

## 4. Product Detail Page (`/products/[id]`)

- Large product image(s)
- Product name, brand
- Price / sale price
- Stock status ("In Stock", "Low Stock", "Out of Stock")
- Quantity selector (number input, min 1, max = stock)
- "Add to Cart" button (disabled if out of stock)
- Breadcrumb: Home > Products > [Product Name]

### Description Sections (tabbed or stacked)

**Brand Description** (unique per product)
- What makes this product special, brand story, key selling points
- Stored in `products.brand_description`

**How to Use** (shared per product type)
- Usage instructions, dosage, timing, warnings
- Stored in `product_types.how_to_use`
- E.g., all "Protein Powder" products show the same usage instructions
- Avoids duplicating identical text across 20 protein powder products

**Nutrition Info**
- Supplement facts table from `products.nutrition_info` (jsonb)

### Other
- Related products carousel (same category, exclude current)

---

## 5. Cart

### Cart State (Redux)
```ts
interface CartItem {
  productId: string;
  name: string;
  price: number;        // actual price (sale or regular)
  image: string;
  quantity: number;
  maxQuantity: number;   // stock limit
}
```

### Cart Drawer
- Slides in from the right when cart icon clicked
- List of CartItems with image, name, price, quantity +/- buttons
- Remove item button
- Subtotal at bottom
- "View Cart" and "Checkout" buttons
- Empty state: "Your cart is empty" with CTA

### Cart Page (`/cart`)
- Full-page view of cart items
- Quantity update, remove
- Subtotal, estimated tax, total
- "Continue Shopping" and "Proceed to Checkout" buttons

### Persistence
- Redux middleware saves cart to localStorage on every change
- On app load, hydrate Redux store from localStorage

---

## 6. Checkout (`/checkout`)

- **Step 1:** Shipping info form (name, email, address, city, zip)
- **Step 2:** Order review (items, quantities, totals)
- **Step 3:** "Place Order" button (no real payment — simulated)
- On submit: create `order` + `order_items` rows in Supabase, clear cart
- Redirect to `/checkout/confirmation/[orderId]`
- Confirmation page: "Thank you!" + order number + order summary

### Validation
- All fields validated with Zod schema
- shadcn Form components with inline error messages

---

## 7. Authentication

### Login (`/login`)
- Email + password form
- "Don't have an account? Register" link
- Error messages for invalid credentials

### Register (`/register`)
- Email + password + confirm password + full name
- Auto-create profile row in `profiles` table
- Redirect to home page on success

### Session Management
- Supabase handles JWT tokens automatically
- Middleware checks session for protected routes
- Redux authSlice stores `{ user, isAdmin }` for UI rendering

### Protected Routes
- `/checkout` — requires login (redirect to `/login?redirect=/checkout`)
- `/admin/*` — requires login + `role = 'admin'`

---

## 8. Admin Dashboard

### Dashboard (`/admin`)
- Cards: Total Revenue, Total Orders, Total Products, Total Users
- Chart: Orders per day (last 30 days) — use recharts or similar
- Recent orders table (last 10)

### Product Management (`/admin/products`)
- Table: name, price, sale price, stock, category, actions
- "Add Product" button → modal or separate page with form
- Edit/Delete actions per row
- Inline stock update

### Order Management (`/admin/orders`)
- Table: order ID, customer, total, status, date, actions
- Status update dropdown (pending → processing → shipped → delivered)

### User Management (`/admin/users`)
- Table: name, email, role, created date
- Toggle admin role

---

## 9. Sale Page (`/sale`)

- Same layout as products page but only shows products with `sale_price != null`
- "SALE" badge on every card
- Shows original price strikethrough + sale price
- Optional: countdown timer component (cosmetic, for learning)
