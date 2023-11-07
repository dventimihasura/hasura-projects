-- -*- sql-product: postgres; -*-

create schema core;

create table core.server (
  id int primary key generated always as identity,
  content jsonb
);

create table core.alert (
  id int primary key generated always as identity,
  server_id int null references core.server (id),
  content jsonb
);

create view servers as
  select
    id,
    content
    from
      core.server;

create view alerts as
  select
    id,
    server_id,
    content
    from
      core.alert;
    
