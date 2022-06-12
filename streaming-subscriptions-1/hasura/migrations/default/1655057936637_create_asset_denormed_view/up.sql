create or replace view asset_denormed as
select
  *,
  (select array_to_string(array(select trait.name from asset_trait join trait on trait.id = trait_id where asset_id = asset.id), ',')) as traits
  from asset;
