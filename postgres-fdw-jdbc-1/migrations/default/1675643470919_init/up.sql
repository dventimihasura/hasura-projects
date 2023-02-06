SET check_function_bodies = false;
CREATE EXTENSION IF NOT EXISTS jdbc_fdw WITH SCHEMA public;
COMMENT ON EXTENSION jdbc_fdw IS 'foreign-data wrapper for remote servers available over JDBC';
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
