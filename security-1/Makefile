migrate:
	docker run --env-file .env -v "./metadata:/hasura-metadata:ro" -v "./migrations:/hasura-migrations:ro" hasura/graphql-engine:v2.35.1.cli-migrations-v3
