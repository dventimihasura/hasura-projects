-- -*- sql-product: postgres; -*-

create extension if not exists pgcrypto;

create user hasurauser_1 with password 'hasurauser_1';
grant create on database postgres to hasurauser_1;
grant usage on schema public to hasurauser_1;
grant all on all tables in schema public to hasurauser_1;
grant all on all sequences in schema public to hasurauser_1;
grant all on all functions in schema public to hasurauser_1;

create user hasurauser_2 with password 'hasurauser_2';
grant create on database postgres to hasurauser_2;
grant usage on schema public to hasurauser_2;
grant all on all tables in schema public to hasurauser_2;
grant all on all sequences in schema public to hasurauser_2;
grant all on all functions in schema public to hasurauser_2;

create user hasurauser_3 with password 'hasurauser_3';
grant create on database postgres to hasurauser_3;
grant usage on schema public to hasurauser_3;
grant all on all tables in schema public to hasurauser_3;
grant all on all sequences in schema public to hasurauser_3;
grant all on all functions in schema public to hasurauser_3;

create user hasurauser_4 with password 'hasurauser_4';
grant create on database postgres to hasurauser_4;
grant usage on schema public to hasurauser_4;
grant all on all tables in schema public to hasurauser_4;
grant all on all sequences in schema public to hasurauser_4;
grant all on all functions in schema public to hasurauser_4;

create user hasurauser_5 with password 'hasurauser_5';
grant create on database postgres to hasurauser_5;
grant usage on schema public to hasurauser_5;
grant all on all tables in schema public to hasurauser_5;
grant all on all sequences in schema public to hasurauser_5;
grant all on all functions in schema public to hasurauser_5;

alter default privileges in schema public grant all on tables to public;
