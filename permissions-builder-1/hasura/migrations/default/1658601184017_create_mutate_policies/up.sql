create policy delete_assigned_projects on project for delete using (
  exists (
    select
      1
      from
	user_permission
	join permission
	    on true
	    and user_permission.permission_id = permission.id
	    and user_id = (current_setting('hasura.user')::jsonb->>'x-hasura-user-id')::uuid
	    and permission.name = 'edit_assigned_projects'
  )
  and
  exists (
    select
      1
      from
	assignment
     where true
       and project_id = id
       and user_id = (current_setting('hasura.user')::jsonb->>'x-hasura-user-id')::uuid
  )
);

create policy edit_all_projects on project for update with check (
  exists (
    select
      1
      from
	user_permission
	join permission
	    on true
	    and user_permission.permission_id = permission.id
	    and user_id = (current_setting('hasura.user')::jsonb->>'x-hasura-user-id')::uuid
	    and permission.name = 'edit_all_projects'
  )
);

create policy edit_all_timesheets on timesheet for update with check (
  exists (
    select
      1
      from
	user_permission
	join permission
	    on true
	    and user_permission.permission_id = permission.id
	    and user_id = (current_setting('hasura.user')::jsonb->>'x-hasura-user-id')::uuid
	    and permission.name = 'edit_all_timesheets'
  )
);

create policy edit_assigned_projects on project for update with check (
  exists (
    select
      1
      from
	user_permission
	join permission
	    on true
	    and user_permission.permission_id = permission.id
	    and user_id = (current_setting('hasura.user')::jsonb->>'x-hasura-user-id')::uuid
	    and permission.name = 'edit_assigned_projects'
  )
  and
  exists (
    select
      1
      from
	assignment
     where true
       and project_id = id
       and user_id = (current_setting('hasura.user')::jsonb->>'x-hasura-user-id')::uuid
  )
);

create policy view_all_projects on project for select using (
  exists (
    select
      1
      from
	user_permission
	join permission
	    on true
	    and user_permission.permission_id = permission.id
	    and user_id = (current_setting('hasura.user')::jsonb->>'x-hasura-user-id')::uuid
	    and permission.name = 'view_all_projects'
  )
);

create policy view_all_timesheets on timesheet for select using (
  exists (
    select
      1
      from
	user_permission
	join permission on user_permission.permission_id = permission.id
	    and user_id = (current_setting('hasura.user')::jsonb->>'x-hasura-user-id')::uuid
	    and permission.name = 'view_all_timesheets'
  )
);
