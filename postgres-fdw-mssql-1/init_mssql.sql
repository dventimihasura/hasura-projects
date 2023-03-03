-- -*- sql-product: ms; -*-

create database test;
go

use test;
go

create table person (id int not null identity(1,1) primary key, name varchar(255));
go

insert into person (name) values ('David'), ('Daniel'), ('Tia');
go
