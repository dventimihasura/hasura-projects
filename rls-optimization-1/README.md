# README #

## Steps ##

Launch the `postgres` and service using Docker Compose.

```bash
docker compose up -d
```

Run the `bench.sql` script which uses the application of in-database
PostgreSQL Row Level Security (RLS) or Row Security Policies.  Run the
benchmark script for 60 seconds on 1 client.

```bash
pgbench -c 1 -f bench.sql -n -T 60 -h localhost -p 5433 -U postgres postgres
```
