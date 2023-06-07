-- -*- sql-product: postgres; -*-

select
  create_schema(i)
  from (
    select
      generate_series(1, 1) i) foo;

select
  create_table(schema_name, 10, i)
  from (
    select
      schema_name,
      generate_series(1, 10) i
      from
	information_schema.schemata
     where schema_name like 'test_%') foo;

select generate_series(1, 3);

create table idx (i int);

insert into idx select generate_series(1, 3);

select i from idx;

select create_permissions(format('role_%s', x)) from generate_series(11, 15) x;

