-- -*- sql-product: postgres; -*-

create role readonly;

grant connect on database postgres 
  to readonly;

grant usage on schema public to readonly;

grant select on all tables in schema public to readonly;

create user read_user with 
  password 'read_user';

grant readonly to read_user;

create role readwrite;

grant connect on database postgres 
  to readwrite;

grant usage on schema public to readwrite;

grant all privileges on all tables in schema public to readwrite;

create user write_user with 
  password 'write_user';

grant readwrite to write_user;

