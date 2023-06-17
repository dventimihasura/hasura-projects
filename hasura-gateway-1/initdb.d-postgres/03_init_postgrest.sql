-- -*- sql-product: postgres; -*-

create role web_anon nologin;

create schema api;

grant usage on schema api to web_anon;

create or replace view api.account as select * from account;

create or replace view api.order as select * from "order";

create or replace view api.order_detail as select * from order_detail;

create or replace view api.product as select * from product;

create or replace view api.region as select * from region;

grant select on api.account, api.order, api.order_detail, api.product, api.region to web_anon;

comment on schema api is
$$Catalog API
A RESTful API that serves a catalog of Product data.$$;
  
