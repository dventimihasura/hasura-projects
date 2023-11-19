#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 <<-EOF
create role ${METADATA_USER} nosuperuser nocreatedb nocreaterole noinherit login noreplication nobypassrls connection limit 10 password '${METADATA_PASSWORD}' valid until '$(date -d '1 week hence' --rfc-3339=date -u)';
create role ${DATA_DEFAULT_USER} nosuperuser nocreatedb nocreaterole noinherit login noreplication nobypassrls connection limit 10 password '${DATA_DEFAULT_PASSWORD}' valid until '$(date -d '1 week hence' --rfc-3339=date -u)';
create role ${DATA_ADMIN_USER} nosuperuser nocreatedb nocreaterole noinherit login noreplication nobypassrls connection limit 10 password '${DATA_ADMIN_PASSWORD}' valid until '$(date -d '1 week hence' --rfc-3339=date -u)';
create database metadata connection limit = 10;
create database defaultdb connection limit = 10;
grant all privileges on database metadata to ${METADATA_USER};
grant all privileges on database defaultdb to ${DATA_DEFAULT_USER};
EOF
