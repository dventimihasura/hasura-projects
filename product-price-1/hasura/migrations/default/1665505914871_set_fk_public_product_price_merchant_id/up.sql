alter table "public"."product_price"
  add constraint "product_price_merchant_id_fkey"
  foreign key ("merchant_id")
  references "public"."merchant"
  ("id") on update restrict on delete restrict;
