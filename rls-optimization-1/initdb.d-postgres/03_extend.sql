-- -*- sql-product: postgres; -*-

insert into "Track" ("TrackId", "Name", "AlbumId", "MediaTypeId", "GenreId", "Milliseconds", "Bytes", "UnitPrice")
select
  id, format('name%s', id), 1, 1, 1, 276349, 9056902, 0.99
  from
    generate_series((select max("TrackId")+1 from "Track"), (select max("TrackId")+1+10000000 from "Track")) id;
