-- -*- sql-product: postgres; -*-

create schema if not exists ddl_monitor;

create table if not exists ddl_monitor.ddl_command (
  classid oid,
  objid oid,
  objsubid integer,
  command_tag text,
  object_type text,
  schema_name text,
  object_identity text,
  in_extension boolean,
  command text
);

create table if not exists ddl_monitor.dropped_object (
  classid oid,
  objid oid,
  objsubid integer,
  original boolean,
  normal boolean,
  is_temporary boolean,
  object_type text,
  schema_name text,
  object_name text,
  object_identity text,
  address_names text[],
  address_args text[]
);

create or replace function ddl_monitor.notice_ddl_command_end_event () returns event_trigger as $$
  declare r record;
  begin
    for r in select * from pg_event_trigger_ddl_commands() loop
      if r.schema_name not in ('ddl_monitor', 'hdb_catalog') then
	insert into ddl_monitor.ddl_command (
	  classid,
	  objid,
	  objsubid,
	  command_tag,
	  object_type,
	  schema_name,
	  object_identity,
	  in_extension,
	  command
	)
	values (
	  r.classid,
	  r.objid,
	  r.objsubid,
	  r.command_tag,
	  r.object_type,
	  r.schema_name,
	  r.object_identity,
	  r.in_extension,
	  current_query()
	);
      end if;
    end loop;
  end;
$$
language plpgsql;

create or replace function ddl_monitor.notice_sql_drop_event () returns event_trigger as $$
  declare r record;
  begin
    for r in select * from pg_event_trigger_dropped_objects() loop
      if r.schema_name not in ('ddl_monitor') then
	insert into ddl_monitor.dropped_object (
	  classid,
	  objid,
	  objsubid,
	  original,
	  normal,
	  is_temporary,
	  object_type,
	  schema_name,
	  object_name,
	  object_identity,
	  address_names,
	  address_args
	)
	values (
	  r.classid,
	  r.objid,
	  r.objsubid,
	  r.original,
	  r.normal,
	  r.is_temporary,
	  r.object_type,
	  r.schema_name,
	  r.object_name,
	  r.object_identity,
	  r.address_names,
	  r.address_args
	);
      end if;
    end loop;
  end;
$$
language plpgsql;

create event trigger ddl_monitor_notice_ddl_command_end
  on ddl_command_end
  execute procedure ddl_monitor.notice_ddl_command_end_event();

create event trigger ddl_monitor_notice_sql_drop
  on sql_drop
  execute procedure ddl_monitor.notice_sql_drop_event();
