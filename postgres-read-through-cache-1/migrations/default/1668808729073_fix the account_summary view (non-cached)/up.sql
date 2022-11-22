create or replace view account_summary as
select
  account.id,
  sum(units*price)
  from origin_1.account
       left join origin_1."invoice" on "invoice".account_id = account.id
       left join origin_1.line_item on line_item.invoice_id = "invoice".id
       left join origin_1.product on product.id = line_item.product_id
 group by account.id;
