-- Expand admin roles while keeping the existing admin role working.
alter table public.profiles drop constraint if exists profiles_role_check;
alter table public.profiles add constraint profiles_role_check check (role in ('customer','admin','owner','manager','order_operator'));

drop policy if exists "admins can manage products" on public.products;
drop policy if exists "catalog managers can manage products" on public.products;
create policy "catalog managers can manage products" on public.products for all to authenticated
  using (exists (select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','owner','manager')))
  with check (exists (select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','owner','manager')));

drop policy if exists "admins can manage orders" on public.orders;
drop policy if exists "operations roles can manage orders" on public.orders;
create policy "operations roles can manage orders" on public.orders for all to authenticated
  using (exists (select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','owner','manager','order_operator')))
  with check (exists (select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','owner','manager','order_operator')));

drop policy if exists "admins can view order items" on public.order_items;
drop policy if exists "operations roles can view order items" on public.order_items;
create policy "operations roles can view order items" on public.order_items for select to authenticated
  using (exists (select 1 from public.profiles p where p.id=auth.uid() and p.role in ('admin','owner','manager','order_operator')));
