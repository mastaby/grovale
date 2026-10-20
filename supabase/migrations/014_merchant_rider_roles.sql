-- Add merchant and rider roles plus assignment fields for multi-role operations.
alter table public.profiles drop constraint if exists profiles_role_check;
alter table public.profiles add constraint profiles_role_check
  check (role in ('customer','admin','owner','manager','merchant','rider','order_operator'));

alter table public.orders add column if not exists merchant_id uuid references public.profiles(id) on delete set null;
alter table public.orders add column if not exists rider_id uuid references public.profiles(id) on delete set null;
create index if not exists orders_merchant_id_idx on public.orders(merchant_id);
create index if not exists orders_rider_id_idx on public.orders(rider_id);

-- Replace broad operations access with role-aware access while preserving admin control.
drop policy if exists "operations roles can manage orders" on public.orders;
drop policy if exists "operations roles can view orders" on public.orders;
drop policy if exists "operations roles can update orders" on public.orders;
create policy "operations roles can view orders" on public.orders for select to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid()
        and (p.role in ('admin','owner','manager','order_operator')
          or (p.role = 'merchant' and merchant_id = auth.uid())
          or (p.role = 'rider' and rider_id = auth.uid()))
    )
  );

create policy "operations roles can update orders" on public.orders for update to authenticated
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid()
        and (p.role in ('admin','owner','manager','order_operator')
          or (p.role = 'merchant' and merchant_id = auth.uid())
          or (p.role = 'rider' and rider_id = auth.uid()))
    )
  )
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid()
        and (p.role in ('admin','owner','manager','order_operator')
          or (p.role = 'merchant' and merchant_id = auth.uid())
          or (p.role = 'rider' and rider_id = auth.uid()))
    )
  );

drop policy if exists "operations roles can view order items" on public.order_items;
drop policy if exists "operations roles can view assigned order items" on public.order_items;
create policy "operations roles can view assigned order items" on public.order_items for select to authenticated
  using (
    exists (
      select 1 from public.orders o
      join public.profiles p on p.id = auth.uid()
      where o.id = order_id
        and (p.role in ('admin','owner','manager','order_operator')
          or (p.role = 'merchant' and o.merchant_id = auth.uid())
          or (p.role = 'rider' and o.rider_id = auth.uid()))
    )
  );
