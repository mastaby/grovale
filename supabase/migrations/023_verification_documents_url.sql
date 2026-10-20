alter table public.profiles
  add column if not exists verification_documents_url text;
