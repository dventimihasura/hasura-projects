-- -*- sql-product: postgres; -*-

create extension if not exists wrappers;

create foreign data wrapper clickhouse_wrapper
  handler click_house_fdw_handler
  validator click_house_fdw_validator;

create server clickhouse_server
  foreign data wrapper clickhouse_wrapper
  options (
    conn_string 'tcp://default:password@clickhouse:9000/default');

create foreign table account (
  id uuid not null,
  name text not null,
  created_at timestamp not null,
  updated_at timestamp not null
) server clickhouse_server options (table 'v_account', rowid_column 'id');

create foreign table product (
  id uuid not null,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now(),
  name text not null,
  price integer not null
) server clickhouse_server options (table 'v_product', rowid_column 'id');

create foreign table "order" (
  id uuid not null,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now(),
  account_id uuid not null
) server clickhouse_server options (table 'v_order', rowid_column 'id');

create foreign table order_detail (
  id uuid not null,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now(),
  units integer not null,
  order_id uuid not null,
  product_id uuid not null
) server clickhouse_server options (table 'v_order_detail', rowid_column 'id');
