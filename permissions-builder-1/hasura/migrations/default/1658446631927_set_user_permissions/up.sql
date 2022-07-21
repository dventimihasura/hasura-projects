with
  "user" as (
    select
      "user".id,
      (random()*9 + 1)::int items
      from "user")
    insert into user_permission (user_id, permission_id)
select
  user_id,
  permission_id
  from (
    select
      "user".id user_id,
      permission.id permission_id,
      row_number() over (partition by "user".id) ordinal
      from "user", permission) user_item
       join "user" on "user".id = user_item.user_id
	   and user_item.ordinal <= "user".items;
