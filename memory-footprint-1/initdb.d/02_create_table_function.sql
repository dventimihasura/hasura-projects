-- -*- sql-product: postgres; -*-

set check_function_bodies = false;

create or replace function create_table (schema_name text, columns int, i int)
  returns void
  language plpgsql
  volatile as $function$
  declare
    column_template text;
  fk_template text;
begin
  select
    array_to_string(array(
      select
	format('column_%s text', idx)
	from (
	  select
	    generate_series(1, 10) idx) foo), ', ') into column_template;
  select
    case when i>1 then format('references %2$s.test_%1$s (id)',
			      i - 1,
			      schema_name) end
    from
      information_schema.tables
   where table_schema = schema_name into fk_template;
  execute
    format($$
	   create table if not exists %4$s.test_%1$s (
	     id uuid primary key default gen_random_uuid(),
	     parent_id uuid not null %3$s,
	     %2$s
	   )
	   $$, i, column_template, fk_template, schema_name);
end
$function$;
