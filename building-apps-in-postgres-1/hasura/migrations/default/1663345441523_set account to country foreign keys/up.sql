update
  account
   set
     country_id = country.id
     from country
 where true
   and country.name = account.country;
