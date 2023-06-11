-- -*- sql-product: postgres; -*-

-- Drop the tables if they exist to restart the example.

drop table if exists first_name;
drop table if exists middle_name;
drop table if exists last_name;
drop table if exists city;
drop table if exists color_name;
drop table if exists job;
drop table if exists company;
drop table if exists license_plate;
drop table if exists profile;

-- Create the seed tables and the profile table.  Create the profile table without WAL logging to speed up inserts.

create table if not exists first_name (data text);
create table if not exists middle_name (data text);
create table if not exists last_name (data text);
create table if not exists city (data text);
create table if not exists color_name (data text);
create table if not exists job (data text);
create table if not exists company (data text);
create table if not exists license_plate (data text);
create unlogged table profile (id uuid primary key default gen_random_uuid(), first_name text, middle_name text, last_name text, city text, color_name text, job text, company text);

-- Add randomly-generated fake sample data to the seed tables.

copy first_name (data) from program 'faker -r=10 -s" " first_name';
copy middle_name (data) from program 'faker -r=10 -s" " first_name';
copy last_name (data) from program 'faker -r=10 -s" " last_name';
copy city (data) from program 'faker -r=10 -s" " city';
copy color_name (data) from program 'faker -r=10 -s" " color_name';
copy job (data) from program 'faker -r=10 -s" " job';
copy company (data) from program 'faker -r=10 -s" " job';
copy license_plate (data) from program 'faker -r=10 -s" " license_plate';

-- Load the bloom extension and add a bloom index to the profile table.

create extension if not exists bloom;

-- Insert all combinations of seed data into the profile table, but include a sensible limit just in case there's a mistake in our reasoning.

insert into profile (first_name, middle_name, last_name, city, color_name, job, company)
select
  first_name.data first_name,
  middle_name.data middle_name,
  last_name.data last_name,
  city.data city,
  color_name.data color_name,
  job.data job,
  company.data company
  from
    first_name,
    middle_name,
    last_name,
    city,
    color_name,
    job,
    company
 limit 100000000;

-- Add the tsm_system_rows extension to make it easier and more efficient to select random rows from tables.

create extension tsm_system_rows;

