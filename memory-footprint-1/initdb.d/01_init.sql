-- -*- sql-product: postgres; -*-

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

create or replace function track_table (source text)
  returns table (command jsonb)
  language sql
  immutable
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
       and schema = table_schema);
  $function$;

  create or replace function create_permissions (role text)
    returns table (command jsonb)
    language sql
    immutable
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

  -- select
  --   create_schema(i)
  --   from (
  --     select
  -- 	generate_series(1, 1) i) foo;

  -- select
  --   create_table(schema_name, 10, i)
  --   from (
  --     select
  -- 	schema_name,
  -- 	generate_series(1, 10) i
  -- 	from
  -- 	  information_schema.schemata
  --      where schema_name like 'test_%') foo;
