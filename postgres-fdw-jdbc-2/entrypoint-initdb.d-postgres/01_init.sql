create extension if not exists jdbc_fdw;

create or replace function create_server (jdbc_driver text, jdbc_url text, jdbc_jarfile text, server text)
  returns void
  language plpgsql
  volatile as $function$
begin
  execute format($$
		 create server if not exists %4$s foreign data wrapper jdbc_fdw options (
		   drivername '%1$s',
		   url '%2$s',
		   jarfile '%3$s');
		   $$, jdbc_driver, jdbc_url, jdbc_jarfile, server);
end
$function$;

create or replace function create_user_mapping (pg_role text, fdw_server text, fdw_user text, fdw_password text)
  returns void
  language plpgsql
  volatile as $function$
begin
  execute format($$
		 create user mapping for %1$s server %2$s options (username '%3$s', password '%4$s')
		 $$,
		 pg_role, fdw_server, fdw_user, fdw_password);
end
$function$;

-- select create_server(current_setting('custom.jdbc_driver'), current_setting('custom.jdbc_url'), current_setting('custom.jdbc_jarfile'));

-- select create_user_mapping('postgres', 'jdbc', current_setting('custom.jdbc_user'), current_setting('custom.jdbc_password'));

-- drop schema if exists jdbc cascade;

-- create schema if not exists jdbc;
