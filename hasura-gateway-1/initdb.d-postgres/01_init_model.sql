-- -*- sql-product: postgres; -*-

create schema if not exists marketplace;

create schema if not exists catalog;

create extension if not exists pgcrypto;

-- account table

CREATE TABLE "marketplace"."account" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "name" text NOT NULL, "created_at" timestamptz NOT NULL DEFAULT now(), "updated_at" timestamptz NOT NULL DEFAULT now(), PRIMARY KEY ("id") );
CREATE OR REPLACE FUNCTION "marketplace"."set_current_timestamp_updated_at"()
  RETURNS TRIGGER AS $$
  DECLARE
    _new record;
  BEGIN
    _new := NEW;
    _new."updated_at" = NOW();
    RETURN _new;
  END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER "set_public_account_updated_at"
  BEFORE UPDATE ON "marketplace"."account"
  FOR EACH ROW
  EXECUTE PROCEDURE "marketplace"."set_current_timestamp_updated_at"();
COMMENT ON TRIGGER "set_public_account_updated_at" ON "marketplace"."account" 
  IS 'trigger to set value of column "updated_at" to current timestamp on row update';

-- product table

CREATE TABLE "catalog"."product" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "created_at" timestamptz NOT NULL DEFAULT now(), "updated_at" timestamptz NOT NULL DEFAULT now(), "name" text NOT NULL, "price" integer NOT NULL, PRIMARY KEY ("id") );
CREATE OR REPLACE FUNCTION "marketplace"."set_current_timestamp_updated_at"()
  RETURNS TRIGGER AS $$
  DECLARE
    _new record;
  BEGIN
    _new := NEW;
    _new."updated_at" = NOW();
    RETURN _new;
  END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER "set_public_product_updated_at"
  BEFORE UPDATE ON "catalog"."product"
  FOR EACH ROW
  EXECUTE PROCEDURE "marketplace"."set_current_timestamp_updated_at"();
COMMENT ON TRIGGER "set_public_product_updated_at" ON "catalog"."product" 
  IS 'trigger to set value of column "updated_at" to current timestamp on row update';

-- order table

CREATE TABLE "marketplace"."order" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "created_at" timestamptz NOT NULL DEFAULT now(), "updated_at" timestamptz NOT NULL DEFAULT now(), "account_id" uuid NOT NULL, PRIMARY KEY ("id") , FOREIGN KEY ("account_id") REFERENCES "marketplace"."account"("id") ON UPDATE restrict ON DELETE restrict);
CREATE OR REPLACE FUNCTION "marketplace"."set_current_timestamp_updated_at"()
  RETURNS TRIGGER AS $$
  DECLARE
    _new record;
  BEGIN
    _new := NEW;
    _new."updated_at" = NOW();
    RETURN _new;
  END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER "set_public_order_updated_at"
  BEFORE UPDATE ON "marketplace"."order"
  FOR EACH ROW
  EXECUTE PROCEDURE "marketplace"."set_current_timestamp_updated_at"();
COMMENT ON TRIGGER "set_public_order_updated_at" ON "marketplace"."order" 
  IS 'trigger to set value of column "updated_at" to current timestamp on row update';

create index on marketplace.order (account_id);

-- order_detail table

CREATE TABLE "marketplace"."order_detail" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "created_at" timestamptz NOT NULL DEFAULT now(), "updated_at" timestamptz NOT NULL DEFAULT now(), "units" integer NOT NULL, "order_id" uuid NOT NULL, "product_id" uuid NOT NULL, PRIMARY KEY ("id") , FOREIGN KEY ("order_id") REFERENCES "marketplace"."order"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("product_id") REFERENCES "catalog"."product"("id") ON UPDATE restrict ON DELETE restrict);
CREATE OR REPLACE FUNCTION "marketplace"."set_current_timestamp_updated_at"()
  RETURNS TRIGGER AS $$
  DECLARE
    _new record;
  BEGIN
    _new := NEW;
    _new."updated_at" = NOW();
    RETURN _new;
  END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER "set_public_order_detail_updated_at"
  BEFORE UPDATE ON "marketplace"."order_detail"
  FOR EACH ROW
  EXECUTE PROCEDURE "marketplace"."set_current_timestamp_updated_at"();
COMMENT ON TRIGGER "set_public_order_detail_updated_at" ON "marketplace"."order_detail" 
  IS 'trigger to set value of column "updated_at" to current timestamp on row update';

create index on marketplace.order_detail (order_id);

create index on marketplace.order_detail (product_id);

-- product_search function

create or replace function catalog.product_search(search text)
  returns setof catalog.product as $$
  select product.*
  from catalog.product
  where
  name ilike ('%' || search || '%')
$$ language sql stable;

-- product_search_slow function

create or replace function catalog.product_search_slow(search text, wait real)
  returns setof catalog.product as $$
  select product.*
  from catalog.product, pg_sleep(wait)
  where
  name ilike ('%' || search || '%')
$$ language sql stable;

-- non_negative_price constraint

alter table "catalog"."product" add constraint "non_negative_price" check (price > 0);

-- index account(name)

create index if not exists account_name_idx on marketplace.account (name);

-- status enum

CREATE TYPE status AS ENUM ('new', 'processing', 'fulfilled');

-- add status to order table

alter table "marketplace"."order" add column "status" status null;

create index on marketplace.order (status);

-- region dictionary table

create table if not exists marketplace.region (
  value text primary key,
  description text);

-- add region to order

alter table "marketplace"."order" add column "region" Text
 null;

alter table "marketplace"."order"
  add constraint "order_region_fkey"
  foreign key ("region")
  references "marketplace"."region"
  ("value") on update restrict on delete restrict;

create index on marketplace.order (region);
