CREATE TABLE ch01.restaurants
(
  id serial primary key,
  franchise char(3) NOT NULL,
  geom geometry(point,2163)
);
