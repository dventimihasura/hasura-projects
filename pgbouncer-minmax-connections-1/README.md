# Abstract #

This project is a proof-of-concept (POC) exploring the use of
[pgbouncer](https://www.pgbouncer.org/ "pgbouncer") as a connection
pooler for Hasura.

# What #

This POC launches a fleet of servers (postgres, pgbouncer,
graphql-engine, nginx), configures them to work in concert, and
provides a sample data model and sample data.

# Why #

Hasura Self-Hosted Enterprise users might wish to have a single
uniform connection pool across a horizontally-scaled set of Hasura
graphql-engine instances.  This POC shows how to use pgbouncer to
achieve that goal.

# How #

Most of the action takes place in the `docker-compose.yaml` file,
which is written to launch a fleet of servers.

1. **postgres** : origin database server for both data and metadata
2. **pgbouncer** : pgbouncer connection pooler for **postgress**
   origin database
3. **graphql-engine-1** : Hasura instance #1, using **pgbouncer** to
   access data and **postgress** (skipping the pool) to access
   metadata
4. **graphql-engine-2** : Hasura instance #2, using **pgbouncer** to
   access data and **postgres** (skipping the pool) to access metadata. 
5. **nginx** : Round-robin load balancer in front of the two Hasura
   instances, makes life easier for testing

# Steps #

1. Clone this repository:

```shell
git clone git@github.com:dventimihasura/hasura-projects.git
```

2. Change to the `pgbouncer-minmax-connections-1` directory.

```shell
ce pgbouncer-minmax-connections-1
```

3. Use Docker Compose to launch the services.

```shell
docker-compose up -d
```

4. Deploy the sample data model and seed data.

```shell
hasura deploy
hasura seed apply --database-name default
```

5. (Optional) Use the Apache
   [ab](https://httpd.apache.org/docs/2.4/programs/ab.html) HTTP
   benchamarking tool to generate load.
   
   
```shell
ab -c 100 -t 60 -H x-hasura-admin-secret\:\ myadminsecretkey http\://localhost\:8080/api/rest/product_search_slow/apple/1.5
```

# Notes #

  * The Hasura connection pool probably should be configured to return
    connections to the pgbouncer pool rather quickly.  See
    `idle_timeout: 1`.
	
```yaml
- name: default
  kind: postgres
  configuration:
    connection_info:
      database_url:
        from_env: PG_DATABASE_URL
      isolation_level: read-committed
      pool_settings:
        # connection_lifetime: 600
        idle_timeout: 1
        # total_max_connections: 3
      use_prepared_statements: true
  tables: "!include default/tables/tables.yaml"
  functions: "!include default/functions/functions.yaml"
```
	
  * This example uses a Hasura REST endpoint because it makes it easy
    to generate load with the `ab` tool.

  * The REST endpoint access a function `product_search_slow` which is
    deliberately designed to wait for an interval.  This is so that
    we can force the use of new connections (or blocking).  Otherwise
    for simple queries, postgres serves requests too fast and it
    becomes difficult to see the pgbouncer pool functioning.
