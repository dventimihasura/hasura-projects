-- -*- sql-product: postgres; -*-

create function authorization_accounts_v3 ()
  returns table (
    id uuid)
  language sql
  stable
  leakproof
  parallel safe
as $$
  select id from account limit 10;
$$;
