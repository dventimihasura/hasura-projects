drop server if exists postgres cascade;

create server if not exists postgres foreign data wrapper jdbc_fdw options(
  drivername 'org.postgresql.Driver',
  url 'jdbc:postgresql://postgres/chinook',
  jarfile '/usr/share/java/postgresql.jar'
);

drop user mapping if exists for current_user server postgres;

create user mapping if not exists for current_user server postgres options(username 'chinook', password 'chinook');

drop schema if exists postgres cascade;

create schema if not exists postgres;

import foreign schema postgres limit to (album, artist, customer, employee, genre, invoice, invoiceline, mediatype, playlist, playlisttrack, track) from server postgres into postgres;
