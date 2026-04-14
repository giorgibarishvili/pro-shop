export type SearchProduct = {
  id: string;
  name: string;
  slug: string;
  brand: string;
  price: number;
  sale_price: number | null;
  image_url: string | null;
  rating: number;
  stock: number;
  rank?: number;
};

export type ProductListItem = SearchProduct & {
  category_name: string | null;
  category_slug: string | null;
};
