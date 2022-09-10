-- -*- sql-product: postgres; -*-

CREATE EXTENSION postgis;

CREATE EXTENSION postgis_raster;

CREATE EXTENSION postgis_sfcgal;

CREATE EXTENSION fuzzystrmatch; --needed for postgis_tiger_geocoder

--optional used by postgis_tiger_geocoder, or can be used standalone

CREATE EXTENSION address_standardizer;

CREATE EXTENSION address_standardizer_data_us;

CREATE EXTENSION postgis_tiger_geocoder;

CREATE EXTENSION postgis_topology;

CREATE SCHEMA ch01;

-- CREATE TABLE ch01.lu_franchises (id text PRIMARY KEY
--  , franchise varchar(30));
 
-- INSERT INTO ch01.lu_franchises(id, franchise)
-- VALUES 
--   ('BKG', 'Burger King'), ('CJR', 'Carl''s Jr'),
--   ('HDE', 'Hardee'), ('INO', 'In-N-Out'), 
--   ('JIB', 'Jack in the Box'), ('KFC', 'Kentucky Fried Chicken'),
--   ('MCD', 'McDonald'), ('PZH', 'Pizza Hut'),
--   ('TCB', 'Taco Bell'), ('WDY', 'Wendys');

CREATE TABLE ch01.restaurants
(
  id serial primary key,
  franchise text NOT NULL,
  geom geometry(point,2163)
);

CREATE INDEX ix_code_restaurants_geom 
  ON ch01.restaurants USING gist(geom);

-- ALTER TABLE ch01.restaurants 
--   ADD CONSTRAINT fk_restaurants_lu_franchises
--   FOREIGN KEY (franchise) 
--   REFERENCES ch01.lu_franchises (id)
--   ON UPDATE CASCADE ON DELETE RESTRICT;

-- CREATE INDEX fi_restaurants_franchises 
--   ON ch01.restaurants (franchise);

-- CREATE TABLE ch01.highways
-- (
--   gid integer NOT NULL,
--   feature character varying(80),
--   name character varying(120),
--   state character varying(2),
--   geom geometry(multilinestring,2163),
--   CONSTRAINT pk_highways PRIMARY KEY (gid)
-- );
 
-- CREATE INDEX ix_highways 
--   ON ch01.highways USING gist(geom);

CREATE TABLE ch01.restaurants_staging (
  franchise text, lat double precision, lon double precision);

-- \copy ch01.restaurants_staging FROM '/data/restaurants.csv' DELIMITER as ',';

-- \copy ch01.restaurants_staging from stdin (format csv)

INSERT INTO ch01.restaurants (franchise, geom)
SELECT franchise
 , ST_Transform(
   ST_SetSRID(ST_Point(lon , lat), 4326)
   , 2163) As geom
FROM ch01.restaurants_staging;

