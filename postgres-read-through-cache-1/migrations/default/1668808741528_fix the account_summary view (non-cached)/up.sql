create or replace view account_summary as
select
  account.id,
  sum(units*price)
  from origin.account
       left join origin."invoice" on "invoice".account_id = account.id
       left join origin.line_item on line_item.invoice_id = "invoice".id
       left join origin.product on product.id = line_item.product_id
 group by account.id;
