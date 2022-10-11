drop view if exists sample_graphql_query;

create or replace view sample_graphql_query as
with
  sample as (
    select
      product_id, merchant_id
      from
	product_price
     where
   price < 50
     order by random()
     limit 3
  )
select format('
query MyQuery {
  product_min_prices(
    args: {
      price: 50,
      product_ids: "%s",
      merchant_ids: "%s",
    })
  {
    product_id
    merchant_id
    price
    created_at
    id
    updated_at
    product {
      name
    }
    merchant {
      name
    }
  }
}',
replace(array_agg(format('''%s''', product_id))::text, '''', '\"'),
replace(array_agg(format('''%s''', merchant_id))::text, '''', '\"')) as query
  from
    sample;
