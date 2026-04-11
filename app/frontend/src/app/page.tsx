import { Dumbbell, ShoppingCart, Search } from "lucide-react";
import { Button } from "@/components/ui/button";

export default function Home() {
  return (
    <div className="flex flex-1 flex-col items-center justify-center gap-12 p-8">
      {/* Logo & Title */}
      <div className="flex flex-col items-center gap-4">
        <div className="flex h-16 w-16 items-center justify-center rounded-lg bg-primary">
          <Dumbbell className="h-8 w-8 text-primary-foreground" />
        </div>
        <h1 className="text-4xl font-bold tracking-tight">Pro Shop</h1>
        <p className="text-muted-foreground text-lg">
          Gym supplements store — coming soon
        </p>
      </div>

      {/* Design preview: buttons */}
      <div className="flex flex-wrap items-center justify-center gap-4">
        <Button size="lg">
          <ShoppingCart className="mr-2 h-4 w-4" />
          Add to Cart
        </Button>
        <Button variant="secondary" size="lg">
          <Search className="mr-2 h-4 w-4" />
          Browse Products
        </Button>
        <Button variant="outline" size="lg">
          View Sale
        </Button>
      </div>

      {/* Design preview: cards */}
      <div className="grid w-full max-w-3xl grid-cols-1 gap-6 sm:grid-cols-3">
        {["Whey Protein", "Creatine", "Pre-Workout"].map((name) => (
          <div
            key={name}
            className="rounded-lg bg-card p-6 shadow-sm transition-shadow hover:shadow-md"
          >
            <div className="mb-4 h-32 rounded-lg bg-muted" />
            <h3 className="font-semibold">{name}</h3>
            <p className="text-sm text-muted-foreground">Premium quality</p>
            <div className="mt-3 flex items-center justify-between">
              <span className="text-lg font-bold">$29.99</span>
              <span className="rounded-lg bg-primary px-2 py-1 text-xs font-semibold text-primary-foreground">
                SALE
              </span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
