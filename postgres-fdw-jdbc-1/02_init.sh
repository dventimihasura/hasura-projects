#!/usr/bin/bash 

psql <<EOF

-- -*- sql-product: postgres; -*-

create extension if not exists jdbc_fdw;

EOF
