drop view if exists asset_with_traits_as_jsonb_view cascade;

create or replace view asset_with_traits_as_jsonb_view as
  select
    id,
    created_at,
    updated_at,
    name,
    array_to_json(traits)::jsonb as traits
    from asset_with_traits_as_array;
