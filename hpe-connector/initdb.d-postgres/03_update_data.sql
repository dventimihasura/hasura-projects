-- -*- sql-product: postgres; -*-

update core.alert
   set server_id = (
     select
       id
       from
	 core.server
      order by random()+alert.id limit 1);
