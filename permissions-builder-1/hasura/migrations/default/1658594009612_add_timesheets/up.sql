delete from timesheet;

with
  assignment as (
    select
      id,
      project_id,
      (random()*5)::int assignments
      from assignment
  )
    insert into timesheet (assignment_id, hours)
select
  assignment_id,
  (random()*9 + 1)::int hours
  from (
    select
      assignment.id assignment_id,
      row_number() over (partition by assignment.id order by project.name) ordinal
      from
	assignment join project on project.id = project_id,
	generate_series(1, 5)) assignments
       join assignment on assignment.id = assignment_id
	   and ordinal <= assignments;
