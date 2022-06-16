alter table "public"."misc"
  add constraint "misc_account_id_fkey"
  foreign key ("account_id")
  references "public"."account"
  ("id") on update restrict on delete restrict;
