-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- create or replace view asset_with_traits_as_jsonb_view as
--   select
--     id,
--     created_at,
--     updated_at,
--     name,
--     array_to_json(traits) as traits
--     from asset_with_traits_as_array;
