-- -*- sql-product: postgres; -*-

create role readonly;

grant connect on database postgres 
  to readonly;

grant usage on schema public to readonly;

grant usage on schema pg_catalog to readonly;

grant select on all tables in schema public to readonly;

grant select on all tables in schema pg_catalog to readonly;

grant pg_read_all_stats to readonly;

create user read_user with 
  password 'read_user';

grant readonly to read_user;

create role readwrite;

grant connect on database postgres 
  to readwrite;

grant usage on schema public to readwrite;

grant usage on schema pg_catalog to readwrite;

grant all privileges on all tables in schema public to readwrite;

grant all privileges on all tables in schema pg_catalog to readwrite;

create user write_user with 
  password 'write_user';

grant readwrite to write_user;

grant pg_read_all_stats to read_user;

grant pg_read_all_stats to write_user;

