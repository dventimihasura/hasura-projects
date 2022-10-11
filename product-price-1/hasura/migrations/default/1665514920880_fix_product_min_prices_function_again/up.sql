drop function if exists product_min_prices (uuid[], uuid[], int);

create or replace function product_min_prices (product_ids uuid[], merchant_ids uuid[], price int)
  returns setof product_price
  language sql stable as $$
  select product_price.*
  from
  (
    select product_id, min(product_price.price) as price
      from product_price
     where true
       and product_id = any($1)
       and merchant_id = any($2)
       and product_price.price < $3
     group by product_id
  ) min_prices
  join product_price on product_price.product_id = min_prices.product_id and product_price.price = min_prices.price
$$;
