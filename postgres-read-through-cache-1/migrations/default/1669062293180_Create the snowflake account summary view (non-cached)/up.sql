create or replace view snowflake_account_summary as
select
  account.id,
  sum(units*price)
  from origin_2.account
       join origin_2."invoice" on "invoice".account_id = account.id
       join origin_2.line_item on line_item.invoice_id = "invoice".id
       join origin_2.product on product.id = line_item.product_id
 group by account.id;
