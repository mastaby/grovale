create table if not exists public.rider_reviews (
  id uuid primary key default gen_random_uuid(),
  rider_id uuid not null references public.profiles(id) on delete cascade,
  customer_id uuid not null references public.profiles(id) on delete cascade,
  order_id uuid not null references public.orders(id) on delete cascade,
  rating integer not null check (rating between 1 and 5),
  communication integer check (communication between 1 and 5),
  carefulness integer check (carefulness between 1 and 5),
  punctuality integer check (punctuality between 1 and 5),
  tip numeric(10,2) not null default 0 check (tip >= 0),
  created_at timestamptz not null default now(),
  unique(order_id, customer_id)
);

alter table public.rider_reviews enable row level security;
create policy "Customers can view rider reviews" on public.rider_reviews for select using (true);
create policy "Customers can create their rider review" on public.rider_reviews for insert with check (auth.uid() = customer_id);
