-- -*- sql-product: postgres; -*-

create role "User";

grant select on "Album" to "User";

create policy artist_rls_policy ON "Album" for select to public using ("ArtistId"=(current_setting('rls.artistID'))::integer);

alter table "Album" enable row level security;

grant select on "Track" to "User";

create policy album_rls_policy on "Track" for select to public
using (
  exists (
    select 1 from "Album" where "Track"."AlbumId" = "Album"."AlbumId"
  )
);

alter table "Track" enable row level security;


