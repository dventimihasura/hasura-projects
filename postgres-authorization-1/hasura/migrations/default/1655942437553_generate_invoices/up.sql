begin;
with
  account as (
    select
      account.id,
      name,
      (random()*5)::int orders
      from account)
insert into invoice (account_id)
select
  account_id
    from (
      select
	account.id account_id,
	row_number() over (partition by account.id order by account.name) ordinal
	from account, generate_series(1, 5)) orders
	 join account on account.id = orders.account_id
		and orders.ordinal <= account.orders;


with
  invoice as (
    select
      invoice.id,
      (random()*9 + 1)::int items
      from invoice)
insert into line_item (invoice_id, product_id, units)
select
  invoice_id,
  product_id,
  (random()*9 + 1)::int units
    from (
      select
	invoice.id invoice_id,
	product.id product_id,
	row_number() over (partition by invoice.id) ordinal
	from invoice, product) user_item
	 join invoice on invoice.id = user_item.invoice_id
	     and user_item.ordinal <= invoice.items;
commit;
