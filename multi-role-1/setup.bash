cat <<EOF > hasura/local1.env
HASURA_GRAPHQL_ENDPOINT=http://localhost:8081
HASURA_GRAPHQL_ADMIN_SECRET=myadminsecretkey
EOF

cat <<EOF > hasura/local2.env
HASURA_GRAPHQL_ENDPOINT=http://localhost:8082
HASURA_GRAPHQL_ADMIN_SECRET=myadminsecretkey
EOF

cat <<EOF > hasura/local3.env
HASURA_GRAPHQL_ENDPOINT=http://localhost:8083
HASURA_GRAPHQL_ADMIN_SECRET=myadminsecretkey
EOF

cat <<EOF > hasura/local4.env
HASURA_GRAPHQL_ENDPOINT=http://localhost:8084
HASURA_GRAPHQL_ADMIN_SECRET=myadminsecretkey
EOF
