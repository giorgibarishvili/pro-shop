"use client";

import Link from "next/link";
import { useState } from "react";
import {
  BarbellIcon,
  ListIcon,
  ShoppingCartIcon,
  XIcon,
} from "@phosphor-icons/react";
import { Button } from "@/components/ui/button";
import {
  NavigationMenu,
  NavigationMenuContent,
  NavigationMenuItem,
  NavigationMenuLink,
  NavigationMenuList,
  NavigationMenuTrigger,
} from "@/components/ui/navigation-menu";
import SearchBar from "@/components/search/SearchBar";

const navLinks = [
  { href: "/", label: "Home" },
  { href: "/products", label: "Products" },
  { href: "/sale", label: "Sale" },
];

type Category = {
  name: string;
  slug: string;
  description: string | null;
};

export default function Header({ categories }: { categories: Category[] }) {
  const [mobileOpen, setMobileOpen] = useState(false);

  return (
    <>
      <header className="sticky top-0 z-50 border-b border-border/40 bg-[#0A0A0A] text-white">
        <div className="mx-auto flex h-16 max-w-7xl items-center justify-between px-4 sm:px-6 lg:px-8">
          {/* Left: Mobile menu + Logo */}
          <div className="flex items-center gap-3">
            <button
              onClick={() => setMobileOpen(true)}
              className="cursor-pointer rounded-md p-2 hover:bg-white/10 lg:hidden"
              aria-label="Open menu"
            >
              <ListIcon size={24} />
            </button>
            <Link href="/" className="flex items-center gap-2">
              <div className="flex h-8 w-8 items-center justify-center rounded-md bg-primary">
                <BarbellIcon
                  size={18}
                  className="text-primary-foreground"
                  weight="bold"
                />
              </div>
              <span className="text-lg font-bold tracking-tight">Pro Shop</span>
            </Link>
          </div>

          {/* Center: Desktop nav */}
          <nav className="hidden items-center gap-1 lg:flex">
            {navLinks.map((link) => (
              <Link
                key={link.href}
                href={link.href}
                className="rounded-md px-3 py-2 text-sm font-medium text-white/80 transition-colors hover:bg-white/10 hover:text-white"
              >
                {link.label}
              </Link>
            ))}
            {/* Categories dropdown */}
            <NavigationMenu>
              <NavigationMenuList>
                <NavigationMenuItem>
                  <NavigationMenuTrigger className="bg-transparent! px-3 py-2 text-sm font-medium text-white/80! hover:bg-white/10! hover:text-white! focus:bg-white/10! focus:text-white! data-popup-open:bg-white/10! data-popup-open:text-white! data-open:bg-white/10! data-open:text-white!">
                    Categories
                  </NavigationMenuTrigger>
                  <NavigationMenuContent className="w-160 p-3">
                    <ul className="grid grid-cols-2 gap-1">
                      {categories.map((cat) => (
                        <li key={cat.slug}>
                          <NavigationMenuLink
                            className="flex-col! items-start! gap-0.5!"
                            render={
                              <Link href={`/categories/${cat.slug}`}>
                                <div className="text-sm font-medium leading-tight">
                                  {cat.name}
                                </div>
                                {cat.description && (
                                  <p className="line-clamp-2 text-xs leading-snug text-muted-foreground">
                                    {cat.description}
                                  </p>
                                )}
                              </Link>
                            }
                          />
                        </li>
                      ))}
                      <li className="col-span-2 mt-1 border-t pt-2">
                        <NavigationMenuLink
                          render={
                            <Link
                              href="/categories"
                              className="text-sm font-medium"
                            >
                              Browse all categories →
                            </Link>
                          }
                        />
                      </li>
                    </ul>
                  </NavigationMenuContent>
                </NavigationMenuItem>
              </NavigationMenuList>
            </NavigationMenu>
          </nav>

          {/* Right: Search + Cart + Account */}
          <div className="flex items-center gap-2">
            <SearchBar />

            {/* Cart */}
            <Link
              href="/cart"
              className="relative rounded-md p-2 text-white/80 hover:bg-white/10 hover:text-white"
              aria-label="Cart"
            >
              <ShoppingCartIcon size={20} />
              {/* Cart count badge — hardcoded for now */}
              <span className="absolute -right-0.5 -top-0.5 flex h-4 w-4 items-center justify-center rounded-full bg-primary text-[10px] font-bold text-primary-foreground">
                0
              </span>
            </Link>

            {/* Account — placeholder */}
            <Link href="/login" className="hidden lg:block">
              <Button
                variant="outline"
                size="sm"
                className="cursor-pointer border-white/20 hover:bg-white/10"
              >
                Login
              </Button>
            </Link>
          </div>
        </div>
      </header>

      {/* Mobile drawer overlay */}
      {mobileOpen && (
        <div className="fixed inset-0 z-50 lg:hidden">
          {/* Backdrop */}
          <div
            className="fixed inset-0 bg-black/60"
            onClick={() => setMobileOpen(false)}
          />

          {/* Drawer */}
          <div className="fixed inset-y-0 left-0 w-72 bg-[#0A0A0A] text-white shadow-xl">
            <div className="flex h-16 items-center justify-between border-b border-white/10 px-4">
              <Link
                href="/"
                className="flex items-center gap-2"
                onClick={() => setMobileOpen(false)}
              >
                <div className="flex h-8 w-8 items-center justify-center rounded-md bg-primary">
                  <BarbellIcon
                    size={18}
                    className="text-primary-foreground"
                    weight="bold"
                  />
                </div>
                <span className="text-lg font-bold">Pro Shop</span>
              </Link>
              <button
                onClick={() => setMobileOpen(false)}
                className="cursor-pointer rounded-md p-2 hover:bg-white/10"
                aria-label="Close menu"
              >
                <XIcon size={20} />
              </button>
            </div>

            <nav className="flex flex-col gap-1 p-4">
              {navLinks.map((link) => (
                <Link
                  key={link.href}
                  href={link.href}
                  onClick={() => setMobileOpen(false)}
                  className="rounded-md px-3 py-2.5 text-sm font-medium text-white/80 transition-colors hover:bg-white/10 hover:text-white"
                >
                  {link.label}
                </Link>
              ))}
              <div className="my-2 border-t border-white/10" />
              <p className="px-3 pb-1 pt-2 text-xs font-semibold uppercase tracking-wide text-white/40">
                Categories
              </p>
              {categories.map((cat) => (
                <Link
                  key={cat.slug}
                  href={`/categories/${cat.slug}`}
                  onClick={() => setMobileOpen(false)}
                  className="rounded-md px-3 py-2.5 text-sm font-medium text-white/80 transition-colors hover:bg-white/10 hover:text-white"
                >
                  {cat.name}
                </Link>
              ))}
              <Link
                href="/categories"
                onClick={() => setMobileOpen(false)}
                className="rounded-md px-3 py-2.5 text-sm font-medium text-white/60 transition-colors hover:bg-white/10 hover:text-white"
              >
                Browse all →
              </Link>

              <div className="my-3 border-t border-white/10" />

              <Link
                href="/login"
                onClick={() => setMobileOpen(false)}
                className="rounded-md px-3 py-2.5 text-sm font-medium text-white/80 transition-colors hover:bg-white/10 hover:text-white"
              >
                Login
              </Link>
              <Link
                href="/register"
                onClick={() => setMobileOpen(false)}
                className="rounded-md px-3 py-2.5 text-sm font-medium text-white/80 transition-colors hover:bg-white/10 hover:text-white"
              >
                Register
              </Link>
            </nav>
          </div>
        </div>
      )}
    </>
  );
}
