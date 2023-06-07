-- -*- sql-product: postgres; -*-

set check_function_bodies = false;

create or replace function create_metadata (role_start int, role_end int)
  returns table (metadata jsonb)
  language sql
  stable
  parallel safe
as $function$
  select
  jsonb_build_object(
    'type', 'bulk',
    'source', 'default',
    'args', jsonb_build_array(
      jsonb_build_object(
	'type', 'replace_metadata',
	'args', jsonb_build_object(
	  'version', 3,
	  'sources', jsonb_agg(x)))))
  from (
    select
      jsonb_build_object(
	'configuration', '{"connection_info":{"database_url":{"from_env":"HASURA_GRAPHQL_DATABASE_URL"},"isolation_level":"read-committed","pool_settings":{"connection_lifetime":600,"idle_timeout":180,"max_connections":50,"retries":1},"use_prepared_statements":true}}'::jsonb,
	'name', catalog_name,
	'kind', 'postgres',
	'tables', (
	  select
	    jsonb_agg(x)
	    from (
	      select
		jsonb_build_object(
		  'select_permissions', (
		    select
		      jsonb_agg(x)
		      from (
			select
			  jsonb_build_object(
			    'role', format('role_%s', generate_series),
			    'permission', jsonb_build_object(
			      'filter', jsonb_build_object(),
			      'columns', (
				select
				  jsonb_agg(x)
				  from (
				    select
				      column_name x
				      from
					information_schema.columns
				     where table_name = tables.table_name) foo))) x
			  from
			    generate_series(1, 2)) foo),
			    'table', jsonb_build_object(
			      'name', table_name,
			      'schema', table_schema)) x
		from
		  information_schema.tables
	       where true
		 and table_name like 'test_%'
		 and catalog_name = information_schema_catalog_name.catalog_name) foo)) x
      from
	information_schema.information_schema_catalog_name) foo;
  $function$;
