CREATE SERVER origin FOREIGN DATA WRAPPER jdbc_fdw OPTIONS(
drivername 'org.postgresql.Driver',
url 'jdbc:postgresql://origin:5432/postgres',
jarfile '/usr/share/java/postgresql.jar'
);
