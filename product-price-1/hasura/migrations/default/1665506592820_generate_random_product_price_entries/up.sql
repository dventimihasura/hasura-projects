insert into product_price (product_id, merchant_id, price)
select
  product.id as product_id,
  merchant.id as merchant_id,
  floor(random()*100) as price
  from
    product, merchant;
