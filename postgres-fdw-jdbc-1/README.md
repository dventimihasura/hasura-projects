# Abstract #

This is a Proof-Of-Concept (POC) demonstrating how to use PostgreSQL
and its Foreign Data Wrapper (FDW) support as a gateway to a
heterogeneous array of data sources. 

# What #

This POC uses a PostgreSQL database instance as a gateway to other
databases (PostgreSQL, MySQL, Oracle, DB2).

# Why #

Hasura users looking for a way to use other data sources for which
Hasura does not yet have first-class support or GraphQL Data Connector
(GDC) support may find this approach useful as an alternative in the
interim. 

# How #

Database servers for PostgreSQL, MySQL, Oracle, and DB2 are
simultaneously started.  Each is initialized with the same data model,
based on the Chinook database.  In the `docker-compose.yaml` file they
are in these services.

  * `postgres`
  * `mysql`
  * `oracle`
  * `db2`
  
In addition, another PostgreSQL server instance is started, named
`gateway`.  Also, a Hasura server instance is started in
`graphql-engine`.  The `gateway` PostgreSQL instance has extensions
for these Foreign Data Wrappers.

  * `postgres-fdw`
  * `oracle-fdw`
  * `jdbc-fdw`

These are used to create foreign servers to each of the other
databases, `postgres`, `oracle`, `mysql`, `db2`.  The first two of
those, `postgres` and `oracle`, have their foreign servers created
using the `postgres-fdw` and `oracle-fdw` foreign data wrappers,
respectively.  The latter two, `mysql` and `dbw`, hae their foreign
servers created using the `jdbc-fdw` foreign data wrapper (for now).

The Chinook tables (`album`, `artist`, `customer`, `employee`,
`genre`, `invoice`, `invoiceline`, `mediatype`, `playlist`,
`playlisttrack`, `track`) are imported from each of these foreign
servers (all mapped to databases that all have the same data model and
data) into appropriately-named schema in the `gateway` PostgreSQL
database:  `postgres`, `mysql`, `oracle`.

**NOTE**: `db2` is ommited for now.

The data model is then divided in three broad domains, each devoted to
a different database.

  * `postgres`:  `customer`, `employee`, `invoice`, `invoiceline`
  * `mysql`:  `album`, `artist`, `genre`, `mediatype`, `track`
  * `oracle`: `playlist`, `playlisttrack`
  
As these are all tables in *one* database instance (`gateway`), albeit
*foreign* tables, they can be treated by Hasura as such.
Consequently, regular non-remote relationships are created among these
tables.  This can be done even though they are in different schema, of
course.  

Finally, this supports GraphQL queries such as the following example,
which joins data from three different databases, PostgreSQL, MySQL,
and Oracle, without schema-stitching, remote joins, or remote
databases.  

```graphql
query MyQuery {
  postgres_customer(limit: 10) {
    firstname
    lastname
    invoices {
      total
      invoicelines {
        unitprice
        quantity
        track {
          name
          milliseconds
          mediatypeid
          genre {
            name
          }
          album {
            title
            artist {
              name
            }
          }
          playlisttrack {
            playlistid
            playlist {
              name
            }
          }
        }
      }
    }
  }
}
```


# Steps #

1. Clone this repository.

```shell
git clone https://github.com/dventimihasura/hasura-projects
```

2. Change to the `postgres-fdw-jdbc-1` sub-directory.

```shell
cd postgres-fdw-jdbc-1
```

3. Use Docker Compose to build the Docker image and launch the
   services.
   
```shell
docker-compose up -d --build
```

4. Deploy the Hasura migrations and metadata.  **NOTE: If you have set
   up Multi-Factor Authentication (MFA) with your Snowflake account
   then you should be alert for push notifications on your MFA device
   as Snowflake connections are established.**

```shell
hasura deploy
```

5. Access the Hasura Console via http://localhost:9080 and try out
   GraphQL queries like the following:
   
```graphql
query MyQuery {
  postgres_customer(limit: 10) {
    firstname
    lastname
    invoices {
      total
      invoicelines {
        unitprice
        quantity
        track {
          name
          milliseconds
          mediatypeid
          genre {
            name
          }
          album {
            title
            artist {
              name
            }
          }
          playlisttrack {
            playlistid
            playlist {
              name
            }
          }
        }
      }
    }
  }
}
```

<!--  LocalWords:  FDW fdw jdbc cron TTL cd TODO env
 -->
