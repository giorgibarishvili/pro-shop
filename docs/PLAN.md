# Build Plan

## Phase 0 — Project Scaffold
> Set up the monorepo, tooling, and empty Next.js app.

- [ ] Initialize git repo
- [ ] Create root `package.json` with npm workspaces
- [ ] Scaffold Next.js app in `app/frontend/` (App Router, TypeScript, Tailwind, ESLint)
- [ ] Install and configure shadcn/ui
- [ ] Set up path aliases (`@/`)
- [ ] Install Redux Toolkit, set up empty store with provider
- [ ] Create Supabase project, install `@supabase/ssr`
- [ ] Set up Supabase client (browser + server) and env variables
- [ ] Create root `.gitignore`
- [ ] Verify dev server runs cleanly

**Deliverable:** `pnpm dev` launches a blank Next.js page with Tailwind + shadcn working.

---

## Phase 1 — Database & Seed Data
> Design the schema, optimize it, and fill it with generated data.

- [ ] Create Supabase tables: `products`, `categories`, `product_categories`, `profiles`, `orders`, `order_items`
- [ ] Add indexes: B-tree on FKs, GIN on `search_vector` (tsvector)
- [ ] Add trigger to auto-update `search_vector` on product insert/update
- [ ] Set up RLS policies for every table
- [ ] Write seed script (`scripts/seed.ts`) — generates ~100 supplement products with realistic names, descriptions, prices, images, sale prices
- [ ] Verify queries with `EXPLAIN ANALYZE`

**Deliverable:** Populated database with fast indexed queries and full-text search ready.

---

## Phase 2 — Layout & Navigation
> Build the shell of the app — header, footer, navigation, responsive design.

- [ ] Root layout with global styles and font
- [ ] Header: logo, nav links, search bar, cart icon (with count badge), user menu
- [ ] Footer: links, copyright
- [ ] Mobile-responsive navigation (hamburger menu)
- [ ] Admin layout with sidebar (separate from shop layout)

**Deliverable:** Navigable shell with all routes stubbed.

---

## Phase 3 — Product Listing & Categories
> Display products and let users browse by category.

- [ ] Home page: hero section, featured products, categories grid
- [ ] Products page: grid of ProductCards with pagination
- [ ] Category page: filtered products by category
- [ ] Sale page: products where `sale_price` is set
- [ ] ProductCard component (image, name, price, sale badge, add-to-cart button)

**Deliverable:** Users can browse all products, filter by category, and see sale items.

---

## Phase 4 — Search & Filters
> Full-text search with Postgres + client-side filter UI.

- [ ] SearchBar component with debounced input
- [ ] Supabase RPC function for full-text search using `ts_rank` + `tsquery`
- [ ] Search results page with highlighted matches
- [ ] Filter panel: price range, category, in-stock, on-sale
- [ ] Sort options: price asc/desc, name, newest, popularity
- [ ] Redux filterSlice to manage active filters
- [ ] URL sync — filters reflected in URL params (shareable links)

**Deliverable:** Fast, typo-tolerant search with combinable filters and URL persistence.

---

## Phase 5 — Product Detail Page
> Individual product page with all info and add-to-cart.

- [ ] Dynamic route `/products/[id]`
- [ ] Product images (placeholder via Supabase Storage or external URLs)
- [ ] Name, description, price, sale price, stock status
- [ ] Quantity selector + add-to-cart button
- [ ] "Related products" section (same category)
- [ ] Breadcrumb navigation

**Deliverable:** Complete product detail page with SSG + ISR.

---

## Phase 6 — Cart
> Client-side cart using Redux, persisted to localStorage.

- [ ] Redux cartSlice: add, remove, update quantity, clear
- [ ] Cart page: list of items, quantity controls, subtotal, total
- [ ] Cart drawer/sidebar (accessible from any page via header icon)
- [ ] Persist cart to localStorage (Redux middleware)
- [ ] Empty cart state

**Deliverable:** Fully functional cart that persists across page refreshes.

---

## Phase 7 — Authentication
> Supabase Auth with email/password, protected routes.

- [ ] Login page with form (shadcn form components)
- [ ] Register page with form
- [ ] Supabase Auth integration (signUp, signIn, signOut)
- [ ] Auth middleware — protect `/admin` routes and `/checkout`
- [ ] Redux authSlice synced with Supabase session
- [ ] User menu in header (logged in: profile/logout, logged out: login/register)
- [ ] Create `profiles` row on sign-up (via Supabase trigger or server action)

**Deliverable:** Users can register, log in, and access protected pages.

---

## Phase 8 — Checkout (Mock)
> Checkout flow with form validation, no real payment.

- [ ] Checkout page: shipping info form, order summary
- [ ] Form validation (shadcn form + zod)
- [ ] "Place Order" — creates order in Supabase, clears cart
- [ ] Order confirmation page
- [ ] Order saved with status `pending`

**Deliverable:** End-to-end purchase flow (mock) that writes to the database.

---

## Phase 9 — Admin Dashboard
> Protected admin area with stats and CRUD.

- [ ] Dashboard page: total revenue, order count, product count, recent orders (cards + charts)
- [ ] Products management: table view, add/edit/delete products
- [ ] Orders management: table view, update order status
- [ ] Users management: table view, role management
- [ ] Admin role check — only `role = 'admin'` in profiles can access

**Deliverable:** Functional admin panel for managing the store.

---

## Phase 10 — Polish & Optimization
> Final pass for performance, UX, and code quality.

- [ ] Loading states (skeletons via shadcn)
- [ ] Error boundaries and 404 page
- [ ] Image optimization (`next/image`)
- [ ] Metadata & SEO (titles, descriptions, Open Graph)
- [ ] Lighthouse audit — aim for 90+ across all categories
- [ ] Accessibility pass (keyboard nav, ARIA labels, contrast)
- [ ] Review all Supabase queries with `EXPLAIN ANALYZE`
- [ ] Add `README.md` with setup instructions

**Deliverable:** Production-quality app ready to showcase.
