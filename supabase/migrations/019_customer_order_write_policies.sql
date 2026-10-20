-- Allow signed-in customers to create and maintain only their own orders.
alter table public.orders enable row level security;
alter table public.order_items enable row level security;

drop policy if exists "Customers can create their own orders" on public.orders;
create policy "Customers can create their own orders"
  on public.orders
  for insert
  to authenticated
  with check (auth.uid() = user_id);

drop policy if exists "Customers can update their own orders" on public.orders;
create policy "Customers can update their own orders"
  on public.orders
  for update
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Customers can create their own order items" on public.order_items;
create policy "Customers can create their own order items"
  on public.order_items
  for insert
  to authenticated
  with check (
    exists (
      select 1
      from public.orders o
      where o.id = order_id
        and o.user_id = auth.uid()
    )
  );
