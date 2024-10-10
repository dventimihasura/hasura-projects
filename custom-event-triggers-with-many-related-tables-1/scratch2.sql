-- -*- sql-product: postgres; -*-

select version();

create table "AlbumSummary" (
  "AlbumId" integer primary key references "Album" ("AlbumId"),
  "Payload" jsonb
);
