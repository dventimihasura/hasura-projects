CREATE OR REPLACE VIEW public.asset_with_traits_as_jsonb_view AS
 SELECT asset_with_traits_as_array.id,
    asset_with_traits_as_array.created_at,
    asset_with_traits_as_array.updated_at,
    asset_with_traits_as_array.name,
    array_to_json_immutable(asset_with_traits_as_array.traits)::jsonb AS traits
   FROM asset_with_traits_as_array;
