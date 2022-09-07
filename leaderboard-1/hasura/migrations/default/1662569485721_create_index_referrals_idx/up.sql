CREATE  INDEX "referrals_idx" on
  "public"."leads_aggregate" using btree ("referrals", "account_id");
