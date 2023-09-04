-- -*- sql-product: postgres; -*-

-- Split the product table out into separate tables for name and
-- price, product_name and product_price.  The id uuid primary key is
-- not null of course (by virtue of being a primary key) but we don't
-- give it a default value because we want it to be identical to the
-- related product.id value.  After we're done, the product table will
-- only have "housekeeping" fields id, created_at, and updated_at.

create table product_name (
  id uuid primary key,
  name text);

create table product_price (
  id uuid primary key,
  price integer);

insert into product_name select id, name from product;

insert into product_price select id, price from product;

alter table product drop column name, drop column price;

-- Now create a view product_private that joins these three tables
-- back together.  Note that at this point, the product table doesn't
-- bring much since the name and price are in other tables.  It does
-- bring the created_at and update_at fields, though.

create or replace view product_private as
  select
    product.id,
    created_at,
    updated_at,
    product_name.name,
    product_price.price
    from
      product
      join product_name on product_name.id = product.id
      join product_price on product_price.id = product.id;

-- We can make a complicated view updatable that isn't automatically
-- updatable by using either 'do instead' rules or triggers.  Rules
-- are simpler and easier to use, though they probably can't be used
-- in cases where you need to capture a value, like in an insert on a
-- table that has columns with default values.  Note that you can have
-- multiple statements in the rule, provided you enclose them in
-- parentheses.  Note also the update on the product table.  That
-- occurs for two reasons.  First, it's possible (if unlikely and
-- arguably a bad practice) that the id, created_at, or updated_at
-- fields could be manually updated.  We have to account for that.
-- Second, even when they're not being updated (as they shouldn't be),
-- we still need to do a trivial update on the product table in order
-- for the trigger on the updated_at field to fire.

-- NOTE:  The update rule below is now commented out because we have
-- to abandon the rule approach for now.  The reason is that there are
-- too many restrictions on rules, which interfere with the way that
-- Hasura writes statements.  First, Hasura writes update statements
-- with returning clauses.  This isn't a severe restriction because
-- PostgreSQL DO INSTEAD update rules suppor returning clauses, though
-- it does make the rule more complicated. More severe, however, is
-- that multi-statement DO INSTEAD update rules cannot be used in
-- update statements that use a Common Table Expression (CTE), but
-- that's precisely how Hasura writes its update statements.
-- Consequently, we have to switch from using a rule to using a
-- trigger.  See below.

-- create or replace rule update_product_private as on update
--   to product_private
--   do instead (
--     update product set id = new.id, created_at = new.created_at, updated_at = new.updated_at where id = old.id;
--     update product_name set id = new.id, name = new.name where id = old.id;
--     update product_price set id = new.id, price = new.price where id = old.id;
--   );

-- It should be possible to use a rule for the delete statement as
-- well.  However, I encountered unpredictable behavior that I cannot
-- explain at the moment, so I have to avoid the use of a rule in
-- favor of a trigger.

create or replace function delete_product_private ()
  returns trigger
  language plpgsql
as
  $plpgsql$			--define code block delimiters using dollar signs ($)
begin
  delete from product_name where id = old.id;
  delete from product_price where id = old.id;
  delete from product where id = old.id;
  return new;			--triggers must return old or new
end;
$plpgsql$;			--end code block

create or replace trigger delete_product_private instead of delete on product_private
  for each row
  execute function delete_product_private();

-- For the insert statement, a trigger function probably is necessary
-- in order to capture the generated value of the primary key for the
-- product table.  Trigger functions must be functions (they cannot be
-- procedures) and they must be written in a procedural language like
-- PL/pgSQL.

create or replace function insert_product_private ()
  returns trigger
  language plpgsql
as
  $plpgsql$
  declare
    product_id uuid;
begin
  insert into product default values returning id into product_id; --we have no actual values to insert into product so just insert the default values so that we can get a generated id and capture it into the product_id variable
  insert into product_name values (product_id, new.name);
  insert into product_price values (product_id, new.price);
  new.id = product_id;		--set the captured product_id back onto the new record so that we return the generated primary key from the function
  return new;
end;
$plpgsql$;

create or replace trigger insert_product_private instead of insert on product_private
  for each row
  execute function insert_product_private();

-- Now write a DO INSTEAD update trigger function just as we did for
-- the insert case

create or replace function update_product_private ()
  returns trigger
  language plpgsql
as
  $plpgsql$
begin
  update product set id = new.id, created_at = new.created_at, updated_at = new.updated_at where id = old.id;
  update product_name set id = new.id, name = new.name where id = old.id;
  update product_price set id = new.id, price = new.price where id = old.id;
  return new;
end;
$plpgsql$;

create or replace trigger update_product_private instead of update on product_private
  for each row
  execute function update_product_private();

-- This is pretty much unrelated, but we might as well fix up the
-- product_search and product_search_slow functions to return not
-- product, but rather product_private instead.

drop function product_search;

create or replace function product_search(search text)
  returns setof product_private as $$
  select product_private.*
  from product_private
  where
  name ilike ('%' || search || '%')
$$ language sql stable;

drop function product_search_slow;

create or replace function product_search_slow(search text, wait real)
  returns setof product_private as $$
  select product_private.*
  from product_private, pg_sleep(wait)
  where
  name ilike ('%' || search || '%')
$$ language sql stable;
