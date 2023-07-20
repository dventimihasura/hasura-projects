# Abstract #

Hasura Load Testing with YugaByte

# What #

This project sets up a very basic 4-node Yugabyte database cluster in
a local environment and configures it with Hasura and a simple
illustrative data model for load testing purposes.

# Why #

We wish to benchmark Hasura performance on YugaByte.

# How #

Yugabyte has a variety of provisioning choices (local install, Docker
container, cloud-managed).  This project uses Docker containers
orchestrated with Docker Compose.  It has a `docker-compose.yaml` file
that launches these services:

1. Yugabyte master node x 1
2. Yugabyte worker ("tablet") nodes x 3
3. Hasura graphql-engine node

# Steps #

1. Clone this repository.

```shell
git clone https://github.com/dventimihasura/hasura-projects
```

2. Change to the `yb-test-2` sub-directory.

```shell
cd yb-test-2
```

3. Launch the services (PostgreSQL with PostGIS, Hasura) using Docker
   Compose.
   
```shell
docker-compose up -d
```

4. Run a Locust load test.

```shell
docker run \
  -v ./:/mnt/locust \
  --network yb-test-2_default \
  --ulimit nofile=15000:15000 \
  locustio/locust:2.15.1 \
  --headless \
  --only-summary \
  -t 60s \
  -f /mnt/locust/locustfile.py \
  -H http://graphql-engine:8080 \
  -u 10 \
  FastPerfTest
```
