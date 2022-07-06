-- -*- sql-product: postgres; -*-

CREATE TABLE accounts (manager text, company text, contact_email text);

ALTER TABLE accounts ENABLE ROW LEVEL SECURITY;

CREATE POLICY account_managers ON accounts TO managers
  USING (manager = current_user);

drop policy if exists account_owner on account;
	      
create policy account_owner on account
  using (string_to_array(current_setting('context.x_hasura_user_id'), ',')::uuid[] @> array[id]);

drop policy if exists invoice_owner on invoice;

create policy invoice_owner on invoice
  using (string_to_array(current_setting('context.x_hasura_user_id'), ',')::uuid[] @> array[account_id]);

drop policy if exists line_item_owner on line_item;

create policy line_item_owner on line_item
  using (invoice_id in (select distinct id from invoice where account_id = current_setting('context.x_hasura_user_id')::uuid));

create policy line_item_owner on line_item
  using (exists (select * from invoice where id = invoice_id and string_to_array(current_setting('context.x_hasura_user_id'), ',')::uuid[] @> array[account_id]));

create index on invoice(account_id);

create index on line_item(invoice_id);


                  id                  |       name       |          created_at           |          updated_at           
--------------------------------------+------------------+-------------------------------+-------------------------------
 1f088dbc-3648-446f-ad92-bb2e2e4b6da9 | Bobine Eaglesham | 2022-06-22 23:57:51.144657+00 | 2022-06-22 23:57:51.144657+00
 3d90520c-3d73-4dd8-b524-79f7a549b976 | Kylie Domaschke  | 2022-06-22 23:57:51.144657+00 | 2022-06-22 23:57:51.144657+00
 1859b5f4-f490-47db-bc00-12bd2d8249d6 | Findley Caris    | 2022-06-22 23:57:51.144657+00 | 2022-06-22 23:57:51.144657+00
 f56a8481-4924-4606-a801-e129d6ff16db | Richmound Monsey | 2022-06-22 23:57:51.144657+00 | 2022-06-22 23:57:51.144657+00
 6b6e6eb9-9c8a-4962-9cc5-805bc65250fb | Roland Rehn      | 2022-06-22 23:57:51.144657+00 | 2022-06-22 23:57:51.144657+00
