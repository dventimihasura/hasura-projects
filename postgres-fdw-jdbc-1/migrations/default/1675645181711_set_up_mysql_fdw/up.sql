create server if not exists mysql foreign data wrapper jdbc_fdw options(
  drivername 'org.mariadb.jdbc.Driver',
  url 'jdbc:mysql://mysql:3306/chinook',
  jarfile '/usr/share/java/mariadb-java-client.jar'
);

create user mapping if not exists for current_user server mysql options(username 'chinook', password 'chinook');

create schema if not exists mysql;

import foreign schema mysql limit to (album, artist, customer, employee, genre, invoice, invoiceline, mediatype, playlist, playlisttrack, track) from server mysql into mysql;
