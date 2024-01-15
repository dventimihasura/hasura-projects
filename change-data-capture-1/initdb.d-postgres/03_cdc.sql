-- -*- sql-product: postgres; -*-

select * from pg_create_logical_replication_slot('cdc', 'wal2json', false, false);

-- create or replace view change as
--   select
--     lsn,
--     (xid::text)::bigint as xid,
--     data::jsonb as payload
--     from
--       pg_logical_slot_peek_changes(
-- 	'cdc',
-- 	null,
-- 	null,
-- 	'filter-tables', 'hdb_catalog.*',
-- 	'format-version', '1',
-- 	'include-pk', 'true',
-- 	'include-timestamp', 'true'
--       )
--    where
--      jsonb_array_length(data::jsonb->'change')>0;

create unlogged table change (
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
      'cdc',
      null,
      null,
      'filter-tables', 'cron.*,hdb_catalog.*',
      'format-version', '1',
      'include-pk', 'true',
      'include-timestamp', 'true'
    )
    where jsonb_array_length(data::jsonb->'change')>0
    $sql$);
