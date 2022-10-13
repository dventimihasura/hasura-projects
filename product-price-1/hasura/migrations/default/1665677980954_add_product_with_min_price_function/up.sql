CREATE OR REPLACE FUNCTION public.product_with_min_price(product_ids uuid[], merchant_ids uuid[], price integer)
 RETURNS SETOF product
 LANGUAGE sql
 STABLE
AS $function$
  select distinct
  product.id,
  product.created_at,
  product.updated_at,
  product.name,
  product.price,
  product.product_category_id,
  min_prices.price
  from product
  left join (
    select product_id, min(product_price.price) as price
      from product_price
     where true
       and product_id = any($1)
       and merchant_id = any($2)
       and product_price.price < $3
     group by product_id
  ) min_prices on min_prices.product_id = product.id
  where true
  and product_id = any($1)
$function$;
