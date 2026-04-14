import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import CategoryIcon from "@/components/category/CategoryIcon";

type CategoryWithCount = {
  id: string;
  name: string;
  slug: string;
  description: string | null;
  icon: string;
  product_count: number;
};

export default async function CategoriesPage() {
  const supabase = await createClient();

  // Fetch categories + product count in one query using the embed shorthand.
  // `product_categories(count)` gives a count aggregate via the junction table.
  const { data, error } = await supabase
    .from("categories")
    .select("id, name, slug, description, icon, product_categories(count)")
    .order("name");

  if (error) throw error;

  const categories: CategoryWithCount[] = (data ?? []).map((c) => ({
    id: c.id,
    name: c.name,
    slug: c.slug,
    description: c.description,
    icon: c.icon,
    product_count: c.product_categories?.[0]?.count ?? 0,
  }));

  return (
    <div className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
      <header className="mb-8">
        <h1 className="text-3xl font-bold tracking-tight">Categories</h1>
        <p className="mt-1 text-sm text-muted-foreground">
          Browse supplements by category
        </p>
      </header>

      <div className="grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-5">
        {categories.map((cat) => (
          <Link
            key={cat.id}
            href={`/categories/${cat.slug}`}
            className="group flex flex-col items-center gap-3 rounded-lg border border-border/60 bg-card p-4 text-center transition-all hover:border-primary/40 hover:shadow-lg"
          >
            {/* Icon sized same as future hero image would be */}
            <div className="flex aspect-square w-full items-center justify-center rounded-md bg-muted text-primary transition-transform group-hover:scale-105">
              <CategoryIcon
                name={cat.icon}
                className="h-16 w-16"
                strokeWidth={1.5}
              />
            </div>
            <div>
              <h3 className="font-semibold leading-tight">{cat.name}</h3>
              <p className="mt-0.5 text-xs text-muted-foreground">
                {cat.product_count}{" "}
                {cat.product_count === 1 ? "product" : "products"}
              </p>
            </div>
          </Link>
        ))}
      </div>
    </div>
  );
}
