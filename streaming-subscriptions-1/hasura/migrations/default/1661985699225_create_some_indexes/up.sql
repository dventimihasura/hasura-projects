create index if not exists asset_with_traits_as_array_traits_index on asset_with_traits_as_array using gin((array_to_json_immutable(traits)::jsonb));

create index if not exists asset_with_traits_as_jsonb_table_traits_index on asset_with_traits_as_jsonb_table using gin(traits);
