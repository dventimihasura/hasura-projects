# Abstract #

# What #

This project sets up a very basic 4-node Yugabyte database cluster in
a local environment and configures it with Hasura and a simple
illustrative data model.

# Why #

We wish to run automated test suites against a variety of database
products, including Yugabyte.  While some vendors offer cloud-hosted
products which might be used for testing purposes, it also is prudent
to understand how to run these products "locally" in a way that fits
in with automated test harnesses that produce consistent and reliable
results. This project explores and illustrates how to run Yugabyte
"locally" using Docker Compose, and also how to integrate it with a
Hasura instance also running locally.

# How #

Yugabyte has a variety of provisioning choices (local install, Docker
container, cloud-managed).  This project uses Docker containers
orchestrated with Docker Compose.  It has a `docker-compose.yaml` file
that launches these services:

1. Yugabyte master node x 1
2. Yugabyte worker ("tablet") nodes x 3
3. Hasura graphql-engine node

The project directory is also configured to be a Hasura CLI project
with a `config.yaml` file and `metadata` and `migrations`
directories.  These can be used to initialize a simple data model (an
online grocery store).  In practice, automated test suites will use
their own data models, of course.

# Steps #

1. Clone this repository.

```shell
git clone https://github.com/dventimihasura/hasura-projects
```

2. Change to the `yb-test-2` sub-directory.

```shell
cd yb-test-2
```

3. Launch the services (PostgreSQL with PostGIS, Hasura) using Docker
   Compose.
   
```shell
docker-compose up -d
```

4. Use the Hasura CLI to apply the metadata, apply the migrations,
   reload the data, and launch the Console.
   
```shell
hasura deploy
```

5. Run this query.
   
```graphql
query MyQuery {
  account(limit: 10) {
    name
    orders {
      region
      order_details {
        units
        product {
          name
          price
        }
      }
    }
  }
}
```

