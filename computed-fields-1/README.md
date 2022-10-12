# Abstract #

In Hasura, ordering results by Computed Fields is not strictly
necessary since it is already possible to order results of Custom
Functions.  We illustrate how to do that here.

# What #

This is a Proof-Of-Concept (POC) that demonstrates how to use a
[custom function](https://hasura.io/docs/latest/schema/postgres/custom-functions/
"custom function") in Hasura in order to sort results by a "computed field."

# Why #

Some Hasura users have asked as in GitHub Discussion
[4356](https://github.com/hasura/graphql-engine/issues/4356 "4356")
for a new feature to allow sorting by "computed fields."
[Computed Fields](https://hasura.io/docs/latest/schema/postgres/computed-fields/
"Computed Fields") is one of the ways of extending a schema in Hasura
using functions, by adding a pseudo-field to a type, which is computed
using a database function.  Unlike with non-pseudo-fields, however,
the Hasura API does not permit sorting by these computed fields.

Until the feature to sort results by computed fields is added, it is
entirely possible to satisfy the general requirement not by extending
the schema with computed fields, but rather by extending the schema
with top-level fields from
[Custom Functions](https://hasura.io/docs/latest/schema/postgres/custom-functions/
"Custom Functions"). Top-level custom function fields have GraphQL
types and like types from tracked tables, they can be sorted like any
other type.

# How #

This POC adapts the "Hello, World!" example from [Chapter
1](https://livebook.manning.com/book/postgis-in-action-third-edition/chapter-1/)
from the
book "PostGIS In Action (3rd Edition)" from Manning Publishers.  That
example loads data containing restaurants and their locations as
latitude and longitude coordinates.  The actual data are from
[Fastfoodmaps.com](http://fastfoodmaps.com/) though those data have
been modified in this POC.

This POC has these important pieces which, in the database, are in the
`ch01` schema.

`restaurants` : restaurants with a `franchise` identifier (an md5 hash
of name and address) and a PostGIS `geometry` storing their `Point`
locations, with ~5000 entries.  Crucially, the `restaurants` table
*also* has a `distance double precision` field (nullable) to act as a
place-holder for distances between restaurants and a location.  In the
*table* that column is null, but functions that return this table as a
type (such as the `restaurants_near_to` function below) can supply
this value.

`restaurants_near_to` : a *function* that accepts `lat double
precision, lon double precision` arguments and returns `setof
restaurants`, essentially calculating *on-the-fly* the data for the
`restaurants_near` table *when* the `distance` column can be
calculated based on input parameters.

Importantly, GraphQL queries that invoke the top-level
`restaurants_near_to` field (which takes arguments, as it is supported
by a function) *CAN* include the `order_by` parameter against the
computed `distance` field.  This satisfies the general requirement to
sort by fields computed from a function, even if the particular
feature request to sort by a Computed Field on a tracked *table* is
not implemented.

**NOTE**:  As we saw, functions tracked as a top-level field return a
`setof <table>` where `<table>` is a table that is already being
tracked.  A crucial thing to understand is that top-level fields from
tracked functions *have the same relationships* as the tracked table
whose type they return.  In this case, the `restaurants_near_to`
top-level field *has the same relationships* as the `restaurants`
table.  In this example, the `restaurants` top-level field participates in
relationships with the `owner` table.  Consequently, the
`restaurants_near_to` top-level field *ALSO* participates in
relationships with the `owner` table.  This is convenenient, as it
means that queries involving the function can be enriched with nested
elements corresponding to related tables.  See the example query below
for an illustration of this.

# Steps #

1. Clone this repository.

```shell
git clone https://github.com/dventimihasura/hasura-projects
```

2. Change to the `computed-fields-1/hasura` sub-directory.

```shell
cd computed-fields-1/hasura
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

5. In Console's API tab, issue GraphQL queries to search for
   restaurants near to a latitude and longitude, sorting by
   `distance`.  
   
```graphql
query MyQuery {
  ch01_restaurants_near_to(args: {lat: "77.7843636", lon: "9.4664509"}, limit: 10, order_by: {distance: asc}, where: {owners: {id: {_is_null: false}}}) {
    id
    franchise
    distance
    owners {
      name
    }
  }
}
```
