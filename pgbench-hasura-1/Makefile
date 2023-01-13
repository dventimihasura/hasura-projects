SHELL=bash

.PHONY: all

all: ab.log pgbench.log

ab.log: id.log
	echo "##################"
	echo "# ab.log" >> $@
	pgbench -i -ItGpf -s100 -q
	docker run -d --net=host -e HASURA_GRAPHQL_DATABASE_URL=postgres://$${PGUSER}:$${PGPASSWORD}@$${PGHOST}:$${PGPORT}/$${PGDATABASE} -e HASURA_GRAPHQL_ENABLE_CONSOLE=true hasura/graphql-engine:latest
	sleep 10
	curl -s -H 'Content-type: application/json' --data-binary @config.json "http://127.0.0.1:8080/v1/metadata" | jq -r '.'
	ab -c10 -t10 -l -H "Accept: application/json" "http://127.0.0.1:8080/api/rest/abalance/10" >> $@
	docker stop $$(docker ps -a -q)
	docker rm $$(docker ps -a -q)

pgbench.log: id.log
	echo "##################"
	echo "# pgbench.log" >> $@
	pgbench -i -ItGpf -s100 -q
	pgbench -n -S -T10 -j10 -c10 -Msimple >> $@
	pgbench -n -S -T10 -j10 -c10 -Mextended >> $@
	pgbench -n -S -T10 -j10 -c10 -Mprepared >> $@
