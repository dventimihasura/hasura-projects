create or replace view asset_denormed_2 as
  select
    *,
    (select array_to_json(array(select trait.name from asset_trait join trait on trait.id = trait_id where asset_id = asset.id))) as traits
    from asset;
