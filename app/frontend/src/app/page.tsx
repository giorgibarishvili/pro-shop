import { Button } from "@/components/ui/button";
import Link from "next/link";

export default function Home() {
  return (
    <div className="flex flex-col">
      {/* Hero */}
      <section className="bg-[#0A0A0A] px-4 py-20 text-white sm:px-6 lg:px-8">
        <div className="mx-auto max-w-7xl text-center">
          <h1 className="text-4xl font-bold tracking-tight sm:text-5xl lg:text-6xl">
            Fuel Your <span className="text-primary">Performance</span>
          </h1>
          <p className="mx-auto mt-4 max-w-2xl text-lg text-white/60">
            Premium gym supplements to power your workouts and recovery.
          </p>
          <div className="mt-8 flex flex-wrap items-center justify-center gap-4">
            <Link href="/products">
              <Button size="lg">Shop Supplements</Button>
            </Link>
            <Link href="/sale">
              <Button variant="outline" size="lg" className="border-white/20 bg-white/10 text-white hover:bg-white/20">
                View Sale
              </Button>
            </Link>
          </div>
        </div>
      </section>

      {/* Featured Products placeholder */}
      <section className="px-4 py-16 sm:px-6 lg:px-8">
        <div className="mx-auto max-w-7xl">
          <h2 className="text-2xl font-bold tracking-tight">Featured Products</h2>
          <p className="mt-1 text-muted-foreground">Hand-picked supplements for you</p>
          <div className="mt-8 grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4">
            {["Whey Protein", "Creatine", "Pre-Workout", "BCAAs"].map((name) => (
              <div
                key={name}
                className="rounded-lg border bg-card p-6 transition-shadow hover:shadow-md"
              >
                <div className="mb-4 h-40 rounded-md bg-muted" />
                <h3 className="font-semibold">{name}</h3>
                <p className="text-sm text-muted-foreground">Premium quality</p>
                <div className="mt-3 flex items-center justify-between">
                  <span className="text-lg font-bold">$29.99</span>
                  <span className="rounded-md bg-primary px-2 py-1 text-xs font-semibold text-primary-foreground">
                    SALE
                  </span>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Categories placeholder */}
      <section className="border-t bg-muted/50 px-4 py-16 sm:px-6 lg:px-8">
        <div className="mx-auto max-w-7xl">
          <h2 className="text-2xl font-bold tracking-tight">Shop by Category</h2>
          <p className="mt-1 text-muted-foreground">Find what you need</p>
          <div className="mt-8 grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-5">
            {["Protein", "Creatine", "Pre-Workout", "Vitamins", "Recovery"].map(
              (name) => (
                <div
                  key={name}
                  className="flex flex-col items-center gap-3 rounded-lg border bg-card p-6 transition-shadow hover:shadow-md"
                >
                  <div className="flex h-16 w-16 items-center justify-center rounded-full bg-primary/10 ring-2 ring-primary/20">
                    <div className="h-6 w-6 rounded-full bg-primary/30" />
                  </div>
                  <span className="text-sm font-medium">{name}</span>
                </div>
              )
            )}
          </div>
        </div>
      </section>
    </div>
  );
}
