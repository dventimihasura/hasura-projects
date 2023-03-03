SET check_function_bodies = false;
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
CREATE EXTENSION IF NOT EXISTS tds_fdw WITH SCHEMA public;
COMMENT ON EXTENSION tds_fdw IS 'Foreign data wrapper for querying a TDS database (Sybase or Microsoft SQL Server)';
CREATE FUNCTION public.create_user_mapping(pg_role text, fdw_server text, fdw_user text, fdw_password text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
  begin
    execute format('create user mapping for %1$s server %2$s options (username ''%3$s'', password ''%4$s'')', pg_role, fdw_server, fdw_user, fdw_password);
  end
  $_$;
CREATE SERVER mssql FOREIGN DATA WRAPPER tds_fdw OPTIONS (
    database 'test',
    port '1433',
    servername 'mssql',
    tds_version '7.4'
);
CREATE USER MAPPING FOR postgres SERVER mssql OPTIONS (
    password 'yourStrong(!)Password',
    username 'sa'
);
CREATE FOREIGN TABLE public.guid_id (
    id uuid NOT NULL
)
SERVER mssql
OPTIONS (
    query 'exec get_guid_id',
    row_estimate_method 'showplan_all',
    schema_name 'dbo'
);
ALTER FOREIGN TABLE public.guid_id ALTER COLUMN id OPTIONS (
    column_name 'id'
);
CREATE FOREIGN TABLE public.person (
    id integer NOT NULL,
    name character varying(255)
)
SERVER mssql
OPTIONS (
    schema_name 'dbo',
    table_name 'person'
);
ALTER FOREIGN TABLE public.person ALTER COLUMN id OPTIONS (
    column_name 'id'
);
ALTER FOREIGN TABLE public.person ALTER COLUMN name OPTIONS (
    column_name 'name'
);
CREATE FOREIGN TABLE public.sequence_id (
    id integer NOT NULL
)
SERVER mssql
OPTIONS (
    query 'exec get_sequence_id',
    row_estimate_method 'showplan_all',
    schema_name 'dbo'
);
ALTER FOREIGN TABLE public.sequence_id ALTER COLUMN id OPTIONS (
    column_name 'id'
);
