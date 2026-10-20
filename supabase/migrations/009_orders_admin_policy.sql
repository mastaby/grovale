-- Allow authenticated admin users to view and update order status.
alter table public.orders enable row level security;
drop policy if exists "authenticated users can manage orders" on public.orders;
create policy "authenticated users can manage orders"
  on public.orders
  for all
  to authenticated
  using (true)
  with check (true);

alter table public.order_items enable row level security;
drop policy if exists "authenticated users can view order items" on public.order_items;
create policy "authenticated users can view order items"
  on public.order_items
  for select
  to authenticated
  using (true);
