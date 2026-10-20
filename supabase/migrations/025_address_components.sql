alter table public.addresses add column if not exists district text;
alter table public.addresses add column if not exists city text;
alter table public.addresses add column if not exists state text;

alter table public.orders add column if not exists district text;
alter table public.orders add column if not exists city text;
alter table public.orders add column if not exists state text;

alter table public.saved_delivery_profiles add column if not exists district text;
alter table public.saved_delivery_profiles add column if not exists city text;
alter table public.saved_delivery_profiles add column if not exists state text;
