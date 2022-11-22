#!/usr/bin/bash 

psql <<EOF

-- -*- sql-product: postgres; -*-

create extension if not exists jdbc_fdw;

drop schema if exists snowflake cascade;

create schema if not exists snowflake;

drop server if exists snowflake cascade;

create server if not exists snowflake foreign data wrapper jdbc_fdw options(
  drivername 'net.snowflake.client.jdbc.SnowflakeDriver',
  url 'jdbc:snowflake://${SNOWFLAKE_H?user=${SNOWFLAKE_USER}&password=${SNOWFLAKE_PASSWORD}&db=${SNOWFLAKE_DB}&warehouse=${SNOWFLAKE_WAREHOUSE}',
  jarfile '/usr/share/java/snowflake-jdbc-3.13.20.jar'
);
		
create user mapping if not exists for current_user server snowflake options(username '${SNOWFLAKE_USER}', password '${SNOWFLAKE_PASSWORD}');

create foreign table snowflake.account (id text, name text, created_at timestamptz, updated_at timestamptz) server snowflake;

create foreign table snowflake.invoice (id text, region text, status text, account_id text, created_at timestamptz, updated_at timestamptz) server snowflake;

create foreign table snowflake.line_item (id text, invoice_id text, product_id text, units integer, created_at timestamptz, updated_at timestamptz) server snowflake;

create foreign table snowflake.product (id text, name text, price integer, created_at timestamptz, updated_at timestamptz) server snowflake;

EOF
