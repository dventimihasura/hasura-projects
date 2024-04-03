SET check_function_bodies = false;
CREATE EXTENSION IF NOT EXISTS file_fdw WITH SCHEMA public;
COMMENT ON EXTENSION file_fdw IS 'foreign-data wrapper for flat file access';
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
CREATE SERVER bom_files FOREIGN DATA WRAPPER file_fdw;
CREATE FOREIGN TABLE public.bom (
    data jsonb
)
SERVER bom_files
OPTIONS (
    filename '/opt/01_init_data.jsonl',
    format 'text'
);
