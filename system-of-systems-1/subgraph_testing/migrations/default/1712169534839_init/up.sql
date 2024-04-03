SET check_function_bodies = false;
CREATE EXTENSION IF NOT EXISTS mongo_fdw WITH SCHEMA public;
COMMENT ON EXTENSION mongo_fdw IS 'foreign data wrapper for MongoDB access';
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
CREATE SERVER mongodb FOREIGN DATA WRAPPER mongo_fdw OPTIONS (
    address 'subgraph_testing_mongodb',
    authentication_database 'admin',
    port '27017'
);
CREATE USER MAPPING FOR postgres SERVER mongodb OPTIONS (
    password 'mongo',
    username 'mongo'
);
CREATE FOREIGN TABLE public.test_report (
    _id name,
    org text,
    filter text,
    addrs text
)
SERVER mongodb
OPTIONS (
    collection 'sample_collection',
    database 'sample_db'
);
