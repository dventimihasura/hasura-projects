with
  n as (
    select
      count (1)
      from ch01.restaurants
  )
update
  ch01.owner
   set
    restaurant_id = random()*n.count + 1
    from n;
