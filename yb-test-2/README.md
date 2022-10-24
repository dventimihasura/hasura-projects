# Abstract #

# What #

# Why #

# How #

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

