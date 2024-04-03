-- -*- sql-product: postgres; -*-

create extension mongo_fdw;

create server mongodb foreign data wrapper mongo_fdw options (
  address 'subgraph_approval_mongodb',
  port '27017',
  authentication_database 'admin'
);

create user mapping for postgres server mongodb options (
  username 'mongo',
  password 'mongo'
);

create foreign table test_report (
  _id name,
  org text,
  filter text,
  addrs text
) server mongodb options (
  database 'sample_db',
  collection 'sample_collection'
);

create foreign table approval (
  _id name,
  design_id int,
  approved boolean
) server mongodb options (
  database 'sample_db',
  collection 'approvals'
);
