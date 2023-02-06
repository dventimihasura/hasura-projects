drop server if exists mysql cascade;

create server if not exists mysql foreign data wrapper jdbc_fdw options(
  drivername 'org.mariadb.jdbc.Driver',
  url 'jdbc:mysql://mysql:3306/chinook',
  jarfile '/usr/share/java/mariadb-java-client.jar'
);

drop user mapping if exists for current_user server mysql;

create user mapping if not exists for current_user server mysql options(username 'chinook', password 'chinook');

drop schema if exists mysql cascade;

create schema if not exists mysql;

import foreign schema mysql limit to (album, artist, customer, employee, genre, invoice, invoiceline, mediatype, playlist, playlisttrack, track) from server mysql into mysql;
