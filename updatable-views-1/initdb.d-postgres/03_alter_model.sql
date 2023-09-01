-- -*- sql-product: postgres; -*-

create table account_address (
  id uuid primary key default gen_random_uuid(),
  account_id uuid not null references account (id),
  physical_address text,
  email_address text);

create table product_name (
  id uuid primary key,
  name text);

create table product_price (
  id uuid primary key,
  price integer);

insert into product_name select id, name from product;

insert into product_price select id, price from product;

alter table product drop column name, drop column price;

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

create or replace rule update_product_private as on update
  to product_private
  do instead (
    update product set id = new.id, created_at = new.created_at, updated_at = new.updated_at where id = old.id;
    update product_name set id = new.id, name = new.name where id = old.id;
    update product_price set id = new.id, price = new.price where id = old.id;
  );

create or replace function delete_product_private ()
  returns trigger
  language plpgsql
as
  $plpgsql$
begin
  delete from product_name where id = old.id;
  delete from product_price where id = old.id;
  delete from product where id = old.id;
  return new;
end;
$plpgsql$;

create or replace trigger delete_product_private instead of delete on product_private
  for each row
  execute function delete_product_private();

create or replace function insert_product_private ()
  returns trigger
  language plpgsql
as
  $plpgsql$
  declare
    product_id uuid;
begin
  insert into product default values returning id into product_id;
  insert into product_name values (product_id, new.name);
  insert into product_price values (product_id, new.price);
  new.id = product_id;
  return new;
end;
$plpgsql$;

create or replace trigger insert_product_private instead of insert on product_private
  for each row
  execute function insert_product_private();
