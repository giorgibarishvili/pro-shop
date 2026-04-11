# Pro Shop — Project Instructions

## What is this?
An e-commerce web app for gym food supplements. Learning project — not a real client.
All product data is placeholder/generated.

## Tech Stack
- **Frontend:** Next.js 15 (App Router), React 19, TypeScript, Tailwind CSS v4, Redux Toolkit, shadcn/ui
- **Database & Auth:** Supabase (Postgres, Auth, Storage, RLS)
- **Backend (if needed):** Python (FastAPI) — only add when Supabase can't handle something
- **Package Manager:** npm

## Monorepo Structure
```
pro-shop/
├── app/
│   ├── frontend/          # Next.js app
│   └── backend/           # Python API (added later if needed)
├── docs/                  # Planning & architecture docs
├── scripts/               # Utility scripts (seed data, etc.)
├── claude.md              # This file
└── .gitignore
```

## Coding Conventions
- Always use TypeScript strict mode
- Use Next.js App Router (not Pages Router)
- Server Components by default; add "use client" only when needed
- Use Redux Toolkit for global client state (cart, auth, filters)
- Use Supabase for all server state (products, orders, users)
- shadcn/ui for all UI components — customize colors/spacing to match gym brand aesthetic
- Tailwind for all styling — no CSS modules, no styled-components
- Use `@/` path alias for imports from the `src/` directory
- Colocate components: page-specific components live next to their page

## Database Principles
- Every query must use an index — no full table scans
- Use Postgres full-text search (tsvector/tsquery) for product search
- RLS policies on every table
- Optimize first, even for small datasets — this is a learning project

## Git
- Conventional commits: `feat:`, `fix:`, `docs:`, `chore:`, `refactor:`
- One feature per commit when possible

## Do NOT
- Add a Python backend unless Supabase genuinely can't handle the use case
- Use Pages Router or getServerSideProps
- Install CSS-in-JS libraries
- Skip TypeScript types (no `any` unless absolutely necessary)
- Over-engineer — keep it simple but properly structured
