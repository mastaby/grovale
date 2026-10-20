-- Track rider acceptance separately from the order's operational status.
alter table public.orders add column if not exists rider_accepted boolean not null default false;
