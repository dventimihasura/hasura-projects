# Abstract #

# What #

# Why #

# How #

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
```
