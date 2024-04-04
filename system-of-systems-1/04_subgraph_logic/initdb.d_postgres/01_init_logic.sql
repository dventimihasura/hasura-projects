-- -*- sql-product: postgres; -*-

create aggregate mul (int) (sfunc = int4mul, stype=int);
comment on aggregate mul (int) is 'logic to resolve acceptance tests';

create extension http;

create or replace function is_approved (design_id int)
  returns table (design_id int, is_approved boolean)
  language sql
  immutable
  strict
as $sql$
  select
  design_id,
  mul(approved::int)::boolean approved
  from (
    select
      (content->'id')::int design_id,
      (content->'accepted')::boolean approved
      from (
	select
	  jsonb_array_elements(content) content
	  from (
	    select
	      content::jsonb->'data'->'engineering'->'design' as content
	      from
		http((
		  'POST',
		  current_setting('request.headers', true)::json->>'hasura-graphql-endpoint',
		  array[http_header('x-hasura-admin-secret', current_setting('request.headers', true)::json->>'x-hasura-admin-secret')],
		  'application/json',
		  format(
		    $json$
		    {"query":"query{engineering{design(where:{id:{_in:[%s]}}){id accepted}}}","variables":{}}		
		    $json$, design_id)
		)::http_request)) foo)
     union
    select
      (content->'design_id')::int design_id,
      (content->'approved')::boolean approved
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
		)::http_request)) foo)) bar
  group by design_id;
  $sql$;

  
