alter table "ch01"."owner" alter column "restaurants_id" drop not null;
alter table "ch01"."owner" add column "restaurants_id" uuid;
