drop policy if exists query on assignment;

drop policy if exists query on organization;

drop policy if exists query on permission;

drop policy if exists query on project;

drop policy if exists query on timesheet;

drop policy if exists query on "user";

drop policy if exists query on user_permission;

drop policy if exists delete_assigned_projects on project;

drop policy if exists edit_all_projects on project;

drop policy if exists edit_all_timesheets on timesheet;

drop policy if exists edit_assigned_projects on project;

drop policy if exists view_all_projects on project;

drop policy if exists view_all_timesheets on timesheet;
