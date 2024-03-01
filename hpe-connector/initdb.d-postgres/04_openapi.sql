-- -*- sql-product: postgres; -*-

create or replace function root() returns json as $_$
select convert_from(lo_get(oid), 'UTF8')::json from pg_largeobject_metadata limit 1;  
$_$ language sql;
