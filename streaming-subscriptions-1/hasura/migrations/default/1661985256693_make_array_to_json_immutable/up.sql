create or replace function array_to_json_immutable(anyarray)
  returns json
  language sql
  immutable
  as $$select array_to_json($1)$$;
