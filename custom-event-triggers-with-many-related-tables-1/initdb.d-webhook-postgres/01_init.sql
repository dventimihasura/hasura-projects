-- -*- sql-product: postgres; -*-

create extension if not exists http;

comment on extension http is 'HTTP client library';

create or replace function insert_albumsummary_one ("albumId" int, "payload" jsonb) returns text language sql as $function$
  select count(*) from
  http_post(
    'http://graphql-engine:8080/v1/graphql',
    format(
	$$
	{"query":"mutation MyMutation($albumId:Int,$payload:jsonb){insert_AlbumSummary_one(object:{AlbumId:$albumId,Payload:$payload}on_conflict:{constraint:AlbumSummary_pkey,update_columns:[Payload]}){AlbumId Payload}}","variables":{"albumId":%s,"payload":%s}}
	$$,
	$1,
	$2),
	'application/json')
  $function$;

comment on function insert_albumsummary_one ("albumId" int, "payload" jsonb) is 'Insert into AlbumSummary one record';

create or replace function insert_albumsummary_one ("albumId" int) returns text language sql as $function$
  with summary as (
    select
      content
      from
	http_post(
	  'http://graphql-engine:8080/v1/graphql',
	  format(
	    $${"query":"query MyQuery{Album_by_pk(AlbumId:%s){AlbumId ArtistId Title Tracks{AlbumId Bytes Composer GenreId MediaTypeId Milliseconds Name UnitPrice MediaType{MediaTypeId Name}Genre{GenreId Name}}}}","variables":{}}$$,
	    $1),
	    'application/json'))
  select insert_albumsummary_one($1, content::jsonb) from summary;
  $function$;

comment on function insert_albumsummary_one ("albumId" int) is 'Insert into AlbumSummary one record';
