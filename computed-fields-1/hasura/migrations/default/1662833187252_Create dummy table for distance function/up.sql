drop table if exists ch01.restaurants_near cascade;

create table if not exists ch01.restaurants_near (like ch01.restaurants);

alter table ch01.restaurants_near add column distance double precision;
