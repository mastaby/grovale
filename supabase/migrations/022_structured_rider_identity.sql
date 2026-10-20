-- Store rider identity and emergency contact details in dedicated fields.
alter table public.profiles
  add column if not exists aadhaar_number text,
  add column if not exists emergency_contact_name text;
