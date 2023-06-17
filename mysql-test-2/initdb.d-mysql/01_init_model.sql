-- -*- sql-product: mysql; -*-

set sql_mode = 'ANSI_QUOTES';

set foreign_key_checks = 0;

drop table if exists "account";

drop table if exists "order";

drop table if exists "order_detail";

drop table if exists "product";

drop table if exists "region";

-- account table

create table "account" ("id" char(36) not null default (uuid()), "name" varchar(255) not null, "created_at" timestamp not null default now(), "updated_at" timestamp not null default now(), primary key ("id") );

-- product table

create table "product" ("id" char(36) not null default (uuid()), "created_at" timestamp not null default now(), "updated_at" timestamp not null default now(), "name" varchar(255) not null, "price" integer not null, primary key ("id") );

-- order table

create table "order" ("id" char(36) not null default (uuid()), "created_at" timestamp not null default now(), "updated_at" timestamp not null default now(), "account_id" char(36) not null, primary key ("id") , foreign key ("account_id") references "account"("id") on update restrict on delete restrict);

create index order_idx on "order" (account_id);

-- order_detail table

create table "order_detail" ("id" char(36) not null default (uuid()), "created_at" timestamp not null default now(), "updated_at" timestamp not null default now(), "units" integer not null, "order_id" char(36) not null, "product_id" char(36) not null, primary key ("id") , foreign key ("order_id") references "order"("id") on update restrict on delete restrict, foreign key ("product_id") references "product"("id") on update restrict on delete restrict);

create index order_detail_idx on order_detail (order_id);

create index order_detail_idx_2 on order_detail (product_id);

-- product_search function

-- create or replace function product_search(search varchar(255))
--   returns setof product as $$
--   select product.*
--   from product
--   where
--   name ilike ('%' || search || '%')
-- $$ language sql stable;

-- product_search_slow function

-- create or replace function product_search_slow(search varchar(255), wait real)
--   returns setof product as $$
--   select product.*
--   from product, pg_sleep(wait)
--   where
--   name ilike ('%' || search || '%')
-- $$ language sql stable;

-- non_negative_price constraint

-- alter table "product" add constraint "non_negative_price" check (price > 0);

-- index account(name)

-- create index account_name_idx on account (name);

-- status enum

-- add status to order table

alter table "order" add column "status" ENUM ('new', 'processing', 'fulfilled') null;

create index order_idx_3 on "order" (status);

-- region dictionary table

create table if not exists region (
  value varchar(255) primary key,
  description varchar(255));

-- add region to order

alter table "order" add column "region" varchar(255)
 null;

alter table "order"
  add constraint "order_region_fkey"
  foreign key ("region")
  references "region"
  ("value") on update restrict on delete restrict;

create index order_idx_4 on "order" (region);

-- account summary view

create or replace view account_summary as
select
  account.id,
  sum(units*price) total_price
  from account
       join "order" on "order".account_id = account.id
       join order_detail on order_detail.order_id = "order".id
       join product on product.id = order_detail.product_id
 group by account.id;

-- sku function

-- create or replace function product_sku(product_row product)
-- returns varchar(255) as $$
--   select md5(product_row.name)
-- $$ language sql stable;

