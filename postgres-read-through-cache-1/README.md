# Abstract #

This is a Proof-Of-Concept (POC) demonstrating how to use PostgreSQL
and its Foreign Data Wrapper (FDW) support as a read-through cache to
a data warehouse.

# What #

This POC uses a PostgreSQL database instance as a read-through cache
to other databases (both PostgreSQL and Snowflake).  It also uses
Hasura to expose this as a GraphQL API and also as a way to refresh
the cache.

# Why #

Hasura users looking for a way to cache aggregate data from a data
warehouse may find this approach useful as an alternative to Extract
Translate and Load (ETL) pipelines.

# How #

A PostgreSQL database server named `origin` is created, which contains
system-of-record data for a demonstration e-commerce data model.  Raw
data from this server are made available as CSV files for importation
into a data warehouse such as Snowflake as an illustration of an
analytics application.  Another PostgreSQL database server named
`cache` is also created, which uses PostgreSQL Foreign Data Wrappers
(FDW) to access both the data in the `origin` instance, and also in a
data warehouse (Snowflake in this demonstration).  Different schema
are created within the `cache` database for these two applications:

  * `origin`
  * `snowflake`
  
Foreign data wrappers are create using these two different providers

  * `postgres_fdw`
  * `jdbc_fdw`
  
The former is used to access the `origin` PostgreSQL database
instance.  The latter is used to access the `snowflake` database
instance.  The foreign servers are used in order to map foreign tables
into their respective schema `origin` and `snowflake` for the remote
tables:  `account`, `invoice`, `line_item`, and `product`.  

Views are then created in the `public` schema on top of these foreign
tables.  For both `origin` and `snowflake`, first a dynamic view is
created, then a materialized view is created on top of the
corresponding dynamic view.

Functions are then created in order to refresh the materialized views,
these functions are tracked in Hasura as top-level GraphQL mutations,
and those mutations are encoded as Hasura REST endpoints.  

Finally, Hasura cron triggers are set up (with request transforms) to
activate these REST endpoints on a periodic basis with a 1 minute
interval.  This serves to to refresh the underlying materialized views
on that same schedule and therefore keep the cached data fresh with a
Time To Live (TTL) of 1 minute.

# Steps #

1. Clone this repository.

```shell
git clone https://github.com/dventimihasura/hasura-projects
```

2. Change to the `postgres-read-through-cache-1` sub-directory.

```shell
cd postgres-read-through-cache-1
```

3. Go to https://www.snowflake.com and create a free trial account,
   create a database named `postgres` and a warehouse named
   `postgres`.

4. Create Snowflake tables and import data. `TODO`

5. Create a `.env` file in the local `postgres-read-through-cache-1`
   directory and add your Snowflake username and password like so.
   **DO NOT CHECK THIS FILE INTO SOURCE CONTROL**.
   
```shell
SNOWFLAKE_USER=<your Snowflake username>
SNOWFLAKE_PASSWORD=<your Snowflake password>
```

6. Use Docker Compose to build the Docker image and launch the
   services.
   
```shell
docker-compose up -d --build
```

7. Deploy the Hasura migrations and metadata.  **NOTE: If you have set
   up Multi-Factor Authentication (MFA) with your Snowflake account
   then you should be alert for push notifications on your MFA device
   as Snowflake connections are established.**

```shell
hasura deploy
```

8. Access the Hasura Console via http://localhost:8080 and try out
   GraphQL queries like the following:
   
```graphql
query MyQuery {
  snowflake_account_summary_cached_aggregate {
    aggregate {
      count
    }
  }
}
```
