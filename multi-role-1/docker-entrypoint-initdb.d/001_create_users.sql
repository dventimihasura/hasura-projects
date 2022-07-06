-- -*- sql-product: postgres; -*-

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE USER hasura_metadata_user WITH PASSWORD 'hasura_metadata_user_password';
CREATE SCHEMA IF NOT EXISTS hdb_catalog;
ALTER SCHEMA hdb_catalog OWNER TO hasura_metadata_user;
ALTER ROLE hasura_metadata_user SET search_path TO hdb_catalog;

CREATE USER hasurauser_1 WITH PASSWORD 'hasurauser_1';
GRANT USAGE ON SCHEMA public TO hasurauser_1;
GRANT ALL ON ALL TABLES IN SCHEMA public TO hasurauser_1;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO hasurauser_1;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO hasurauser_1;

CREATE USER hasurauser_2 WITH PASSWORD 'hasurauser_2';
GRANT USAGE ON SCHEMA public TO hasurauser_2;
GRANT ALL ON ALL TABLES IN SCHEMA public TO hasurauser_2;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO hasurauser_2;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO hasurauser_2;

CREATE USER hasurauser_3 WITH PASSWORD 'hasurauser_3';
GRANT USAGE ON SCHEMA public TO hasurauser_3;
GRANT ALL ON ALL TABLES IN SCHEMA public TO hasurauser_3;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO hasurauser_3;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO hasurauser_3;

CREATE USER hasurauser_4 WITH PASSWORD 'hasurauser_4';
GRANT USAGE ON SCHEMA public TO hasurauser_4;
GRANT ALL ON ALL TABLES IN SCHEMA public TO hasurauser_4;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO hasurauser_4;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO hasurauser_4;

CREATE USER hasurauser_5 WITH PASSWORD 'hasurauser_5';
GRANT USAGE ON SCHEMA public TO hasurauser_5;
GRANT ALL ON ALL TABLES IN SCHEMA public TO hasurauser_5;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO hasurauser_5;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO hasurauser_5;

ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO PUBLIC;
