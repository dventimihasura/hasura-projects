-- -*- sql-product: postgres; -*-

select
  create_schema(i)
  from (
    select
      generate_series(1, :N_SCHEMA) i) foo;

select
  create_table(schema_name, 10, i)
  from (
    select
      schema_name,
      generate_series(1, :N_TABLES) i
      from
	information_schema.schemata
     where schema_name like 'test_%') foo;



