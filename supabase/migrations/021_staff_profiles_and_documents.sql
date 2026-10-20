-- Structured merchant/rider profile data and private verification documents.
alter table public.profiles
  add column if not exists profile_photo_url text,
  add column if not exists store_logo_url text,
  add column if not exists business_name text,
  add column if not exists store_address text,
  add column if not exists business_category text,
  add column if not exists gst_number text,
  add column if not exists opening_hours text,
  add column if not exists preparation_time text,
  add column if not exists order_acceptance text not null default 'automatic',
  add column if not exists vehicle_type text,
  add column if not exists vehicle_registration text,
  add column if not exists driving_license text,
  add column if not exists delivery_area text,
  add column if not exists emergency_contact text,
  add column if not exists availability_schedule text,
  add column if not exists availability_calendar text,
  add column if not exists delivery_preferences text,
  add column if not exists notification_preferences text not null default 'all',
  add column if not exists language text not null default 'English',
  add column if not exists approval_status text not null default 'pending',
  add column if not exists approval_notes text,
  add column if not exists approved_at timestamptz,
  add column if not exists approved_by uuid references public.profiles(id) on delete set null,
  add column if not exists payout_details text;

-- Keep this migration safe if the earlier store-availability migration was skipped.
alter table public.profiles
  add column if not exists store_open boolean not null default true;

create index if not exists profiles_role_approval_idx on public.profiles(role, approval_status);
create index if not exists profiles_store_open_idx on public.profiles(role, store_open);

insert into storage.buckets (id, name, public)
values ('profile-documents', 'profile-documents', false)
on conflict (id) do update set public = false;

drop policy if exists "staff can upload own profile documents" on storage.objects;
create policy "staff can upload own profile documents" on storage.objects
for insert to authenticated
with check (bucket_id = 'profile-documents' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "staff can view own profile documents" on storage.objects;
create policy "staff can view own profile documents" on storage.objects
for select to authenticated
using (bucket_id = 'profile-documents' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "staff can update own profile documents" on storage.objects;
create policy "staff can update own profile documents" on storage.objects
for update to authenticated
using (bucket_id = 'profile-documents' and (storage.foldername(name))[1] = auth.uid()::text)
with check (bucket_id = 'profile-documents' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "staff can delete own profile documents" on storage.objects;
create policy "staff can delete own profile documents" on storage.objects
for delete to authenticated
using (bucket_id = 'profile-documents' and (storage.foldername(name))[1] = auth.uid()::text);
