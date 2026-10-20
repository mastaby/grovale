-- Nullable stock keeps existing products available until inventory is configured.
-- NULL means inventory is not being tracked; 0 means out of stock.
alter table public.products
  add column if not exists stock_quantity integer
  check (stock_quantity is null or stock_quantity >= 0);
