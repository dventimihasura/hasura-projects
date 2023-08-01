# What #

This demo illustrates using Hasura [Kriti](https://hasura.io/docs/latest/api-reference/kriti-templating/) templates to set a Snowflake GDC connection string in the metadata from environment variables.

# Why #

Storing secrets in environment variables is more secure than leaking those credentials into Hasura metadata files, but using those environment variables in Hasura metadata at run-time requires Kriti templates, whose usage is not obvious.

# How #

This demo uses a Docker Compose file to create these services.

  * `postgres` :: PosgreSQL database merely to act as a metadata database for Hasura
  * `hasura` :: Hasura HGE graphql-engine instance using a GDC agent for Snowflake connectivity
  * `data-connector-agent` :: Hasura GDC agent
  
It also uses a Hasura Docker image that [automatically](https://hasura.io/docs/latest/migrations-metadata-seeds/auto-apply-migrations/) applies metadata.  This is merely to save a few steps in running the demo.

# Steps #

## Step 1 ##

Clone this GitHub repostory.

```bash
git clone https://github.com/dventimihasura/hasura-projects.git
```

## Step 2 ##

Change to the `snowflake-test-1` project sub-directory.

```bash
cd snowflake-test-1
```

## Step 3 ##

Create a `.env` Docker Compose [environment](https://docs.docker.com/compose/environment-variables/set-environment-variables/) file.

```
cat <<EOF > .env
DEFAULT_HOST=<your Snowflake hostname>
DEFAULT_PASS=<your Snowflake password>
DEFAULT_USER=<your Snowflake username>
HASURA_GRAPHQL_ADMIN_SECRET=<your Hasura admin secret>
HASURA_GRAPHQL_EE_LICENSE_KEY=<your Hasura EE license key>
HGE_PORT=<your exposed Hasura port>
EOF
```

## Step 4 ##

Use a text editor to edit the `.env` file and replace the template values as appropriate.

  * `HASURA_GRAPHQL_ADMIN_SECRET` :: Enterprise requires an [admin-secret](https://hasura.io/docs/latest/deployment/graphql-engine-flags/config-examples/).
  * `HASURA_GRAPHQL_EE_LICENSE_KEY` :: Snowflake requires [enterprise](https://hasura.io/docs/latest/enterprise/upgrade-ce-to-ee/).
  * `HGE_PORT` :: Port to expose Hasura on
  * `SNOWFLAKE_URL` :: See the Snowflake JDBC [docs](https://docs.snowflake.com/en/developer-guide/jdbc/jdbc-configure).
  * `DEFAULT_HOST` :: See the Snowflake JDBC [docs](https://docs.snowflake.com/en/developer-guide/jdbc/jdbc-configure).
  * `DEFAULT_USER` :: See the Snowflake JDBC [docs](https://docs.snowflake.com/en/developer-guide/jdbc/jdbc-configure).
  * `DEFAULT_PASS` :: See the Snowflake JDBC [docs](https://docs.snowflake.com/en/developer-guide/jdbc/jdbc-configure).
  
## Step 5 ##

Launch the services with Docker Compose.

```bash
[docker-compose|docker compose] up -d
```

## Step 6 ##

Use the Hasura CLI to launch the Console and begin data modeling.

```bash
hasura console --endpoint http://localhost:[HGE_PORT] --admin-secret [HASURA_GRAPHQL_ADMIN_SECRET]
```

## Step 7 ##

Examine the `databases.yaml` file in order to understand how the metadata must be written in order to templatize the JDBC connection string.

```bash
cat metadata/databases/databases.yaml
```

I.e. the configuration will look like this.

```yaml
- name: snowflake
  kind: snowflake
  configuration:
    template: '{"fully_qualify_all_names": false, "jdbc_url": "{{getEnvironmentVariable("SNOWFLAKE_URL")}}"}'
    timeout: null
    value: {}
  tables: "!include snowflake/tables/tables.yaml"
```
