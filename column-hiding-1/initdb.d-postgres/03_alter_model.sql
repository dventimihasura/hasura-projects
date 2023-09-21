-- -*- sql-product: postgres; -*-

alter table account add column if not exists email text generated always as (lower(replace(name, ' ', '')) || '@foo.com') stored;

create or replace view account_limited as select id, name from account;				 
