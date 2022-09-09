CREATE INDEX ix_code_restaurants_geom 
  ON ch01.restaurants USING gist(geom);
