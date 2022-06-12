alter table "public"."event"
  add constraint "event_asset_id_fkey"
  foreign key ("asset_id")
  references "public"."asset"
  ("id") on update restrict on delete restrict;
