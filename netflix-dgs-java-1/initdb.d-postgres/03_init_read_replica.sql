-- -*- sql-product: postgres; -*-

create role readaccess;

grant connect on database postgres 
  to readaccess;

grant usage on schema public to readaccess;

grant select on all tables in schema public to readaccess;

create user read_user with 
  password 'read_user';

grant readaccess to read_user;
