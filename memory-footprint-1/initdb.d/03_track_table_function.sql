-- -*- sql-product: postgres; -*-

set check_function_bodies = false;

create or replace function track_table (source text)
  returns table (command jsonb)
  language sql
  stable
  parallel safe
as $function$
  select
  jsonb_build_object(
    'type', 'bulk',
    'source', 'default',
    'args', json_build_array(jsonb_build_object(
      'type', 'postgres_track_tables',
      'args', jsonb_build_object(
	'allow_warnings', true,
	'tables', coalesce(json_agg(jsonb_build_object(
	  'source', 'default',
	  'table', jsonb_build_object(
	    'schema', table_schema,
	    'name', table_name))), '[]'))))) command
  from
  information_schema.tables
  where true
  and table_name like 'test_%'
  and not exists (
    select
      *
      from (
	select
	  jsonb_array_elements(metadata::jsonb->'sources'->0->'tables')->'table' y
	  from
	    hdb_catalog.hdb_metadata
	 where true
	   and metadata::jsonb->'sources'->0->'tables' is not null) foo, jsonb_to_record(y) as x(name text, schema text)
     where true
       and name = table_name
       and schema = table_schema)
  $function$;

