-- -*- sql-product: postgres; -*-

set check_function_bodies = false;

create or replace function create_permissions (role text)
  returns table (command jsonb)
  language sql
  stable
  parallel safe
as $function$
  select
  jsonb_build_object(
    'type', 'bulk',
    'source', 'default',
    'args', jsonb_build_array(jsonb_build_object(
      'type', 'pg_create_select_permission',
      'args', jsonb_build_object(
	'table', jsonb_build_object('name', table_name, 'schema', table_schema),
	'role', role,
	'source', 'default',
	'permission', jsonb_build_object(
	  'subscription_root_fields', null,
	  'query_root_fields', null,
	  'computed_fields', '[]'::jsonb,
	  'backend_only', false,
	  'filter', jsonb_build_object(),
	  'limit', null,
	  'allow_aggregations', false,
	  'columns', (select json_agg(column_name) from (select column_name from information_schema.columns where table_schema = tables.table_schema and table_name = tables.table_name) foo)))))) args
  from
  information_schema.tables
  where true
  and table_schema like 'test_%'
  and not exists (
    select * from (select jsonb_path_query(metadata::jsonb->'sources'->0, '$.tables[*]?(exists (@.select_permissions[*]?(@.role==$role))).table', format('{"role":"%s"}', role)::jsonb) y from hdb_catalog.hdb_metadata) foo, jsonb_to_record(y) as x(name text, schema text)
     where true
       and name = table_name
       and schema = table_schema);
  $function$;

