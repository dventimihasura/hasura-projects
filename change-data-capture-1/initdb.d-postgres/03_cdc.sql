-- -*- sql-product: postgres; -*-

select * from pg_create_logical_replication_slot('test', 'wal2json', false, false);

create table change (
  lsn pg_lsn primary key,
  xid bigint not null,
  payload jsonb
);

create index on change (xid);

create extension pg_cron;

select
  cron.schedule(
    '* * * * *',
    $sql$
    insert into change
    select
    lsn,
    (xid::text)::bigint,
    data::jsonb
    from pg_logical_slot_get_changes(
      'test',
      null,
      null,
      'filter-tables', 'public.change,cron.*,hdb_catalog.*',
      'include-timestamp', 'true'
    )
    where jsonb_array_length(data::jsonb->'change')>0
    $sql$);

-- create or replace view change as
--   select
--     lsn,
--     (xid::text)::bigint as xid,
--     data::jsonb as payload
--     from
--       pg_logical_slot_peek_changes(
-- 	'test',
-- 	null,
-- 	null,
-- 	'include-timestamp', 'true',
-- 	'filter-tables', 'hdb_catalog.*')
--    where
--      jsonb_array_length(data::jsonb->'change')>0;
