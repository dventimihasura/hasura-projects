alter table "ch01"."owner"
  add constraint "owner_restaurant_id_fkey"
  foreign key ("restaurant_id")
  references "ch01"."restaurants"
  ("id") on update restrict on delete restrict;
