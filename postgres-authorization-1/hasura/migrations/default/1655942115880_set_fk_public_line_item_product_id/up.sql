alter table "public"."line_item"
  add constraint "line_item_product_id_fkey"
  foreign key ("product_id")
  references "public"."product"
  ("id") on update restrict on delete restrict;
