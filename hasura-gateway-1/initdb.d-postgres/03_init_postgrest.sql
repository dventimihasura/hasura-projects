-- -*- sql-product: postgres; -*-

create role web_anon nologin;

create schema api;

grant usage on schema api to web_anon;

create or replace view api.product as select * from catalog.product;

grant select on api.product to web_anon;

comment on schema api is
$$Catalog API
A RESTful API that serves a catalog of Product data.$$;
  
