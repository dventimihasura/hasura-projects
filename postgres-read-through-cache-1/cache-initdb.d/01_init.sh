#!/usr/bin/bash 

psql <<EOF

-- -*- sql-product: postgres; -*-

create extension if not exists jdbc_fdw;

drop schema if exists origin_2 cascade;

create schema if not exists origin_2;

drop server if exists snowflake cascade;

create server if not exists snowflake foreign data wrapper jdbc_fdw options(
  drivername 'net.snowflake.client.jdbc.SnowflakeDriver',
  url 'jdbc:snowflake://${SNOWFLAKE_ADDRESS}?user=${SNOWFLAKE_USER}&password=${SNOWFLAKE_PASSWORD}&db=${SNOWFLAKE_DB}&warehouse=${SNOWFLAKE_WAREHOUSE}',
  jarfile '/usr/share/java/snowflake-jdbc-3.13.20.jar'
);
		
create user mapping if not exists for current_user server snowflake options(username '${SNOWFLAKE_USER}', password '${SNOWFLAKE_PASSWORD}');

create foreign table origin_2.account (id text, name text, created_at timestamptz, updated_at timestamptz) server snowflake;

create foreign table origin_2.invoice (id text, region text, status text, account_id text, created_at timestamptz, updated_at timestamptz) server snowflake;

create foreign table origin_2.line_item (id text, invoice_id text, product_id text, units integer, created_at timestamptz, updated_at timestamptz) server snowflake;

create foreign table origin_2.product (id text, name text, price integer, created_at timestamptz, updated_at timestamptz) server snowflake;

EOF
