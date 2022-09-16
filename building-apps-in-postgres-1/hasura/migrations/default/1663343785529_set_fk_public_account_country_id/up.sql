alter table "public"."account"
  add constraint "account_country_id_fkey"
  foreign key ("country_id")
  references "public"."country"
  ("id") on update restrict on delete restrict;
