-- Canonical pricing/category fields are price, mrp, discount_percentage, and category_id.
alter table public.products drop column if exists old_price;
alter table public.products drop column if exists discount;
alter table public.products drop column if exists category_slug;
