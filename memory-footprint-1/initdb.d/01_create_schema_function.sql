-- -*- sql-product: postgres; -*-

set check_function_bodies = false;

create or replace function create_schema (i int)
  returns void
  language plpgsql
  volatile as $function$
begin
  execute
    format($$
	   create schema if not exists test_%s;
	   $$, i);
end
$function$;
