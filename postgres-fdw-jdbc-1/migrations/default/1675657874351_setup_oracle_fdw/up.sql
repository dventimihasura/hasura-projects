create schema if not exists oracle;

create extension if not exists oracle_fdw;

create server if not exists oracle foreign data wrapper oracle_fdw options (dbserver '//oracle:1521/xe');

create user mapping if not exists for current_user server oracle options (user 'system', password 'chinook');

import foreign schema "SYS" limit to (album, artist, customer, employee, genre, invoice, invoiceline, mediatype, playlist, playlisttrack, track) from server oracle into oracle options (case 'lower');
