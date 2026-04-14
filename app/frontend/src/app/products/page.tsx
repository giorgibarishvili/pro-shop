import { createClient } from "@/lib/supabase/server";
import {
  searchProducts,
  listAllProducts,
  attachCategories,
} from "@/lib/data/products";
import ProductCard from "@/components/product/ProductCard";

export default async function ProductsPage({
  searchParams,
}: {
  searchParams: Promise<{ q?: string }>;
}) {
  const { q } = await searchParams;
  const query = q?.trim() ?? "";

  const supabase = await createClient();
  const raw = query
    ? await searchProducts(supabase, query, 50)
    : await listAllProducts(supabase, 50);
  const products = await attachCategories(supabase, raw);

  return (
    <div className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
      <header className="mb-6">
        <h1 className="text-3xl font-bold tracking-tight">
          {query ? `Results for "${query}"` : "All Products"}
        </h1>
        <p className="mt-1 text-sm text-muted-foreground">
          {products.length} {products.length === 1 ? "product" : "products"}
          {query ? " found" : ""}
        </p>
      </header>

      {products.length === 0 ? (
        <div className="rounded-lg border border-dashed py-16 text-center text-muted-foreground">
          <p className="text-lg">No products found.</p>
          {query && (
            <p className="mt-1 text-sm">Try a different search term.</p>
          )}
        </div>
      ) : (
        <div className="grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-4">
          {products.map((p) => (
            <ProductCard key={p.id} product={p} />
          ))}
        </div>
      )}
    </div>
  );
}
