insert into asset_trait select distinct asset.id, trait.id from asset join equipment on asset.name = equipment.name join trait on trait.name = equipment.trait;
