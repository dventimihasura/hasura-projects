# What #

This Proof-Of-Concept (POC) demonstrates asynchronous messaging with Hasura Custom Events, operating in an auction involving truckers who want to receive message notifications when there are product deliveries whose origin and destination match the origin and destination of routes on their schedules, so that they can bid on those matching delivieries.

# Why #

Watching for updates to `delivery` and `route` tables via GraphQL Subscriptions alone could potentially be an expensive operation contending for limited resources in order to support the many websocket connections and related queries.  This explores an alternative using database triggers and Hasura Custom events.

# How #

The `delivery` table captures planned deliveries of a `product` between an origin `region` and a destination `region` starting within a date range.

The `route` table captures planned journeys of a trucker with an `account` between an origin `region` and a destination `region` starting within a date range.

The `route_message` table captures messages intended to notify a trucker with an `account` that there are matches among the origin `region` and `destination` region for `delivery` and `route` journeys starting within an overlapping date range.  It is this table that would be the target of Hasura Custom events.

The `generate_messages` trigger function (and matching triggers) fires when rows are inserted into the `route` and/or `delivery` table, to check for matches and add corresponding entries to the `route_message` table.

The `run_simulation` function randomly generates `delivery` and `route` journeys distributed over the next 10 days, for randomly chosen `product` entries and `account` truckers.  Because the data are random, it is not guaranteed that there will be matches between the `route` and `delivery` entries.  In practice, 100 each of `route` and `delivery` is sufficient for there to be a dozen or so matches so that messages can be added to the `route_message` table.

# Steps #

## Step 1 ##

Clone this GitHub repostory.

```bash
git clone https://github.com/dventimihasura/hasura-projects.git
```

## Step 2 ##

Change to the `async-auction-notifications-1` project sub-directory.

```bash
cd async-auction-notifications-1
```

## Step 3 ##

Create a `.env` Docker Compose [environment](https://docs.docker.com/compose/environment-variables/set-environment-variables/) file.

```
cat <<EOF > .env
HGEPORT=<your exposed Hasura port>
PGPORT=<your exposed PostgreSQL port>
EOF
```

## Step 4 ##

Use a text editor to edit the `.env` file and replace the template values as appropriate.

  * `HGEPORT` :: Port to expose Hasura on
  * `PGPORT` :: Port to expose PostgreSQL on
  
## Step 5 ##

Launch the services with Docker Compose.

```bash
[docker-compose|docker compose] up -d
```

## Step 6 ##

Use the Hasura CLI to launch the Console and begin data modeling.

```bash
hasura console --endpoint http://localhost:[HGE_PORT]
```
