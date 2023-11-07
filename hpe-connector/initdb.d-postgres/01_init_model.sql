-- -*- sql-product: postgres; -*-

create schema core;

create table core.server (
  id int primary key generated always as identity,
  content jsonb
  );

create schema v1beta2;

create view servers as
  select
    content
    from
      core.server;

