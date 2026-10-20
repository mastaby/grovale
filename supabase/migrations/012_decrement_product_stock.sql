-- Decrement tracked inventory atomically when an order is placed.
-- NULL stock remains unlimited; zero or insufficient stock rejects the whole operation.
create or replace function public.decrement_product_stock(items jsonb)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  item jsonb;
  product_key text;
  requested integer;
begin
  for item in select * from jsonb_array_elements(items)
  loop
    product_key := item->>'product_id';
    requested := (item->>'quantity')::integer;
    if requested is null or requested <= 0 then
      raise exception 'Invalid stock quantity';
    end if;

    update public.products
      set stock_quantity = stock_quantity - requested
      where id::text = product_key
        and stock_quantity is not null
        and stock_quantity >= requested;

    if not found then
      if not exists (select 1 from public.products where id::text = product_key) then
        raise exception 'Product not found';
      elsif exists (select 1 from public.products where id::text = product_key and stock_quantity is not null and stock_quantity < requested) then
        raise exception 'Insufficient stock';
      end if;
    end if;
  end loop;
end;
$$;

grant execute on function public.decrement_product_stock(jsonb) to authenticated;
