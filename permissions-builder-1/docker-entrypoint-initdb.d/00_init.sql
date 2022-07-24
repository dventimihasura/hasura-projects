-- We will create separate users to manage the user database
-- and metadata database and grant permissions on hasura-specific
-- schemas and information_schema and pg_catalog.
-- These permissions/grants are required for Hasura to work properly.

-- create a separate user for to manage metadata database
CREATE USER hasura_metadata_user WITH PASSWORD 'hasura_metadata_user_password';

-- create the schemas required by the hasura system
-- NOTE: If you are starting from scratch: drop the below schemas first, if they exist.
CREATE SCHEMA IF NOT EXISTS hdb_catalog;

-- make the user an owner of the schema
ALTER SCHEMA hdb_catalog OWNER TO hasura_metadata_user;
ALTER ROLE hasura_metadata_user SET search_path TO hdb_catalog;

-- Hasura needs pgcrypto extension
-- See section below on pgcrypto in PG search path
CREATE EXTENSION IF NOT EXISTS pgcrypto;

------------------------------------------------------------------------------

-- create a separate user for to manage user database
CREATE USER hasuramanager WITH PASSWORD 'hasuramanager';

-- create pgcrypto extension, required for UUID
-- See section below on pgcrypto in PG search path
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- The below permissions are optional. This is dependent on what access to your
-- tables/schemas you want give to hasura. If you want expose the public
-- schema for GraphQL query then give permissions on public schema to the
-- hasura user.
-- Be careful to use these in your production db. Consult the postgres manual or
-- your DBA and give appropriate permissions.

-- grant all privileges on all tables in the public schema. This can be customised:
-- For example, if you only want to use GraphQL regular queries and not mutations,
-- then you can set: GRANT SELECT ON ALL TABLES...
GRANT USAGE ON SCHEMA public TO hasuramanager;
GRANT ALL ON ALL TABLES IN SCHEMA public TO hasuramanager;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO hasuramanager;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO hasuramanager;

-- Similarly add these for other schemas as well, if you have any.
-- GRANT USAGE ON SCHEMA <schema-name> TO hasuramanager;
-- GRANT ALL ON ALL TABLES IN SCHEMA <schema-name> TO hasuramanager;
-- GRANT ALL ON ALL SEQUENCES IN SCHEMA <schema-name> TO hasuramanager;
-- GRANT ALL ON ALL FUNCTIONS IN SCHEMA <schema-name> TO hasuramanager;

alter default privileges for user hasuramanager grant all on tables to public;
alter default privileges for user hasuramanager grant all on sequences to public;
alter default privileges for user hasuramanager grant all on functions to public;
alter default privileges for user hasuramanager grant all on types to public;
alter default privileges for user hasuramanager grant all on schemas to public;

------------------------------------------------------------------------------

-- create a separate user for to access api user database
CREATE USER hasurauser WITH PASSWORD 'hasurauser';

-- create pgcrypto extension, required for UUID
-- See section below on pgcrypto in PG search path
-- CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- The below permissions are optional. This is dependent on what access to your
-- tables/schemas you want give to hasura. If you want expose the public
-- schema for GraphQL query then give permissions on public schema to the
-- hasura user.
-- Be careful to use these in your production db. Consult the postgres manual or
-- your DBA and give appropriate permissions.

-- grant all privileges on all tables in the public schema. This can be customised:
-- For example, if you only want to use GraphQL regular queries and not mutations,
-- then you can set: GRANT SELECT ON ALL TABLES...
GRANT USAGE ON SCHEMA public TO hasurauser;
GRANT ALL ON ALL TABLES IN SCHEMA public TO hasurauser;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO hasurauser;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO hasurauser;

-- Similarly add these for other schemas as well, if you have any.
-- GRANT USAGE ON SCHEMA <schema-name> TO hasurauser;
-- GRANT ALL ON ALL TABLES IN SCHEMA <schema-name> TO hasurauser;
-- GRANT ALL ON ALL SEQUENCES IN SCHEMA <schema-name> TO hasurauser;
-- GRANT ALL ON ALL FUNCTIONS IN SCHEMA <schema-name> TO hasurauser;

-- alter default privileges for user hasurauser grant all on tables to hasurauser;
-- alter default privileges for user hasurauser grant all on sequences to hasurauser;
-- alter default privileges for user hasurauser grant all on functions to hasurauser;
-- alter default privileges for user hasurauser grant all on types to hasurauser;
-- alter default privileges for user hasurauser grant all on schemas to hasurauser;
