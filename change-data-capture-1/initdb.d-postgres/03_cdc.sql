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
  lsn pg_lsn not null,
  xid bigint primary key,
  payload jsonb
);

create index on change (lsn);

create or replace function cdc ()
  returns setof change
  language sql
  volatile as $sql$
  insert into change
  select
  lsn,
  (xid::text)::bigint,
  data::jsonb
  from pg_logical_slot_get_changes(
    'cdc',
    null,
    null,
    'filter-tables', 'public.change,cron.*,hdb_catalog.*,faker.*',
    'format-version', '1',
    'include-pk', 'true',
    'include-timestamp', 'true'
  )
  where jsonb_array_length(data::jsonb->'change')>0;
  select pg_replication_slot_advance(
    'cdc',
    confirmed_flush_lsn
  ) from pg_replication_slots;
  select (null, null, null)::change;
  $sql$;

-- create extension pg_cron;

-- select
--   cron.schedule(
--     '* * * * *',
--     $sql$
--     insert into change
--     select
--     lsn,
--     (xid::text)::bigint,
--     data::jsonb
--     from pg_logical_slot_get_changes(
--       'cdc',
--       null,
--       null,
--       'filter-tables', 'public.change,cron.*,hdb_catalog.*,faker.*',
--       'format-version', '1',
--       'include-pk', 'true',
--       'include-timestamp', 'true'
--     )
--     where jsonb_array_length(data::jsonb->'change')>0;
--     select pg_replication_slot_advance(
--       'cdc',
--       confirmed_flush_lsn
--     ) from pg_replication_slots;
--     $sql$);
