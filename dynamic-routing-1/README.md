# What #

This Proof-Of-Concept (POC) illustrates using [Dynamic Routing for Databases](https://hasura.io/docs/latest/databases/database-config/dynamic-db-connection/) to choose different [Transaction Isolation](https://www.postgresql.org/docs/current/transaction-iso.html) levels based on the `x-hasura-role` header.

# Why #

Hasura users may want to offer different transaction guarantees to different levels of users.

# How #

Hasura's Dynamic Routing for Databases uses Kriti templates evaluated over values like those of headers and session variables in order to resolve to member connections from a set of defined database connections called a connection set.  Like standard connections in Hasura, the connections within a Hasura connection set can have their transaction isolation level specified.  In this POC we create a connection set with 4 members `[default, default-serializable, default-read-committed, default-repeatable-read]` with different transaction guarantees.  We also create a Kriti template over `x-hasura-role` to route to these different connections.

## Note 1 ##

Because we write a Kriti template over the `x-hasura-role` session variable, this automatically invokes Hasura's Authorization mechanism.  Consequently, Hasura Authorization permissions must be created for every table and every role in order for data access to occur.  This step could be avoided by writing the Kriti template over a different variable (e.g. `transaction-isolation-level`) which is not the Hasura keyword `x-hasura-role`.  Naturally, the configured Identity Provider (IDP) would have to supply the value for this custom session variable.

## Note 2 ##

The Hasura Console has a User Interface (UI) bug which prevents the transaction isolation level from being set for the connections within a connection set.  Consequently, the Hasura metadata was edited by hand to include the transaction isolation level.  See the `databases.yaml` file.

# Steps #

## Step 1 ##

Clone this GitHub repository.

```bash
git clone https://github.com/dventimihasura/hasura-projects.git
```

## Step 2 ##

Change to the `dynamic-routing-1` project sub-directory.

```bash
cd hasura-projects/dynamic-routing-1
```

## Step 3 ##

Create a `.env` Docker Compose [environment](https://docs.docker.com/compose/environment-variables/set-environment-variables/) file.

```
cat <<EOF > .env
HASURA_GRAPHQL_ADMIN_SECRET=<your Hasura admin secret>
HASURA_GRAPHQL_EE_LICENSE_KEY=<your Hasura EE license key>
HASURA_PORT=<your Hasura exposed port>
POSTGRES_PORT=<your PostgreSQL exposed port>
EOF
```
## Step 4 ##

Start the services with Docker Compose

```bash
docker compose up -d
```

## Step 5 ##

Use the Hasura CLI to launch the Hasura Console.

```bash
hasura console
```

## Step 6 ##

Perform GraphQL queries like the following.

```graphql
query MyQuery {
  product(limit: 10) {
    id
    name
  }
}
```

## Step 7 ##

Repeat Step 6 with different settings for the `x-hasura-role` header:

   * serializable
   * read-committed
   * repeatable-read
