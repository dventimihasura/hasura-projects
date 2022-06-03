# Generate an environment file for Docker Compose
cat <<EOF > .env
PGHOST=localhost		# CHANGE ME
PGPORT=6432			# CHANGE ME
PGDATABASE=postgres		# CHANGE ME
PGUSER=postgres			# CHANGE ME
PGPASSWORD=postgrespassword	# CHANGE ME
EOF

# Generate a environment file for Hasura CLI
cat <<EOF > hasura/.env
HASURA_GRAPHQL_ENDPOINT=http://localhost:8080 # CHANGE ME
EOF
