import foreign schema "SYS" limit to (album, artist, customer, employee, genre, invoice, invoiceline, mediatype, playlist, playlisttrack, track) from server oracle into oracle options (case 'lower');
