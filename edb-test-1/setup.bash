# Generate an environment file for Docker Compose
cat <<EOF > .env
HASURA_GRAPHQL_METADATA_DATABASE_URL=postgres://postgres:postgrespassword@postgres:5432/postgres
PG_DATABASE_URL=postgres://postgres:postgrespassword@postgres:5432/postgres
HASURA_GRAPHQL_ENABLE_CONSOLE="true"
HASURA_GRAPHQL_DEV_MODE="true"
HASURA_GRAPHQL_ENABLED_LOG_TYPES=startup, http-log, webhook-log, websocket-log, query-log
EOF

# Generate a environment file for Hasura CLI
cat <<EOF > hasura/.env
HASURA_GRAPHQL_ENDPOINT=http://localhost:8080
EOF
