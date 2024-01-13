-- -*- sql-product: postgres; -*-

select * from pg_create_logical_replication_slot('test', 'wal2json', false, false);

create or replace view change as
  select
    lsn,
    xid,
    data::jsonb as payload
    from
      pg_logical_slot_peek_changes(
	'test',
	null,
	null,
	'include-timestamp', 'true',
	'filter-tables', 'hdb_catalog.*')
   where
     jsonb_array_length(data::jsonb->'change')>0;
