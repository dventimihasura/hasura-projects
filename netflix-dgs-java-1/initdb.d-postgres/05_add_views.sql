-- -*- sql-product: postgres; -*-

create or replace view statement as
  select
    *
    from
      pg_stat_statements
      join pg_roles on pg_roles.oid = userid;
