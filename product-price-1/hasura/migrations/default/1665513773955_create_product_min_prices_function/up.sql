create or replace function product_min_prices (product_ids uuid[], merchant_ids uuid[], price int) returns table (product_id uuid, price int) language sql stable as $$
  select product_id, min(product_price.price) as price
  from product_price
  where true
  and product_id = any($1)
  and merchant_id = any($2)
  and product_price.price < $3
  group by product_id
$$;
