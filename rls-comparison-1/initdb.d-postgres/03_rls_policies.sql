-- -*- sql-product: postgres; -*-

alter table account enable row level security;

alter table "order" enable row level security;

alter table order_detail enable row level security;

create policy account on account using (id = (current_setting('rls.account_id')::uuid));

create policy "order" on "order" using (exists (select 1 from account where account.id = account_id));

create policy order_detail on order_detail using (exists (select 1 from "order" where "order".id = order_id));

create role account_owner;
