alter table "public"."leads_aggregate" add constraint "referrals_positive" check (referrals>=0);
