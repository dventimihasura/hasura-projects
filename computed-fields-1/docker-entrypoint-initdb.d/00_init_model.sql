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

CREATE TABLE ch01.restaurants
(
  id serial primary key,
  franchise text NOT NULL,
  geom geometry(point,2163)
);

CREATE INDEX ix_code_restaurants_geom 
  ON ch01.restaurants USING gist(geom);

CREATE TABLE ch01.restaurants_staging (
  franchise text, lat double precision, lon double precision);
