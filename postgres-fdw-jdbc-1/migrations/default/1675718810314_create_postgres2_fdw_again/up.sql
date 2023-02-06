CREATE SERVER postgres2 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'postgres', port '5432', dbname 'chinook');
