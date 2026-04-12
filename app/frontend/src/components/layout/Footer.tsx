import Link from "next/link";
import { BarbellIcon } from "@phosphor-icons/react/ssr";

export default function Footer() {
  return (
    <footer className="border-t border-border bg-[#0A0A0A] text-white">
      <div className="mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 gap-8 sm:grid-cols-2 lg:grid-cols-4">
          {/* Brand */}
          <div className="space-y-3">
            <div className="flex items-center gap-2">
              <div className="flex h-8 w-8 items-center justify-center rounded-md bg-primary">
                <BarbellIcon
                  size={18}
                  className="text-primary-foreground"
                  weight="bold"
                />
              </div>
              <span className="text-lg font-bold">Pro Shop</span>
            </div>
            <p className="text-sm text-white/60">
              Premium gym supplements for your fitness journey.
            </p>
          </div>

          {/* Shop */}
          <div>
            <h3 className="mb-3 text-sm font-semibold uppercase tracking-wider text-white/40">
              Shop
            </h3>
            <ul className="space-y-2">
              {[
                { href: "/products", label: "All Products" },
                { href: "/categories", label: "Categories" },
                { href: "/sale", label: "Sale" },
              ].map((link) => (
                <li key={link.href}>
                  <Link
                    href={link.href}
                    className="text-sm text-white/60 transition-colors hover:text-white"
                  >
                    {link.label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          {/* Account */}
          <div>
            <h3 className="mb-3 text-sm font-semibold uppercase tracking-wider text-white/40">
              Account
            </h3>
            <ul className="space-y-2">
              {[
                { href: "/login", label: "Login" },
                { href: "/register", label: "Register" },
                { href: "/cart", label: "Cart" },
              ].map((link) => (
                <li key={link.href}>
                  <Link
                    href={link.href}
                    className="text-sm text-white/60 transition-colors hover:text-white"
                  >
                    {link.label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          {/* Info */}
          <div>
            <h3 className="mb-3 text-sm font-semibold uppercase tracking-wider text-white/40">
              Info
            </h3>
            <p className="text-sm text-white/60">
              This is a demo project built for learning purposes. No real
              transactions are processed.
            </p>
          </div>
        </div>

        <div className="mt-10 border-t border-white/10 pt-6 text-center text-sm text-white/40">
          &copy; {new Date().getFullYear()} Pro Shop. All rights reserved.
        </div>
      </div>
    </footer>
  );
}
