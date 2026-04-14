import Link from "next/link";
import Image from "next/image";
import { StarIcon } from "@phosphor-icons/react/dist/ssr";
import type { ProductListItem } from "@/lib/types/product";

function formatPrice(p: number) {
  return `$${p.toFixed(2)}`;
}

export default function ProductCard({ product }: { product: ProductListItem }) {
  const onSale = product.sale_price != null && product.sale_price < product.price;

  return (
    <Link
      href={`/products/${product.slug}`}
      className="group flex flex-col overflow-hidden rounded-lg border border-border/60 bg-card transition-all hover:border-primary/40 hover:shadow-lg"
    >
      {/* Image */}
      <div className="relative aspect-square w-full bg-muted">
        {product.image_url ? (
          <Image
            src={product.image_url}
            alt={product.name}
            fill
            sizes="(max-width: 640px) 50vw, (max-width: 1024px) 33vw, 25vw"
            className="object-cover transition-transform duration-300 group-hover:scale-105"
          />
        ) : (
          <div className="flex h-full w-full items-center justify-center text-muted-foreground">
            No image
          </div>
        )}
        {onSale && (
          <div className="absolute left-2 top-2 rounded-md bg-primary px-2 py-0.5 text-xs font-bold text-primary-foreground">
            SALE
          </div>
        )}
      </div>

      {/* Body */}
      <div className="flex flex-1 flex-col gap-1.5 p-3">
        {product.category_name && (
          <div className="text-xs uppercase tracking-wide text-muted-foreground">
            {product.category_name}
          </div>
        )}
        <h3 className="line-clamp-2 text-sm font-semibold leading-tight">
          {product.name}
        </h3>
        <div className="text-xs text-muted-foreground">{product.brand}</div>

        <div className="mt-auto flex items-center justify-between pt-2">
          <div className="flex items-baseline gap-2">
            {onSale ? (
              <>
                <span className="text-base font-bold text-primary">
                  {formatPrice(product.sale_price!)}
                </span>
                <span className="text-xs text-muted-foreground line-through">
                  {formatPrice(product.price)}
                </span>
              </>
            ) : (
              <span className="text-base font-bold">
                {formatPrice(product.price)}
              </span>
            )}
          </div>
          {product.rating > 0 && (
            <div className="flex items-center gap-0.5 text-xs text-muted-foreground">
              <StarIcon size={12} weight="fill" className="text-yellow-500" />
              {product.rating.toFixed(1)}
            </div>
          )}
        </div>
      </div>
    </Link>
  );
}
