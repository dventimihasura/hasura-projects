update
  product
   set
     product_category_id = (
       select
	 id
	 from
	   product_category
	where
	  product.id is not null
	order by random()
		 limit 1);
