drop view if exists asset_with_traits_as_array;

create materialized view if not exists asset_with_traits_as_array as
  select
    id,
    created_at,
    updated_at,
    name,
    string_to_array(traits, ',') as traits
    from asset_with_traits;
