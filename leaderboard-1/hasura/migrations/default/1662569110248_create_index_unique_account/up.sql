CREATE UNIQUE INDEX "unique_account" on
  "public"."leads_aggregate" using btree ("account_id");
