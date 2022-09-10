drop function if exists ch01.restaurants_near cascade;

drop function if exists ch01.restaurants_near_to cascade;

create or replace function ch01.restaurants_near_to (lat double precision, lon double precision)
  returns setof ch01.restaurants_near as $$
  select
  restaurants.*,
  st_distance(st_transform(geom, 3857), st_transform(st_setsrid(st_makepoint(lat, lon), 4326), 3857)) as distance
  from
  ch01.restaurants
$$ language sql stable;
