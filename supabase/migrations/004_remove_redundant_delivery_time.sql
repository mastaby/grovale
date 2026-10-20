-- Keep delivery_eta as the product estimate; delivery_slot remains for scheduled orders.
alter table public.products drop column if exists delivery_time;
