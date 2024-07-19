#!/bin/bash
set -e

curl -s https://davidaventimiglia-hasura.sfo3.cdn.digitaloceanspaces.com/postgres_air.gz | gunzip | psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB"
