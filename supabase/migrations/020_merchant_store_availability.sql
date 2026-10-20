-- Persist merchant store availability so dispatch can exclude closed stores.
alter table public.profiles add column if not exists store_open boolean not null default true;
create index if not exists profiles_merchant_store_open_idx on public.profiles(role, store_open);

create or replace function public.prevent_closed_merchant_assignment()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.merchant_id is not null
     and (tg_op = 'INSERT' or old.merchant_id is distinct from new.merchant_id)
     and exists (select 1 from public.profiles where id = new.merchant_id and role = 'merchant' and store_open = false) then
    raise exception 'Cannot assign an order to a merchant whose store is closed';
  end if;
  return new;
end;
$$;

drop trigger if exists prevent_closed_merchant_assignment on public.orders;
create trigger prevent_closed_merchant_assignment
  before insert or update of merchant_id on public.orders
  for each row execute function public.prevent_closed_merchant_assignment();
