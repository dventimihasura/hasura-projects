-- -*- sql-product: postgres; -*-

create extension citext;

create domain email as citext
  check ( value ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$' );

create domain url as citext
  check ( value ~ '^(https?://)?(www\.)?' );

create table candidate (
  id int not null primary key generated always as identity,
  name text,
  email email);

create table application (
  id int not null primary key generated always as identity,
  candidate_id int references candidate (id),
  resume_url url,
  hiring_manager text);

create table resume (
  id int not null primary key generated always as identity,
  resume_id int,
  resume_str text,
  resume_html text,
  category text);
  
alter table resume add column embedding vector(1024) null;
