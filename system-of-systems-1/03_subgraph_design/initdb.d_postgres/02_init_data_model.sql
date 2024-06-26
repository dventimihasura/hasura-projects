-- -*- sql-product: postgres; -*-

-- Drop foundational components: schema, extensions, aggregates.

drop schema if exists core cascade;
drop schema if exists api cascade;
drop extension if exists ltree cascade;
drop aggregate if exists mul (int);

-- Create foundational components: schema, extensions, aggregates.

create schema core;
comment on schema core is 'private physical data model';

create schema api;
comment on schema api is 'public logical data model';

create extension ltree;
comment on extension ltree is 'maintains DAG';

create aggregate mul (int) (sfunc = int4mul, stype=int);
comment on aggregate mul (int) is 'logic to resolve acceptance tests';

-- Create private physical data model.

create table core.node (
  id serial primary key,
  parent_id integer references core.node on delete cascade on update set null,
  path ltree not null
);
comment on table core.node is 'DAG node';

create index on core.node (parent_id);
create index on core.node using gist (path);

create function core.node_update_path () returns trigger as $$
  declare
    new_path ltree;
    path ltree;
  begin
    if new.parent_id is null then
      new.path = new.id::text::ltree;
    elsif lower(tg_op) = lower('insert') or old.parent_id is null or old.parent_id != new.parent_id then
      select node.path from core.node where id = new.parent_id into new_path;
      if new_path is null then
	raise exception 'invalid parent_id %', new.parent_id;
      end if;
      new.path = new_path || new.id::text::ltree;
    end if;
    return new;
  end;
$$ language plpgsql;
comment on function core.node_update_path () is 'make sure that path always is set to the correct value when a new node is inserted or updated';

create function core.node_update_path_of_child () returns trigger as $$
  begin
    update node set path = new.path || id::text::ltree where parent_id = new.id;
    return new;
  end;
$$ language plpgsql;
comment on function core.node_update_path_of_child () is 'handles the scenario when a group of children is reassigned to a different parent';

create trigger tgr_node_update_path
  before insert or update on core.node
  for each row execute procedure core.node_update_path();
comment on trigger tgr_node_update_path on core.node is 'make sure that path always is set to the correct value when a new node is inserted or updated';

create trigger tgr_node_update_path_of_child
  after update on core.node
  for each row when (new.path is distinct from old.path)
  execute procedure core.node_update_path_of_child();
comment on trigger tgr_node_update_path_of_child on core.node is 'handles the scenario when a group of children is reassigned to a different parent';

create function core.node_detect_cycle () returns trigger as $$
  begin
    if new.parent_id is not null and exists (
      with recursive list_parents (parent) as (
	select s.parent_id
	  from core.node as s
	 where s.id = new.parent_id
	 union
	select s.parent_id
	  from core.node as s
	       inner join list_parents lr on lr.parent = s.id
      )
      select * from list_parents where list_parents.parent = new.id limit 1
    ) then
      raise exception 'invalid cycle detected in parent/child relationship in nodes';
    else
      return new;
    end if;
  end;
$$ language plpgsql;
comment on function core.node_detect_cycle () is 'detect cycles';

create trigger tgr_node_detect_cycle
  after insert or update on core.node
  for each row execute procedure core.node_detect_cycle();
comment on trigger tgr_node_detect_cycle on core.node is 'detect cycles';

create table core.design (
  id integer not null unique references core.node on delete cascade,
  name text not null default ''
);
comment on table core.design is 'logical design for a part';

create table core.part (
  id serial primary key,
  design_id int not null references core.node on delete cascade,
  serial_id uuid not null default gen_random_uuid()
);
comment on table core.part is 'physical instance for a design';

create table core.test (
  id serial primary key,
  part_id int not null references core.part on delete cascade,
  accepted boolean not null default false
);
comment on table core.test is 'occurrence of a test of a part';

-- Create public logical data model.

create view api.node as
  select * from core.node;
comment on view api.node is 'DAG node';

create view api.part as
  select
    part.id,
    part.design_id,
    part.serial_id,
    coalesce(mul(test.accepted::int)::boolean, false) accepted
    from
      core.part
      left join core.test on part_id = part.id
   group by part.id, part.serial_id;
comment on view api.part is 'physical instance for a design';

create function api.tgr_part_delete () returns trigger language plpgsql as $$
  begin
    delete from core.part where core.part.id = old.id;
  end;
$$;
comment on function api.tgr_part_delete () is 'make api.part view support delete';

create trigger tgr_part_delete
  instead of delete on api.part
  for each row
  execute function api.tgr_part_delete();
comment on trigger tgr_part_delete on api.part is 'make api.part view support delete';

create function api.tgr_part_insert () returns trigger language plpgsql as $$
  declare
    new_id int;
    new_serial_id uuid;
  begin
    select coalesce(new.id, nextval('core.part_id_seq')) into new_id;
    select coalesce(new.serial_id, gen_random_uuid()) into new_serial_id;
    insert into core.part (id, serial_id, design_id) values (new_id, new_serial_id, new.design_id);
    return new;
  end;
$$;
comment on function api.tgr_part_insert () is 'make api.part view support insert';

create trigger tgr_part_insert
  instead of insert on api.part
  for each row
  execute function api.tgr_part_insert();
comment on trigger tgr_part_insert on api.part is 'make api.part view support insert';

create or replace view api.design as
  with
  api_design as (
    select
      node.id,
      node.parent_id,
      node.path,
      design.name
      from
	core.design
	join core.node on design.id = node.id
	left join api.part on part.design_id = design.id
     group by node.id, node.parent_id, node.path, design.name)
  select
    *,
    (
      select
	coalesce(mul(accepted::int)::boolean, false)
	from
	  api_design f2
	  join api.part on api.part.design_id = f2.id
       where (
	 false
	 or f2.path ~ (f1.path::text || '.*{1}')::lquery
	 or f2.path = f1.path)) as accepted
    from
      api_design f1;
comment on view api.design is 'logical design for a part';

create function api.tgr_design_delete () returns trigger language plpgsql as $$
  begin
    delete from core.node where core.node.id = old.id;
    return old;
  end;
$$;
comment on function api.tgr_design_delete () is 'make api.design view support delete';

create trigger tgr_design_delete
  instead of delete on api.design
  for each row
  execute function api.tgr_design_delete();
comment on trigger tgr_design_delete on api.design is 'make api.design view support delete';

create function api.tgr_design_insert () returns trigger language plpgsql as $$
  begin
    insert into core.node (id, parent_id) values (new.id, new.parent_id);
    insert into core.design (id, name) values (new.id, new.name);
    return new;
  end;
$$;
comment on function api.tgr_design_insert () is 'make api.design view support insert';

create trigger tgr_design_insert
  instead of insert on api.design
  for each row
  execute function api.tgr_design_insert();
comment on trigger tgr_design_insert on api.design is 'make api.design view support insert';

create view api.test as
  select
    id,
    part_id,
    accepted
    from
      core.test;
comment on view api.test is 'occurrence of a test of a part';

-- indexes

create index on core.design (name, id);

create index on core.node (id, parent_id);

create index on core.part (design_id);

create index on core.test (part_id);
