#!/bin/bash
set -e

curl -s https://davidaventimiglia-hasura.sfo3.cdn.digitaloceanspaces.com/postgres_air.gz | gunzip | psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB"

psql -v ON_ERROR_STOP=1 --username postgres --dbname postgres_air <<-EOSQL
alter table postgres_air.passenger drop constraint pass_frequent_flyer_id_fk;
alter table postgres_air.flight drop constraint arrival_airport_fk;
alter table postgres_air.flight add foreign key (arrival_airport) references postgres_air.airport(airport_code);
create table postgres_air.marker ();
EOSQL

