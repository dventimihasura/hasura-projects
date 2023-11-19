# Bash is a more useful shell than vanilla sh.

SHELL=bash

# Dynmically generate secrets and passwords.

export HASURA_GRAPHQL_ADMIN_SECRET=$(shell < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c$${1:-32};echo;)
export METADATA_PASSWORD=$(shell < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c$${1:-32};echo;)
export POSTGRES_PASSWORD=$(shell < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c$${1:-32};echo;)

.PHONY: prod-up dev-up up down migrate

.DEFAULT: help

help:				## Display help and usage information.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

prod-up: export HASURA_GRAPHQL_ENABLE_CONSOLE=false
prod-up: export HGEPORT=8081
prod-up: export PGPORT=5433
prod-up: export PROJECT=prod
prod-up: up			## Bring up the prod environment.

dev-up: export HASURA_GRAPHQL_ENABLE_CONSOLE=true
dev-up: export HGEPORT=8082
dev-up: export PGPORT=5434
dev-up: export PROJECT=dev
dev-up: up			## Bring up the dev environment.

prod-down: PROJECT=prod		## Bring down the prod environment.
prod-down: down

dev-down: PROJECT=dev
dev-down: down			## Bring down the prod environment.

up:
	docker compose -p $(PROJECT) up

down:
	docker compose -p $(PROJECT) down

migrate:
	docker run --env-file .env -v "./metadata:/hasura-metadata:ro" -v "./migrations:/hasura-migrations:ro" hasura/graphql-engine:v2.35.1.cli-migrations-v3
