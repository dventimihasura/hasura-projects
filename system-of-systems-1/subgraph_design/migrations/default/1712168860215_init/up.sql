SET check_function_bodies = false;
CREATE SCHEMA api;
COMMENT ON SCHEMA api IS 'public logical data model';
CREATE SCHEMA core;
COMMENT ON SCHEMA core IS 'private physical data model';
CREATE EXTENSION IF NOT EXISTS ltree WITH SCHEMA public;
COMMENT ON EXTENSION ltree IS 'maintains DAG';
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
CREATE FUNCTION api.tgr_design_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  begin
    delete from core.node where core.node.id = old.id;
    return old;
  end;
$$;
COMMENT ON FUNCTION api.tgr_design_delete() IS 'make api.design view support delete';
CREATE FUNCTION api.tgr_design_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  begin
    insert into core.node (id, parent_id) values (new.id, new.parent_id);
    insert into core.design (id, name) values (new.id, new.name);
    return new;
  end;
$$;
COMMENT ON FUNCTION api.tgr_design_insert() IS 'make api.design view support insert';
CREATE FUNCTION api.tgr_part_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  begin
    delete from core.part where core.part.id = old.id;
  end;
$$;
COMMENT ON FUNCTION api.tgr_part_delete() IS 'make api.part view support delete';
CREATE FUNCTION api.tgr_part_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
COMMENT ON FUNCTION api.tgr_part_insert() IS 'make api.part view support insert';
CREATE FUNCTION core.node_detect_cycle() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;
COMMENT ON FUNCTION core.node_detect_cycle() IS 'detect cycles';
CREATE FUNCTION core.node_update_path() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;
COMMENT ON FUNCTION core.node_update_path() IS 'make sure that path always is set to the correct value when a new node is inserted or updated';
CREATE FUNCTION core.node_update_path_of_child() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  begin
    update node set path = new.path || id::text::ltree where parent_id = new.id;
    return new;
  end;
$$;
COMMENT ON FUNCTION core.node_update_path_of_child() IS 'handles the scenario when a group of children is reassigned to a different parent';
CREATE AGGREGATE public.mul(integer) (
    SFUNC = int4mul,
    STYPE = integer
);
COMMENT ON AGGREGATE public.mul(integer) IS 'logic to resolve acceptance tests';
CREATE VIEW api.part AS
SELECT
    NULL::integer AS id,
    NULL::integer AS design_id,
    NULL::uuid AS serial_id,
    NULL::boolean AS accepted;
COMMENT ON VIEW api.part IS 'physical instance for a design';
CREATE TABLE core.design (
    id integer NOT NULL,
    name text DEFAULT ''::text NOT NULL
);
COMMENT ON TABLE core.design IS 'logical design for a part';
CREATE TABLE core.node (
    id integer NOT NULL,
    parent_id integer,
    path public.ltree NOT NULL
);
COMMENT ON TABLE core.node IS 'DAG node';
CREATE VIEW api.design AS
 WITH api_design AS (
         SELECT node.id,
            node.parent_id,
            node.path,
            design.name
           FROM ((core.design
             JOIN core.node ON ((design.id = node.id)))
             LEFT JOIN api.part ON ((part.design_id = design.id)))
          GROUP BY node.id, node.parent_id, node.path, design.name
        )
 SELECT id,
    parent_id,
    path,
    name,
    ( SELECT COALESCE((public.mul((part.accepted)::integer))::boolean, false) AS "coalesce"
           FROM (api_design f2
             JOIN api.part ON ((part.design_id = f2.id)))
          WHERE (false OR (f2.path OPERATOR(public.~) (((f1.path)::text || '.*{1}'::text))::public.lquery) OR (f2.path OPERATOR(public.=) f1.path))) AS accepted
   FROM api_design f1;
COMMENT ON VIEW api.design IS 'logical design for a part';
CREATE VIEW api.node AS
 SELECT id,
    parent_id,
    path
   FROM core.node;
COMMENT ON VIEW api.node IS 'DAG node';
CREATE TABLE core.test (
    id integer NOT NULL,
    part_id integer NOT NULL,
    accepted boolean DEFAULT false NOT NULL
);
COMMENT ON TABLE core.test IS 'occurrence of a test of a part';
CREATE VIEW api.test AS
 SELECT id,
    part_id,
    accepted
   FROM core.test;
COMMENT ON VIEW api.test IS 'occurrence of a test of a part';
CREATE SEQUENCE core.node_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE core.node_id_seq OWNED BY core.node.id;
CREATE TABLE core.part (
    id integer NOT NULL,
    design_id integer NOT NULL,
    serial_id uuid DEFAULT gen_random_uuid() NOT NULL
);
COMMENT ON TABLE core.part IS 'physical instance for a design';
CREATE SEQUENCE core.part_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE core.part_id_seq OWNED BY core.part.id;
CREATE SEQUENCE core.test_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE core.test_id_seq OWNED BY core.test.id;
ALTER TABLE ONLY core.node ALTER COLUMN id SET DEFAULT nextval('core.node_id_seq'::regclass);
ALTER TABLE ONLY core.part ALTER COLUMN id SET DEFAULT nextval('core.part_id_seq'::regclass);
ALTER TABLE ONLY core.test ALTER COLUMN id SET DEFAULT nextval('core.test_id_seq'::regclass);
ALTER TABLE ONLY core.design
    ADD CONSTRAINT design_id_key UNIQUE (id);
ALTER TABLE ONLY core.node
    ADD CONSTRAINT node_pkey PRIMARY KEY (id);
ALTER TABLE ONLY core.part
    ADD CONSTRAINT part_pkey PRIMARY KEY (id);
ALTER TABLE ONLY core.test
    ADD CONSTRAINT test_pkey PRIMARY KEY (id);
CREATE INDEX node_parent_id_idx ON core.node USING btree (parent_id);
CREATE INDEX node_path_idx ON core.node USING gist (path);
CREATE OR REPLACE VIEW api.part AS
 SELECT part.id,
    part.design_id,
    part.serial_id,
    COALESCE((public.mul((test.accepted)::integer))::boolean, false) AS accepted
   FROM (core.part
     LEFT JOIN core.test ON ((test.part_id = part.id)))
  GROUP BY part.id, part.serial_id;
CREATE TRIGGER tgr_design_delete INSTEAD OF DELETE ON api.design FOR EACH ROW EXECUTE FUNCTION api.tgr_design_delete();
COMMENT ON TRIGGER tgr_design_delete ON api.design IS 'make api.design view support delete';
CREATE TRIGGER tgr_design_insert INSTEAD OF INSERT ON api.design FOR EACH ROW EXECUTE FUNCTION api.tgr_design_insert();
COMMENT ON TRIGGER tgr_design_insert ON api.design IS 'make api.design view support insert';
CREATE TRIGGER tgr_part_delete INSTEAD OF DELETE ON api.part FOR EACH ROW EXECUTE FUNCTION api.tgr_part_delete();
COMMENT ON TRIGGER tgr_part_delete ON api.part IS 'make api.part view support delete';
CREATE TRIGGER tgr_part_insert INSTEAD OF INSERT ON api.part FOR EACH ROW EXECUTE FUNCTION api.tgr_part_insert();
COMMENT ON TRIGGER tgr_part_insert ON api.part IS 'make api.part view support insert';
CREATE TRIGGER tgr_node_detect_cycle AFTER INSERT OR UPDATE ON core.node FOR EACH ROW EXECUTE FUNCTION core.node_detect_cycle();
COMMENT ON TRIGGER tgr_node_detect_cycle ON core.node IS 'detect cycles';
CREATE TRIGGER tgr_node_update_path BEFORE INSERT OR UPDATE ON core.node FOR EACH ROW EXECUTE FUNCTION core.node_update_path();
COMMENT ON TRIGGER tgr_node_update_path ON core.node IS 'make sure that path always is set to the correct value when a new node is inserted or updated';
CREATE TRIGGER tgr_node_update_path_of_child AFTER UPDATE ON core.node FOR EACH ROW WHEN ((new.path IS DISTINCT FROM old.path)) EXECUTE FUNCTION core.node_update_path_of_child();
COMMENT ON TRIGGER tgr_node_update_path_of_child ON core.node IS 'handles the scenario when a group of children is reassigned to a different parent';
ALTER TABLE ONLY core.design
    ADD CONSTRAINT design_id_fkey FOREIGN KEY (id) REFERENCES core.node(id) ON DELETE CASCADE;
ALTER TABLE ONLY core.node
    ADD CONSTRAINT node_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES core.node(id) ON UPDATE SET NULL ON DELETE CASCADE;
ALTER TABLE ONLY core.part
    ADD CONSTRAINT part_design_id_fkey FOREIGN KEY (design_id) REFERENCES core.node(id) ON DELETE CASCADE;
ALTER TABLE ONLY core.test
    ADD CONSTRAINT test_part_id_fkey FOREIGN KEY (part_id) REFERENCES core.part(id) ON DELETE CASCADE;
