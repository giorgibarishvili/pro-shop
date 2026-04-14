import dynamic from "next/dynamic";
import { HelpCircle, type LucideIcon, type LucideProps } from "lucide-react";

/**
 * Converts a DB icon name like "flask-conical" into a PascalCase Lucide icon name
 * and dynamically imports it. Falls back to HelpCircle if missing.
 *
 * Lucide ships ~1400 icons; we only load the one we need per category.
 */
function toPascal(kebab: string): string {
  return kebab
    .split("-")
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
    .join("");
}

export default function CategoryIcon({
  name,
  ...props
}: { name: string } & LucideProps) {
  const pascal = toPascal(name);
  const Icon = dynamic(
    () =>
      import("lucide-react").then((mod) => {
        const Resolved = (mod as unknown as Record<string, LucideIcon>)[pascal];
        return Resolved ?? HelpCircle;
      }),
    { ssr: true },
  );
  return <Icon {...props} />;
}
