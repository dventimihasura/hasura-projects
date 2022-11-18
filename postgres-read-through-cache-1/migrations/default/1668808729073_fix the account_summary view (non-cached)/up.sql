create or replace view account_summary as
select
  account.id,
  sum(units*price)
  from origin.account
       left join origin."order" on "order".account_id = account.id
       left join origin.order_detail on order_detail.order_id = "order".id
       left join origin.product on product.id = order_detail.product_id
 group by account.id;
