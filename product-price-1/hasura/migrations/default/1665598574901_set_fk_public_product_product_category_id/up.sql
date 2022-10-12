alter table "public"."product"
  add constraint "product_product_category_id_fkey"
  foreign key ("product_category_id")
  references "public"."product_category"
  ("id") on update restrict on delete restrict;
