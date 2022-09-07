insert into account (name)
select
  format('%s %s', first_name.name, last_name.name)
  from
    first_name, last_name;
