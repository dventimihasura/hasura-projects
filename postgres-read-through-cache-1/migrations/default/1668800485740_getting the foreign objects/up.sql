drop schema if exists origin cascade;

create schema if not exists origin;

drop extension if exists jdbc_fdw cascade;

create extension if not exists jdbc_fdw;

create server if not exists origin foreign data wrapper jdbc_fdw options(
drivername 'org.postgresql.Driver',
url 'jdbc:postgresql://origin:5432/postgres',
jarfile '/usr/share/java/postgresql.jar'
);

create user mapping if not exists for current_user server origin options(username 'postgres', password 'postgrespassword');

import foreign schema public limit to (account, invoice, line_item, product, region) from server origin into origin;
