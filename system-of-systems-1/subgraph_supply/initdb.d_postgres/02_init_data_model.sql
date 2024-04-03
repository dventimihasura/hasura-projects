-- -*- sql-product: postgres; -*-

create extension file_fdw;

create server bom_files foreign data wrapper file_fdw;

create foreign table if not exists bom (data jsonb) server bom_files options (
  filename '/opt/01_init_data.jsonl',
  format 'text'
);
