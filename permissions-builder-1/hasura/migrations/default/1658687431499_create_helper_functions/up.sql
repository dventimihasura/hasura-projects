create or replace function get_assigned_projects(user_id uuid) returns setof project stable parallel safe
as $$
  select
  project.*
  from project
  where true
  and exists (
    select 1
      from
	assignment
     where true
       and project_id = project.id
       and user_id = $1)
$$ language sql;

create or replace function get_unassigned_projects(user_id uuid) returns setof project stable parallel safe
as $$
  select
  project.*
  from project
  where true
  or not exists (
    select 1
      from
	assignment
     where true
       and project_id = project.id
       and user_id = $1)
$$ language sql;

create or replace function get_assigned_users() returns setof "user" stable parallel safe
as $$
  select
  *
  from "user"
  where true
  and exists (
    select 1
      from
	assignment
     where true
       and user_id = "user".id)
$$ language sql;
