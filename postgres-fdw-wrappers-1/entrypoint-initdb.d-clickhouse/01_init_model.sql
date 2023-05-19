-- -*- sql-product: postgres; -*-

create or replace table default.account (
  id UUID not null default generateUUIDv4(),
  name text not null,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now(),
  primary key (id)
) engine = MergeTree();

create or replace table default.product (
  id UUID not null default generateUUIDv4(),
  created_at timestamp not null default now(),
  updated_at timestamp not null default now(),
  name text not null,
  price integer not null,
  primary key (id)
) engine = MergeTree();

create or replace table default.order (
  id UUID not null default generateUUIDv4(),
  created_at timestamp not null default now(),
  updated_at timestamp not null default now(),
  account_id UUID not null,
  primary key (id)
) engine = MergeTree();

create or replace table default.order_detail (
  id UUID not null default generateUUIDv4(),
  created_at timestamp not null default now(),
  updated_at timestamp not null default now(),
  units integer not null,
  order_id UUID not null,
  product_id UUID not null,
  primary key (id)
) engine = MergeTree();

create or replace view v_account as select id::text id, name, created_at, updated_at from account;

create or replace view v_product as select id::text id, created_at, updated_at, name, price from product;

create or replace view v_order as select id::text id, created_at, updated_at, account_id::text account_id from "order";

create or replace view v_order_detail as select id::text id, created_at, updated_at, units, order_id::text order_id, product_id::text product_id from order_detail;
