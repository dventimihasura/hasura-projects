init:
	curl -s -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c" "http://localhost:4011/compute-ops/v1beta2/servers?[1-100]" | jq -cr '.items[]' | psql "postgres://postgres:postgrespassword@localhost:5433/postgres" -c "copy core.server (content) from stdin;"
