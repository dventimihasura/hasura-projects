# Abstract #

As of writing, Hasura currently has limited support for ordering and
filtering GraphQL queries that contain aggregates.  We illustrate how
to accomplish this by encapsulating the aggregates into a SQL function
that is tracked in Hasura like a table would be tracked.

# What #

This Proof-Of-Concept (POC) demonstrates how to use a [custom
function](https://hasura.io/docs/latest/schema/postgres/custom-functions/#pg-track-custom-sql-functions)
in Hasura in order to simulate a parameterized SQL view.

It models an online grocery store with these tables.

1. `account`
2. `order`
3. `order_detail`
4. `product`
5. `region`

Those tables are largely superfluous and can be ignored for this POC,
though `product` is important.  To these tables, this POC also adds

1. `merchant`
2. `product_price`

The `product_price` is a "join table" modeling a many-to-many
relationship between `merchant` and `product`.  I.e. a product can be
offered by many different merchants, and a merchant can offer many
different products.  Importantly, merchants offer a product at a
price, and products can be offered at different prices by different
merchants.  The goal is to answer questions like these:

> we want the products, along with the cheapest price within a range,
> but we also want to filter by specific merchants.

> we want products with id=1,2,3 along with cheapest prices < 100,
> provided by the merchants with id=7,8,9. Moreover, we want to sort
> by the cheapest price. 

For example, a GraphQL query related to these might look like this.
Note that this is only an *example* for illustrative purposes only.
This particular query will not work in the POC because the
`product_id` and `merchant_id` identifiers are generated randomly.  We
provide a SQL view `sample_graphql_query` to help write a sample
query given the extant data.

```graphql
query MyQuery {
  product_min_prices(
    args: {
      price: 50,
      product_ids: "{\"6cebad83-9fe6-4db3-b157-f38884c7dc8f\",\"32e9ed85-acf3-45e5-b773-6426424aded3\",\"b476db5c-6bd9-4882-be35-fcbb0479c746\"}",
      merchant_ids: "{\"8430cb04-893b-4de2-9cb7-0ad6dce406aa\",\"bb26ef4b-e8f7-4ffa-8155-4fc0a2bb237a\",\"c780172f-0ee8-4e0d-a4fa-e0182b4ed4e7\"}",
    })
  {
    product_id
    merchant_id
    price
    created_at
    id
    updated_at
    product {
      name
    }
    merchant {
      name
    }
  }
}
```

# Why #

Sometimes it is desireable or even necessary to encapsulate complex
SQL queries into views that accept parameters.  SQL views cannot
accept parameters, however.  Therefore, a SQL function often can be
substituted where one would ordinarily use a SQL view.

# How #

The procedure is quite straightforward.

1. Write the SQL query as desired but with constant literals in place
   of any parameters.
2. Follow the guidelines for Hasura [custom
   functions](https://hasura.io/docs/latest/schema/postgres/custom-functions/#pg-track-custom-sql-functions).
3. Track the function as a top-level field.
4. Manually configure any desired relationships with other tracked
   tables.
5. Write GraphQL queries involving the tracked function, substituting
   parameter arguments as necessary
   
# Notes #

1. Write the function to `return setof <table>` where `<table>` is
   already a tracked table.
2. Write the function to issue a `select <table>*` to ensure that the
   function returns a compatible column set.
3. Avoid `order by`, and `limit` clauses within the function in order
   to maximize its generality.
4. As always, pay close attention to any columns involved in `where`
   clauses, in `join` clauses, or in any `order by` or `group by`
   clauses.

# Steps #

1. Clone this repository.

```shell
git clone https://github.com/dventimihasura/hasura-projects
```

2. Change to the `product-price-1/hasura` sub-directory.

```shell
cd product-price-1/hasura
```

3. Launch the services (PostgreSQL Hasura) using Docker Compose.

```shell
docker-compose up -d
```

4. Use the Hasura CLI to apply the metadata, apply the migrations, reload the data, and launch the Console.

```shell
hasura deploy
```

5. Use `psql` to request a sample GraphQL query into the file `sample.graphql`.

```shell
psql -At "postgresql://postgres:postgrespassword@localhost:5432/postgres" -c "select query from sample_graphql_query" > sample.graphql
```

6. Copy the contents of `sample.graphql`, optionally edit as desired,
   paste into Hasura Console API tab "GraphiQL" pane and Execute
   Query.

7. Evaluate the efficiency of this operation by examining its query
   plan:  https://explain.dalibo.com/plan/ec95a7c468908678
