-- Allow signed-in admin users to create and update catalog products.
-- Customer-facing product reads remain public through the existing policies.
alter table public.products enable row level security;

drop policy if exists "authenticated users can manage products" on public.products;
create policy "authenticated users can manage products"
  on public.products
  for all
  to authenticated
  using (true)
  with check (true);
