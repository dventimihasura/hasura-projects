-- -*- sql-product: postgres; -*-

create or replace function authorization_accounts_v3 (shard int)
  returns table(id uuid)
  language sql
  stable parallel safe leakproof
as $function$
  select
  id
  from
  (
    select
      id,
      row_number() over (order by name) rownum
      from
	account) foo
  where
  rownum % shard = 0;
  $function$;

create or replace function authorization_accounts_v3_scalar (shard int)
  returns uuid[]
  language sql
  stable parallel safe leakproof
as $function$
  select array_agg(id) as ids from authorization_accounts_v3(shard)
  $function$;

