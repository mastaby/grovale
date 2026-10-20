insert into storage.buckets (id, name, public)
values ('product-images', 'product-images', true)
on conflict (id) do update set public=true;

drop policy if exists "public can view product images" on storage.objects;
create policy "public can view product images" on storage.objects for select using (bucket_id='product-images');
drop policy if exists "authenticated users can upload product images" on storage.objects;
create policy "authenticated users can upload product images" on storage.objects for insert to authenticated with check (bucket_id='product-images');
drop policy if exists "authenticated users can delete product images" on storage.objects;
create policy "authenticated users can delete product images" on storage.objects for delete to authenticated using (bucket_id='product-images');
