update
account
   set country = (
     select
       case when account.country is not distinct from account.country then country end
       from
	 country_staging
      order by random()
      limit 1
);
