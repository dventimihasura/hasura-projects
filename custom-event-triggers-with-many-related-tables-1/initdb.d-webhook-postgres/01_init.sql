-- -*- sql-product: postgres; -*-

create extension if not exists http;

create or replace function insert_albumsummary_one ("albumId" int, "payload" jsonb) returns text language sql as $function$
  select
  count(*)
  from
  http_post(
    'http://graphql-engine:8080/v1/graphql',
    format(
	$$
	{"query":"mutation MyMutation($albumId:Int,$payload:jsonb){insert_AlbumSummary_one(object:{AlbumId:$albumId,Payload:$payload}){AlbumId Payload}}","variables":{"albumId":%s,"payload":%s}}
	$$,
	$1,
	$2
    ),
    'application/json'
  )
  $function$;

