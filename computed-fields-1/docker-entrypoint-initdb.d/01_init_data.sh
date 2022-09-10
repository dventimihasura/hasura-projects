#!/bin/bash
set -e

zcat /docker-entrypoint-initdb.d/restaurants.gz | psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -c "\copy ch01.restaurants_staging from stdin (format csv)"
