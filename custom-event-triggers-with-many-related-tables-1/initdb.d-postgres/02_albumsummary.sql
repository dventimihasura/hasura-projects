-- -*- sql-product: postgres; -*-

create table "AlbumSummary" (
  "AlbumId" integer primary key references "Album" ("AlbumId"),
  "Payload" jsonb
);
