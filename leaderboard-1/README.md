# What #

This project explores approaches for building a leader-board with
PostgreSQL and Hasura.

# Why #

Hasura users have asked for example in
[GitHub Issue 8923](https://github.com/hasura/graphql-engine/discussions/8923
"GitHub Issue 8923") how to build a leader-board with PostgreSQL and
Hasura.  Concerns about scalability and performance were raised.

A "leader-board" is a database result that imposes a [total
order](https://en.wikipedia.org/wiki/Total_order "total order") over a
set (a table, view, query result, etc.) and assigns
monotonically-increasing numerical rank to items in the set.  Common
query patterns are:

1. Find the top N items.
2. Find the rank of a particular item.
3. Find the item with a particular rank.
4. Find items in a range of ranks.

# How #

This is a Hasura project with a PostgreSQL database.  The database has
these tables.

`first_name`
: 1000 fictitious first names

`last_name`
: 1000 fictitious last names

`account`
: 1000000 accounts generated from the Cartesian product of `first_name`
  and `last_name`
  
`leads_aggregate`
: 1000000 entries one for each `account` with a randomly generated
  numerical value for `referrals`.  Values are chosen between 0
  and 1000000. 
  
The database also has one view.

`leaderboard`
: As many entries as in `account` and `leads_aggregate` assigning a
  rank to each according to a total order over the value in
  `referrals`. 

The database also has one materialized view.
  
`leaderboard_snapshot`
: As many entries as in `leaderboard` storing the contents of that
  view in order to speed up queries.
  

The first fundamental element in this proof-of-concept (POC) is the
`leaderboard` view, whose definition is this.

```sql
CREATE OR REPLACE VIEW public.leaderboard AS
 SELECT rank() OVER (ORDER BY leads_aggregate.referrals DESC, account.name) AS rank,
    leads_aggregate.id
   FROM leads_aggregate
     JOIN account ON account.id = leads_aggregate.account_id
```

It has these important details.

1. It uses a
   [rank](https://www.postgresql.org/docs/current/functions-window.html
   "window function") ordered by `leads_aggregate.referrals` and by
   `account.name` to assign a numerical rank to satisfy leaderboard
   queries. 
2. The `account.name` field is included in the ordering only to break
   ties.  This is a far from optimal choice, first because the account
   name is not a very useful way to break ties.  Moreover, it is an
   imperfect way to break ties, as account names are not required to
   be unique.  A better choice of field for breaking ties might be
   `account.created_at` as in practice this will be unique, and also
   assigns priority to earlier accounts.  However, an unimportant
   technical detail in this POC is that all `account` entries have the
   same `created_at` and so it cannot be used to break ties.
3. The view includes the bare minimum of necessary fields: `id` and
   `rank`.  Additional fields would be superfluous as they can be
   obtained by joining to the `leads_aggregate` table on the related
   key. 
   
## Example SQL Queries ##

## Top-10 With a filter, Without ORDER BY, Without LIMIT ##

```sql
select
  account.id,
  account.name,
  leads_aggregate.referrals,
  leaderboard_snapshot.rank
  from
    leaderboard_snapshot
    join leads_aggregate on leads_aggregate.id = leaderboard_snapshot.id
    join account on account.id = leads_aggregate.account_id
 where rank <= 10;
```

## Top-10 Without a filter, With ORDER BY, With LIMIT ##

```sql
select
  account.id,
  account.name,
  leads_aggregate.referrals,
  leaderboard_snapshot.rank
  from
    leaderboard_snapshot
    join leads_aggregate on leads_aggregate.id = leaderboard_snapshot.id
    join account on account.id = leads_aggregate.account_id
 order by leaderboard_snapshot.rank
 limit 10;
```

## Find the rank of a particular account ##

```sql
with
  sample as (
    select
      id
      from
	account
	  tablesample system_rows(1)
  )
select
  account.id,
  account.name,
  leads_aggregate.referrals,
  leaderboard_snapshot.rank
  from
    leaderboard_snapshot
    join leads_aggregate on leads_aggregate.id = leaderboard_snapshot.id
    join account on account.id = leads_aggregate.account_id
    join sample on sample.id = account.id;
```

## Find the account with a particular rank ##

```sql
with
  sample as (
    select
      avg(rank)::int as rank
      from
	leaderboard_snapshot
  )
select
  account.id,
  account.name,
  leads_aggregate.referrals,
  leaderboard_snapshot.rank
  from
    leaderboard_snapshot
    join leads_aggregate on leads_aggregate.id = leaderboard_snapshot.id
    join account on account.id = leads_aggregate.account_id
    join sample on sample.rank = leaderboard_snapshot.rank;
```

## Find accounts with a range of ranks ##

```sql
with
  sample as (
    select
      avg(rank)::int as rank
      from
	leaderboard_snapshot
  )
select
  account.id,
  account.name,
  leads_aggregate.referrals,
  leaderboard_snapshot.rank
  from
    leaderboard_snapshot
    join leads_aggregate on leads_aggregate.id = leaderboard_snapshot.id
    join account on account.id = leads_aggregate.account_id
    join sample on leaderboard_snapshot.rank between sample.rank - 2 and sample.rank + 2;
```

## Example GQL Queries ##

### Top-10 With a filter, Without ORDER BY, Without LIMIT ###

```graphql
query MyQuery {
  leaderboard_snapshot(where: {rank: {_lte: "10"}}) {
    id
    rank
    leads {
      referrals
      account {
        id
        name
        created_at
      }
    }
  }
}
```

### Top-10 Without a filter, With ORDER BY, With LIMIT ###

```graphql
query MyQuery {
  leaderboard_snapshot(order_by: {rank: asc}, limit: 10) {
    id
    rank
    leads {
      referrals
      account {
        id
        name
        created_at
      }
    }
  }
}
```

## Find the rank of a particular account ##

```graphql
```

## Find the account with a particular rank ##

```graphql
query MyQuery {
  leaderboard_snapshot(where: {rank: {_eq: "500000"}}) {
    id
    rank
    leads {
      referrals
      account {
        id
        name
        created_at
      }
    }
  }
}
```

## Find accounts with a range of ranks ##

```graphql
query MyQuery {
  leaderboard_snapshot(where: {rank: {_in: [499998, 499999, 500000, 500001, 500002]}}) {
    id
    rank
    leads {
      referrals
      account {
        id
        name
        created_at
      }
    }
  }
}
```

## Notes ##

1. Filtering by `rank` rather than ordering by `rank` and imposing a
   `limit` typically is more efficient as it does not require a
   potentially-expensive ordering operation.  In practice, it may make
   little difference, as it does here.
2. The queries examples above use the `leaderboard_snapshot`
   materialized view for optimal query performance, by trading off
   accuracy.  I.e., the materialized view is only accurate up to the
   most recent time it was built or refreshed.
   Performance-vs-accuracy is a common trade-off in systems of any
   kind. 
3. Suitable indexes were placed on the necessary tables and views.
4. The GraphQL version of the query to "Find accounts with a range of
   ranks" is cumbersome because the Hasura GraphQL API does not
   support `between` predicates in filters.

# Steps #

1. Clone this repository.

```shell
git clone git@github.com:dventimihasura/hasura-projects.git
```

2. Change to the `leaderboard-1/hasura` directory.

```shell
cd hasura-projects/leaderboard-1/hasura
```

3. Launch the services using Docker Compose.

```shell
docker-compose up -d
```

4. Use the Hasura CLI to apply the metadata, apply the migrations,
   reload the metadata, load the seed data, and launche the console.
   
```shell
hasura metadata apply
hasura migrate apply
hasura metadata reload
hasura seed apply
hasura console
```

5. In Hasura Console, in the Data Tab, in the SQL editor, execute this
   SQL statement to refresh the materialized view.
   
```sql
refresh materialized view leaderboard_snapshot
```

6. (Optional) connect to the database using `psql` in another terminal.

```shell
psql "postgresql://postgres:postgrespassword@localhost:5432/postgres"
```

<!--  LocalWords:  TotalOrder leaderboard POC DESC tablesample
 -->
