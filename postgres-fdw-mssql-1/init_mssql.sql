-- -*- sql-product: ms; -*-

create database test;
go

use test;
go

create table person (id int not null identity(1,1) primary key, name varchar(255));
go

insert into person (name) values ('David'), ('Daniel'), ('Tia');
go

create function get_persons ()
  returns table
as
  return select id, name from person;
go

create sequence countby1 start with 1 increment by 1 ;  
go

create procedure get_sequence_id
as
begin
  select next value for countby1 as id;
  return;
end;
go

create procedure get_guid_id
as
begin
  select newid() as id;
  return;
end;
go

waitfor delay '02:00';
go
