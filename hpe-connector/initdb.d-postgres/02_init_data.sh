#!/bin/bash

psql -c "copy core.server (content) from stdin;" < /docker-entrypoint-initdb.d/servers.jsonl
psql -c "copy core.alert (content) from stdin;" < /docker-entrypoint-initdb.d/alerts.jsonl
