-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- alter table "public"."misc" add column "id" serial
--  not null unique;

alter table "public"."misc" drop column "id";

