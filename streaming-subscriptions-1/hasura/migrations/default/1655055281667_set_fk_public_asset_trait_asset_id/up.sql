alter table "public"."asset_trait"
  add constraint "asset_trait_asset_id_fkey"
  foreign key ("asset_id")
  references "public"."asset"
  ("id") on update restrict on delete restrict;
