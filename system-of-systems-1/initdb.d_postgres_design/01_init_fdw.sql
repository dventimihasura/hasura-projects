-- -*- sql-product: postgres; -*-

create extension if not exists file_fdw;

create server if not exists init_data foreign data wrapper file_fdw;

create foreign table if not exists init_data (data jsonb) server init_data options (filename '/opt/01_init_data.jsonl', format 'text');
