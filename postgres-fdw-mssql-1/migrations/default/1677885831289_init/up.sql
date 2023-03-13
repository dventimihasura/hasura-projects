create extension if not exists tds_fdw;

create or replace function create_user_mapping(pg_role text, fdw_server text, fdw_user text, fdw_password text)
  returns void
  language plpgsql
  volatile as $$
  begin
    execute format('create user mapping for %1$s server %2$s options (username ''%3$s'', password ''%4$s'')', pg_role, fdw_server, fdw_user, fdw_password);
  end
  $$;

create server if not exists mssql foreign data wrapper tds_fdw options (servername 'mssql', port '1433', tds_version '7.4', database 'test');

select create_user_mapping('postgres', 'mssql', 'sa', current_setting('custom.sa_password')); --non-hard-coded mssql password

import foreign schema dbo from server mssql into public;

create foreign table sequence_id (
  id int options (column_name 'id') not null
)
  server mssql
  options (schema_name 'dbo', query 'exec get_sequence_id', row_estimate_method 'showplan_all');

create foreign table guid_id (
  id uuid options (column_name 'id') not null
)
  server mssql
  options (schema_name 'dbo', query 'exec get_guid_id', row_estimate_method 'showplan_all');
