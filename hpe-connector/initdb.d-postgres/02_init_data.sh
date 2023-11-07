# #!/bin/bash

# curl -s -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c" "http://prism:4010/compute-ops/v1beta2/servers?[1-100]" | jq -cr '.items[]' | psql "postgres://postgres:postgrespassword@localhost:5432/postgres" -c "copy core.server (content) from stdin;"
