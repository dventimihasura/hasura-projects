-- -*- sql-product: postgres; -*-

create extension http;

create or replace function is_approved (design_id int)
  returns boolean
  language sql
  immutable
  strict
as $sql$
  select
  exists (
    select
      *
      from (
	select
	  jsonb_array_elements(content) content
	  from (
	    select
	      content::jsonb->'data'->'product'->'approvals' as content
	      from
		http((
		  'POST',
		  current_setting('request.headers', true)::json->>'hasura-graphql-endpoint',
		  array[http_header('x-hasura-admin-secret', current_setting('request.headers', true)::json->>'x-hasura-admin-secret')],
		  'application/json',
		  format(
		    $json$
		    {"query":"query{product{approvals(where:{design_id:{_in:[%s]}}){design_id approved}}}","variables":{}}	     
		    $json$, design_id)
		)::http_request)) foo)
     where (content->'approved')::boolean)
  $sql$;
