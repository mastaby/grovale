alter table public.orders
  add column if not exists delivery_failure_reason text;
