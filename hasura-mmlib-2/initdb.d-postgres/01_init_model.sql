-- -*- sql-product: postgres; -*-

\timing

create extension if not exists citext;

create extension if not exists vector;

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

alter table resume add column embedding vector(1024) generated always as (pgml.embed('intfloat/e5-large', 'passage: ' || resume_str)) stored;

create index on resume using ivfflat (embedding vector_l2_ops) with (lists = 100);

create index on resume using ivfflat (embedding vector_ip_ops) with (lists = 100);

create index on resume using ivfflat (embedding vector_cosine_ops) with (lists = 100);

create or replace function resume_search(search text, n int)
  returns setof resume as $$
  select resume.*
  from resume
  order by embedding <-> pgml.embed('intfloat/e5-large', 'query: ' || search)::vector(1024)
  limit n
  $$ language sql stable;

copy resume(resume_id, resume_str, resume_html, category) from '/docker-entrypoint-initdb.d/Resume.csv' with (format csv, header true, quote '"');
