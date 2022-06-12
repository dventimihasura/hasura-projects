alter table "public"."asset_trait"
  add constraint "asset_trait_trait_id_fkey"
  foreign key ("trait_id")
  references "public"."trait"
  ("id") on update restrict on delete restrict;
