-- Allow the existing admin panel to read and update profiles without policy recursion.
-- Order access remains protected by the role-aware policies in migration 014.
do $$
declare policy_record record;
begin
  for policy_record in
    select policyname from pg_policies where schemaname = 'public' and tablename = 'profiles'
  loop
    execute format('drop policy if exists %I on public.profiles', policy_record.policyname);
  end loop;
end;
$$;

alter table public.profiles disable row level security;
