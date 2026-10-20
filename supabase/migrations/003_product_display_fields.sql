-- Optional display fields for richer product tiles.
alter table public.products add column if not exists unit text;
alter table public.products add column if not exists mrp numeric(10,2) check (mrp >= 0);
alter table public.products add column if not exists discount_percentage numeric(5,2) check (discount_percentage >= 0 and discount_percentage <= 100);
alter table public.products add column if not exists delivery_eta text;
