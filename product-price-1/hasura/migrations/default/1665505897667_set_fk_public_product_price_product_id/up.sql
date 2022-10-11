alter table "public"."product_price"
  add constraint "product_price_product_id_fkey"
  foreign key ("product_id")
  references "public"."product"
  ("id") on update restrict on delete restrict;
