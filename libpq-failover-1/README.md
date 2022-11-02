# High-Availability Fail-over for Hasura Data (Almost) For Free #

Hasura users often seek
[High-Availability](https://en.wikipedia.org/wiki/High_availability)
(HA) for their data sources. Here we illustrate a simple way to obtain
a crucial element of HA.  HA is a broad topic with several related but
still independent elements, and while we can't address them all in
just one article we can address one of them:
[fail-over](https://en.wikipedia.org/wiki/Failover).

Fail-over for a data application typically involves multiple redundant
database instances, with the application switching from a primary
instance experiencing a failure event to a secondary instance acting
as a [warm
standby](https://www.postgresql.org/docs/8.2/warm-standby.html).  A
warm standby is a read-only instance whose state is replicated from
the primary (replication being another crucial element of HA *not*
covered here).  During fail-over, the secondary is promoted to becoming
a new primary, it switches from read-only mode to
read-write mode, and downstream applications respond seamlessly.  

Fail-over is also a feature built into the libpq library.  The
[libpq](https://www.postgresql.org/docs/9.5/libpq.html) library is the
connection library provided by the PostgreSQL project, it supports the
PostgreSQL wire-protocol, and it is the basic communication library
for almost all PostgreSQL clients, which *includes* Hasura.  The libpq
library is responsible for consuming database connection strings and
establishing connections, and one nice feature is that it actually
accepts connection strings with a [multiple host
entries](https://www.postgresql.org/docs/current/libpq-connect.html).
It will attempt connections to each host in turn and in this way
offers a basic implementation of fail-over. The libpq library does this
and as a consequence Hasura does this.  This is what is illustrated
here in this Proof-Of-Concept (POC).

## General Steps ##

1. Set up multiple redundant database instances with replication of
   state and data from a read-write *primary* to some number of
   read-only *secondary* nodes.  There are many ways to do this and a
   production setup is beyond the scope of this article, but this is
   demonstrated in a simple way in this POC.
2. Provide libpq clients with a connection string whose host portion
   is a comma-separated value (CSV) list of hosts.
   
That's really all there is to it.  It's just that easy!  The crucial
step is Step 2 above, where we provide a connection string that looks
like this.

```
postgresql://postgres:postgrespassword@primary,secondary:5432/postgres
```

It's the primary,secondary part that is the secret ingredient.  The
libpq library recognizes this as a list of hosts to which it should
attempt connections, in order.  If a connection attempt fails, the
library will retry with the next host in the list.  If no host in the
list can successfully establish a connection, only then will the
overall connection attempt fail.

## Particular Steps ##

The particular steps for this POC are as follows.

1. Clone the Git repository that contains this project and change to
   the project directory.

```shell
git clone https://github.com/dventimihasura/hasura-projects
cd hasura-projects/libpq-failover-1
```

2. Use Docker Compose to launch the services:

	1. primary: primary PostgreSQL database instance housing
       operational data
	2. secondary: secondary PostgreSQL database instance housing
       operational data, replicated from the primary
	3. metadata: PostgreSQL database instance housing metadata, not
       involved in failover
	4. graphql-engine: Hasura instance using all three databases
	
```shell
docer compose up -d
```
	
3. Use the Hasura CLI to set up the demo data model and data.

```shell
hasura deploy
```

4. Issue GraphQL queries against Hasura, which will be satisfied using
   the primary database.
	   
```shell
curl 'http://localhost:8080/v1/graphql' -H 'Accept-Encoding: gzip, deflate, br' -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'Connection: keep-alive' -H 'Origin: chrome-extension://flnheeellpciglgpaodhkhmapeljopja' -H 'x-hasura-admin-secret: ijawqhgVtsykcSJxCRYpAEYnmM475uGbATuyyG5kGHt83M8BUMNhkPH2IH6o4WL9' -H 'x-hasura-user-id: 530df8ec-8fa4-4a9a-8c18-2eb6715d2e08' --data-binary '{"query":"query{account(limit:10){id name orders{region status order_details{product{name price}units}}}}","variables":{}}' --compressed | jq -r '.'
```
   
5. Promote the secondary read-only database instance to be a primary
   read-write instance.
   
   
```shell
docker-compose exec postgres-slave touch /tmp/postgresql.trigger.5432
```

6. Stop the original primary database instance in order to simulate
   failure. 
   
```shell
docker-compose stop postgres-master
```

7. Issue more GraphQL queries against Hasura and notice that the still
   succeed even though the original primary database can no longer
   satisfy these queries, and we never restarted Hasura.


```shell
curl 'http://localhost:8080/v1/graphql' -H 'Accept-Encoding: gzip, deflate, br' -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'Connection: keep-alive' -H 'Origin: chrome-extension://flnheeellpciglgpaodhkhmapeljopja' -H 'x-hasura-admin-secret: ijawqhgVtsykcSJxCRYpAEYnmM475uGbATuyyG5kGHt83M8BUMNhkPH2IH6o4WL9' -H 'x-hasura-user-id: 530df8ec-8fa4-4a9a-8c18-2eb6715d2e08' --data-binary '{"query":"query{account(limit:10){id name orders{region status order_details{product{name price}units}}}}","variables":{}}' --compressed | jq -r '.'
```

## Notes ##

There are several things to note here.  First, this POC sets up a
simple toy replication scheme between multiple databases (primary,
secondary) using streaming replication.  An easy way to do this is to
use the bitnami-docker-postgresql Docker image.  This is a version of
PostgreSQL packaged up in a Docker image, augmented with an easy way
to set up streaming replication:  just specify certain environment
variables.  

Second, a third database called `metadata` is used to house the Hasura
metadata.  This isn't strictly necessary, but housing the metadata in
a different database is a feature Hasura offers.  Moreover it just
simplifies matters for demonstration purposes since only the data and
not the metadata is experiencing failover. 

Third, failover is simulated in two steps.  The read-only secondary is
promoted to being a read-write primary.  Then, the original read-write
primary is stopped to simulate failure.  The bitnami Docker image is
set up to respond to the creation of a special `trigger_file` in the
`/tmp` folder.  A read-only secondary instance will notice the
presence of this file and automatically promote itself to a primary
read-write node.  The original read-write instance is of course
stopped with a simple Docker Compose command to stop its service.

## Summary ##

Again, HA is a broad topic.  It can apply not just to the data sources
that Hasura uses, but to the Hasura instances itself, as well as to
other components in an application (cache layers, integration points,
etc.)  HA can be applied in layers and its application in those layers
can even overlap.  Moreover, there are many different ways to layer in
HA capabilities.  

This POC illustrates just *one* way to layer in *one* element of HA in
*one* component:  *failover* in the *database* using *libpq*.  This is
a nice feature of the libpq library, it's available to almost any
application that is built with libpq, it's therefore available in
Hasura, and it can be a *part* of an emerging HA story for any project
that uses Hasura.


<!--  LocalWords:  libpq cd failover postgres bitnami postgresql tmp
 -->
