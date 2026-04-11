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
