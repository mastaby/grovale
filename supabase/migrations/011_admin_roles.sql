alter table public.profiles add column if not exists role text not null default 'customer' check (role in ('customer','admin'));

drop policy if exists "authenticated users can manage products" on public.products;
create policy "admins can manage products" on public.products for all to authenticated
  using (exists (select 1 from public.profiles p where p.id=auth.uid() and p.role='admin'))
  with check (exists (select 1 from public.profiles p where p.id=auth.uid() and p.role='admin'));

drop policy if exists "authenticated users can manage orders" on public.orders;
create policy "admins can manage orders" on public.orders for all to authenticated
  using (exists (select 1 from public.profiles p where p.id=auth.uid() and p.role='admin'))
  with check (exists (select 1 from public.profiles p where p.id=auth.uid() and p.role='admin'));

drop policy if exists "authenticated users can view order items" on public.order_items;
create policy "admins can view order items" on public.order_items for select to authenticated
  using (exists (select 1 from public.profiles p where p.id=auth.uid() and p.role='admin'));
