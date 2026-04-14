"use client";

import { useEffect, useRef, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import Image from "next/image";
import { MagnifyingGlassIcon, XIcon } from "@phosphor-icons/react";
import { createClient } from "@/lib/supabase/client";
import type { ProductListItem } from "@/lib/types/product";

const DEBOUNCE_MS = 200;
const MIN_CHARS = 2;
const RESULT_LIMIT = 5;

function formatPrice(p: number) {
  return `$${p.toFixed(2)}`;
}

export default function SearchBar() {
  const router = useRouter();
  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState("");
  const [results, setResults] = useState<ProductListItem[]>([]);
  const [loading, setLoading] = useState(false);

  const containerRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  // Focus input when opened
  useEffect(() => {
    if (open) inputRef.current?.focus();
  }, [open]);

  // Close on outside click
  useEffect(() => {
    if (!open) return;
    function handler(e: MouseEvent) {
      if (containerRef.current && !containerRef.current.contains(e.target as Node)) {
        setOpen(false);
      }
    }
    document.addEventListener("mousedown", handler);
    return () => document.removeEventListener("mousedown", handler);
  }, [open]);

  // Close on Esc
  useEffect(() => {
    if (!open) return;
    function handler(e: KeyboardEvent) {
      if (e.key === "Escape") setOpen(false);
    }
    document.addEventListener("keydown", handler);
    return () => document.removeEventListener("keydown", handler);
  }, [open]);

  // Debounced search
  useEffect(() => {
    const q = query.trim();
    if (q.length < MIN_CHARS) {
      setResults([]);
      setLoading(false);
      return;
    }
    setLoading(true);
    const timer = setTimeout(async () => {
      const supabase = createClient();
      // Call RPC directly — we skip the helper here to keep one client-side bundle
      const { data: rpcData, error } = await supabase.rpc("search_products", {
        search_query: q,
        result_limit: RESULT_LIMIT,
        result_offset: 0,
      });
      if (error) {
        console.error(error);
        setResults([]);
        setLoading(false);
        return;
      }
      const products = (rpcData ?? []) as ProductListItem[];
      // Fetch primary category for each
      if (products.length > 0) {
        const { data: pcs } = await supabase
          .from("product_categories")
          .select("product_id, categories(name, slug)")
          .in("product_id", products.map((p) => p.id));
        const catMap = new Map<string, { name: string; slug: string }>();
        for (const row of pcs ?? []) {
          if (catMap.has(row.product_id)) continue;
          // @ts-expect-error single joined row
          const cat = row.categories as { name: string; slug: string } | null;
          if (cat) catMap.set(row.product_id, cat);
        }
        for (const p of products) {
          p.category_name = catMap.get(p.id)?.name ?? null;
          p.category_slug = catMap.get(p.id)?.slug ?? null;
        }
      }
      setResults(products);
      setLoading(false);
    }, DEBOUNCE_MS);
    return () => clearTimeout(timer);
  }, [query]);

  function submit() {
    const q = query.trim();
    if (!q) {
      setOpen(true);
      return;
    }
    router.push(`/products?q=${encodeURIComponent(q)}`);
    setOpen(false);
  }

  function handleKey(e: React.KeyboardEvent<HTMLInputElement>) {
    if (e.key === "Enter") submit();
  }

  return (
    <div ref={containerRef} className="relative flex items-center">
      {/* Expanding input */}
      <input
        ref={inputRef}
        type="text"
        placeholder="Search supplements…"
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        onKeyDown={handleKey}
        className={`h-9 rounded-md bg-white/10 pl-3 text-sm text-white placeholder:text-white/50 outline-none ring-1 ring-white/10 transition-all duration-300 focus:ring-white/30 ${
          open ? "w-56 pr-16 opacity-100 md:w-72" : "pointer-events-none w-0 pr-0 opacity-0"
        }`}
        aria-hidden={!open}
        tabIndex={open ? 0 : -1}
      />

      {/* Clear button — only when input has text */}
      {open && query && (
        <button
          type="button"
          onClick={() => {
            setQuery("");
            inputRef.current?.focus();
          }}
          className="absolute right-9 cursor-pointer rounded-md p-1 text-white/60 hover:bg-white/10 hover:text-white"
          aria-label="Clear search"
        >
          <XIcon size={14} />
        </button>
      )}

      {/* Search/submit icon — stays anchored right; input grows behind it */}
      <button
        type="button"
        onClick={() => (open ? submit() : setOpen(true))}
        className="absolute right-0 cursor-pointer rounded-md p-2 text-white/80 transition-colors hover:bg-white/10 hover:text-white"
        aria-label={open ? "Submit search" : "Open search"}
      >
        <MagnifyingGlassIcon size={20} />
      </button>

      {/* Results dropdown */}
      {open && query.trim().length >= MIN_CHARS && (
        <div className="absolute right-0 top-full z-50 mt-2 w-80 overflow-hidden rounded-lg border border-white/10 bg-[#0A0A0A] shadow-xl md:w-96">
          {loading ? (
            <div className="px-4 py-6 text-center text-sm text-white/60">
              Searching…
            </div>
          ) : results.length === 0 ? (
            <div className="px-4 py-6 text-center text-sm text-white/60">
              No results for &ldquo;{query}&rdquo;
            </div>
          ) : (
            <>
              <ul className="max-h-96 overflow-y-auto py-1">
                {results.map((p) => (
                  <li key={p.id}>
                    <Link
                      href={`/products/${p.slug}`}
                      onClick={() => setOpen(false)}
                      className="flex items-center gap-3 px-3 py-2 text-white transition-colors hover:bg-white/10"
                    >
                      {/* Thumbnail */}
                      <div className="relative h-12 w-12 flex-shrink-0 overflow-hidden rounded-md bg-white/5">
                        {p.image_url ? (
                          <Image
                            src={p.image_url}
                            alt={p.name}
                            fill
                            sizes="48px"
                            className="object-cover"
                          />
                        ) : (
                          <div className="flex h-full w-full items-center justify-center text-white/30">
                            <MagnifyingGlassIcon size={16} />
                          </div>
                        )}
                      </div>
                      {/* Text */}
                      <div className="min-w-0 flex-1">
                        <div className="truncate text-sm font-medium">{p.name}</div>
                        <div className="truncate text-xs text-white/50">
                          {p.category_name ?? p.brand}
                        </div>
                      </div>
                      {/* Price */}
                      <div className="text-sm font-semibold tabular-nums">
                        {p.sale_price ? (
                          <span className="text-primary">
                            {formatPrice(p.sale_price)}
                          </span>
                        ) : (
                          <span>{formatPrice(p.price)}</span>
                        )}
                      </div>
                    </Link>
                  </li>
                ))}
              </ul>
              <Link
                href={`/products?q=${encodeURIComponent(query.trim())}`}
                onClick={() => setOpen(false)}
                className="block border-t border-white/10 px-4 py-2.5 text-center text-sm font-medium text-primary hover:bg-white/5"
              >
                See all results for &ldquo;{query.trim()}&rdquo; →
              </Link>
            </>
          )}
        </div>
      )}
    </div>
  );
}
