-- -*- sql-product: postgres; -*-

create extension tds_fdw;

create or replace function create_user_mapping(pg_role text, fdw_server text, fdw_user text, fdw_password text)
  returns void
  language plpgsql
  volatile as $$
  begin
    execute format('create user mapping for %1$s server %2$s options (username ''%3$s'', password ''%4$s'')', pg_role, fdw_server, fdw_user, fdw_password);
  end
  $$;

create server mssql foreign data wrapper tds_fdw options (servername 'mssql', port '1433', tds_version '7.4', database 'test');

select create_user_mapping('postgres', 'mssql', 'sa', current_setting('custom.sa_password'));

import foreign schema dbo from server mssql into public;
