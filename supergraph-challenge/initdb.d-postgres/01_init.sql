-- -*- sql-product: postgres; -*-

create extension if not exists postgres_fdw;

create server if not exists postgres1 type 'postgres' version '15.1' foreign data wrapper postgres_fdw options (host 'postgres1', dbname 'postgres', port '5432');

create server if not exists postgres2 type 'postgres' version '15.1' foreign data wrapper postgres_fdw options (host 'postgres2', dbname 'postgres', port '5432');

create schema if not exists postgres1;

create schema if not exists postgres2;

create user mapping if not exists for public server postgres1 options (user 'postgres', password 'postgrespassword');

create user mapping if not exists for public server postgres2 options (user 'postgres', password 'postgrespassword');

import foreign schema public from server postgres1 into postgres1;

import foreign schema public from server postgres2 into postgres2;

create or replace view posts as select * from postgres1.posts;

create or replace view threads as select * from postgres2.threads;

comment on view threads is E'@primaryKey id';

comment on view posts is E'@primaryKey id';

comment on view posts is E'@foreignKey (thread_id) references threads (id)';
