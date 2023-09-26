#!/usr/bin/env bash

until psql "postgres://postgres:postgrespassword@postgres1/postgres" -c "select count(1) from posts"
do
    echo "postgres1 not ready"
done

until psql "postgres://postgres:postgrespassword@postgres2/postgres" -c "select count(1) from threads"
do
    echo "postgres2 not ready"
done
