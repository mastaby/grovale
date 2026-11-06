alter table public.orders
  add column if not exists payment_method text not null default 'cash_on_delivery',
  add column if not exists payment_status text not null default 'pending',
  add column if not exists razorpay_order_id text,
  add column if not exists razorpay_payment_id text;

alter table public.orders
  drop constraint if exists orders_payment_method_check,
  add constraint orders_payment_method_check check (payment_method in ('cash_on_delivery','razorpay')),
  drop constraint if exists orders_payment_status_check,
  add constraint orders_payment_status_check check (payment_status in ('pending','paid','failed','refunded'));

