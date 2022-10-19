# Abstract #

We explore the feasibility of using Row Level Security (RLS) provided
by the database, with Hasura.

# What #

This is a Proof-of-Concept (POC) that demonstrates how to use
PostgreSQL [Row Security
Policies](https://www.postgresql.org/docs/current/ddl-rowsecurity.html)
(RSP) with Hasura *mutations*.

**NOTE**: PostgreSQL RSP *can only be used with mutations* currently.
This is because Hasura
[currently](https://github.com/hasura/graphql-engine-mono/blob/bf6b01a8fa07e42efe9ab9ebdae0a90757a4c34b/server/src-lib/Hasura/Backends/Postgres/Connection/MonadTx.hs#L124)
uses `SET LOCAL` in a database connection to set a local variable in
the connection's transaction for `hasura.user` to a JSON object with
an attribute containing the `x-hasura-user-id` session variable, but
does so *only for transactions began with BEGIN*.  GraphQL queries do
not normally occur within a transaction marked with `BEGIN` and so
`SET LOCAL` cannot be used with them.  It *may* be possible to fix
this by wrapping all Hasura GraphQL query `SELECT` statements in a
`BEGIN...COMMIT` OR `BEGIN...ROLLBACK` transaction, though this would
need to be tested.

# Why #

Hasura Authorization may be redundant when the underlying database
offers an adequate "Row Level Security" (RLS) mechanism.  Moreover,
there may be reasons why people would want to implement Authorization
more tightly within the data model, directly in the database using the
features that it provides.  This POC explores the feasibility of this
approach.

# How #

This POC sets up a simple data model for a retail outlet (a grocery
store) with tables for `account`, `order`, `order_detail`, `product`,
etc., and then adds PostgreSQL polices to those tables.  For example,
the policy on `account` table is created in the following way.

```sql
create policy query on account for select using (true);

create policy mutation on account for all using ((current_setting('hasura.user')::jsonb->>'x-hasura-user-id')::uuid = id);
```

This creates two policies on `account`.  The first policy for `select`
effectively "white-lists" all operations.  Everyone can issue `select`
queries against the `account` table.  The second policy for `all`
(`select`, `update`, `insert`, `delete`) only allows operations when a
local variable `hasura.user` is a JSON object whose `x-hasura-user-id`
attribute matches the primary key `account.id`.  I.e., this policy
says, "Only allow these operations (select, update, insert, delete)
when there is a local variable with information indicating the user
'owns' the target row(s)."  Note that by default, PostgreSQL policies
are combined using a logical "or."  Therefore, with the combination of
these two policies, anyone can select from the `account` table, but
only "row owners" (identified using the local variable mechanism) can
make changes to the row.

# Steps #

1. Clone this repository.

```shell
git clone https://github.com/dventimihasura/hasura-projects
```

2. Change to the `row-security-policies-1/hasura` directory.

```shell
cd row-security-policies-1/hasura
```

3. Launch the services using Docker Compose.

```shell
docker-compose up -d
```

4. Use the Hasura CLI to deploy the application.

```shell
hasura deploy
```

5. Use `curl` to submit a GraphQL query to find an account to try to
   update. 
   
```shell
curl -s 'http://localhost:8080/v1/graphql' -H 'Accept-Encoding: gzip, deflate, br' -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'Connection: keep-alive' -H 'Origin: chrome-extension://flnheeellpciglgpaodhkhmapeljopja' -H 'x-hasura-admin-secret: ijawqhgVtsykcSJxCRYpAEYnmM475uGbATuyyG5kGHt83M8BUMNhkPH2IH6o4WL9' -H 'x-hasura-user-id: 530df8ec-8fa4-4a9a-8c18-2eb6715d2e08' --data-binary '{"query":"query{account(limit:10){id name}}","variables":{}}' --compressed | jq -r '.'
```

6. Use `curl` to submit a GraphQL mutation to try to change an
   account, first without supplying `x-hasura-user-id` as a header.
   Note that the data does not change because it violates the
   PostgreSQL policy that was created on the `account` table.
   
```shell
curl 'http://localhost:8080/v1/graphql' -H 'Accept-Encoding: gzip, deflate, br' -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'Connection: keep-alive' -H 'Origin: chrome-extension://flnheeellpciglgpaodhkhmapeljopja' -H 'x-hasura-admin-secret: ijawqhgVtsykcSJxCRYpAEYnmM475uGbATuyyG5kGHt83M8BUMNhkPH2IH6o4WL9' --data-binary '{"query":"mutation UpdateAccount{update_account_by_pk(_set:{name:\"Test Test Test\"}pk_columns:{id:\"530df8ec-8fa4-4a9a-8c18-2eb6715d2e08\"}){id name}}","variables":{}}' --compressed
```

7. Use `curl` to submit a GraphQL mutatation to try to change an
   account, this time supplying the matching `x-hasura-user-id` as a
   heaer.  Note that this time the data does change because it does
   not violate the PostgreSQL policy that was created on the `account`
   table.
   
```shell
curl 'http://localhost:8080/v1/graphql' -H 'Accept-Encoding: gzip, deflate, br' -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'Connection: keep-alive' -H 'Origin: chrome-extension://flnheeellpciglgpaodhkhmapeljopja' -H 'x-hasura-admin-secret: ijawqhgVtsykcSJxCRYpAEYnmM475uGbATuyyG5kGHt83M8BUMNhkPH2IH6o4WL9' -H 'x-hasura-user-id: 530df8ec-8fa4-4a9a-8c18-2eb6715d2e08' --data-binary '{"query":"mutation UpdateAccount{update_account_by_pk(_set:{name:\"Test Test Test\"}pk_columns:{id:\"530df8ec-8fa4-4a9a-8c18-2eb6715d2e08\"}){id name}}","variables":{}}' --compressed
```
