# Architecture

## Monorepo Layout

```
pro-shop/
├── app/
│   └── frontend/                   # Next.js application
│       ├── public/                 # Static assets (logos, icons)
│       ├── src/
│       │   ├── app/                # Next.js App Router
│       │   │   ├── (shop)/         # Route group: public storefront
│       │   │   │   ├── page.tsx              # Home / product listing
│       │   │   │   ├── products/
│       │   │   │   │   ├── page.tsx          # All products (with search & filters)
│       │   │   │   │   └── [id]/
│       │   │   │   │       └── page.tsx      # Product detail
│       │   │   │   ├── categories/
│       │   │   │   │   ├── page.tsx          # All categories (visual icon grid)
│       │   │   │   │   └── [slug]/
│       │   │   │   │       └── page.tsx      # Category detail (filtered products)
│       │   │   │   ├── sale/
│       │   │   │   │   └── page.tsx          # Products on sale
│       │   │   │   ├── cart/
│       │   │   │   │   └── page.tsx          # Shopping cart
│       │   │   │   └── checkout/
│       │   │   │       └── page.tsx          # Checkout (mock payment)
│       │   │   ├── (auth)/         # Route group: authentication
│       │   │   │   ├── login/
│       │   │   │   │   └── page.tsx
│       │   │   │   └── register/
│       │   │   │       └── page.tsx
│       │   │   ├── admin/          # Route group: admin panel
│       │   │   │   ├── layout.tsx            # Admin layout with sidebar
│       │   │   │   ├── page.tsx              # Dashboard (stats, charts)
│       │   │   │   ├── products/
│       │   │   │   │   └── page.tsx          # CRUD products
│       │   │   │   ├── orders/
│       │   │   │   │   └── page.tsx          # Order management
│       │   │   │   └── users/
│       │   │   │       └── page.tsx          # User management
│       │   │   ├── layout.tsx      # Root layout
│       │   │   └── globals.css     # Tailwind base + custom tokens
│       │   ├── components/         # Shared components
│       │   │   ├── ui/             # shadcn/ui components (auto-generated)
│       │   │   ├── layout/         # Header, Footer, MobileDrawer, CategoryDropdown
│       │   │   ├── product/        # ProductCard, ProductGrid, ProductQuickView
│       │   │   ├── cart/           # CartItem, CartSummary, CartDrawer
│       │   │   └── search/         # SearchBar, SearchResults, FilterPanel
│       │   ├── lib/                # Utilities & config
│       │   │   ├── supabase/
│       │   │   │   ├── client.ts             # Browser client
│       │   │   │   ├── server.ts             # Server client
│       │   │   │   └── middleware.ts          # Auth middleware helper
│       │   │   ├── utils.ts                  # General utilities
│       │   │   └── constants.ts              # App-wide constants
│       │   ├── store/              # Redux Toolkit
│       │   │   ├── store.ts                  # Store config
│       │   │   ├── provider.tsx              # Redux Provider wrapper
│       │   │   ├── cartSlice.ts
│       │   │   ├── filterSlice.ts
│       │   │   └── authSlice.ts
│       │   ├── types/              # TypeScript types
│       │   │   ├── product.ts
│       │   │   ├── cart.ts
│       │   │   ├── order.ts
│       │   │   └── user.ts
│       │   └── hooks/              # Custom React hooks
│       │       ├── useProducts.ts
│       │       ├── useSearch.ts
│       │       └── useAuth.ts
│       ├── next.config.ts
│       ├── tailwind.config.ts
│       ├── tsconfig.json
│       └── package.json
├── scripts/
│   └── seed.ts                     # Database seed script
├── docs/                           # You are here
├── claude.md
├── .gitignore
└── package.json                    # Root workspace config (npm)
```

## Data Flow

```
User Action
    ↓
React Component (Client or Server)
    ↓
┌─────────────────────────────────────┐
│  Server Component?                  │
│  → Direct Supabase query (server)   │
│                                     │
│  Client Component?                  │
│  → Redux dispatch → Supabase client │
│  → Or Server Action                 │
└─────────────────────────────────────┘
    ↓
Supabase Postgres
(RLS enforced, indexes used, FTS for search)
    ↓
Response → UI Update
```

## State Management Split

| What | Where | Why |
|------|-------|-----|
| Products, categories, orders | Supabase (server state) | Source of truth is the DB |
| Cart items, quantities | Redux Toolkit (client state) | Fast local updates, persisted to localStorage |
| Search query, active filters | Redux Toolkit (client state) | Instant UI response |
| Auth session | Supabase Auth + Redux sync | Supabase manages tokens, Redux holds UI state |
| UI state (modals, drawers) | React local state | Component-scoped, no global sharing needed |

## Rendering Strategy

| Page | Strategy | Why |
|------|----------|-----|
| Home / Product listing | SSR + Streaming | Fresh data, good SEO, fast TTFB |
| Product detail | SSG + ISR (revalidate 60s) | Mostly static, occasional updates |
| Category pages | SSR | Dynamic based on category |
| Sale page | SSR | Prices change frequently |
| Cart | Client-side | Fully interactive, local state |
| Checkout | Client-side + Server Actions | Form interactions + secure submission |
| Auth pages | Client-side | Interactive forms |
| Admin dashboard | Client-side (protected) | Real-time data, no SEO needed |
