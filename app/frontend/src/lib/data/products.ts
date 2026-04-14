import type { SupabaseClient } from "@supabase/supabase-js";
import type { ProductListItem, SearchProduct } from "@/lib/types/product";

/**
 * Full-text search via the `search_products` RPC (uses GIN index on search_vector).
 * Returns raw product rows + rank; category join happens separately.
 */
export async function searchProducts(
  supabase: SupabaseClient,
  query: string,
  limit = 20,
  offset = 0,
): Promise<SearchProduct[]> {
  const { data, error } = await supabase.rpc("search_products", {
    search_query: query,
    result_limit: limit,
    result_offset: offset,
  });
  if (error) throw error;
  return (data ?? []) as SearchProduct[];
}

/**
 * Fetches primary category (first one) for a batch of product IDs.
 * Uses the product_categories junction + categories join in a single query.
 */
async function fetchPrimaryCategories(
  supabase: SupabaseClient,
  productIds: string[],
): Promise<Map<string, { name: string; slug: string }>> {
  if (productIds.length === 0) return new Map();

  const { data, error } = await supabase
    .from("product_categories")
    .select("product_id, categories(name, slug)")
    .in("product_id", productIds);

  if (error) throw error;

  const map = new Map<string, { name: string; slug: string }>();
  for (const row of data ?? []) {
    if (map.has(row.product_id)) continue; // keep first
    // @ts-expect-error — Supabase returns a single joined row, not array, when 1:1 on FK
    const cat = row.categories as { name: string; slug: string } | null;
    if (cat) map.set(row.product_id, cat);
  }
  return map;
}

/**
 * Attaches primary category to each product.
 */
export async function attachCategories(
  supabase: SupabaseClient,
  products: SearchProduct[],
): Promise<ProductListItem[]> {
  const catMap = await fetchPrimaryCategories(
    supabase,
    products.map((p) => p.id),
  );
  return products.map((p) => ({
    ...p,
    category_name: catMap.get(p.id)?.name ?? null,
    category_slug: catMap.get(p.id)?.slug ?? null,
  }));
}

/**
 * List all products (no search) — for /products with no query.
 * Uses created_at DESC index.
 */
export async function listAllProducts(
  supabase: SupabaseClient,
  limit = 50,
): Promise<SearchProduct[]> {
  const { data, error } = await supabase
    .from("products")
    .select(
      "id, name, slug, brand, price, sale_price, image_url, rating, stock",
    )
    .order("created_at", { ascending: false })
    .limit(limit);
  if (error) throw error;
  return (data ?? []) as SearchProduct[];
}
