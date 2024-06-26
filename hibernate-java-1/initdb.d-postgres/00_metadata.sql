-- -*- sql-product: postgres; -*-

create database graphql_engine_1;

create database graphql_engine_2;

create extension if not exists pg_stat_statements;

create or replace view statement as
  select
    *
    from
      pg_stat_statements
      join pg_roles on pg_roles.oid = userid;
