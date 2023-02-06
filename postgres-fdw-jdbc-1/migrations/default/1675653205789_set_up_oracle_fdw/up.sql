create server if not exists oracle foreign data wrapper jdbc_fdw options(
  drivername 'oracle.jdbc.driver.OracleDriver',
  url 'jdbc:oracle:thin:@oracle:1521/xe',
  jarfile '/usr/share/java/ojdbc11.jar'
);

create user mapping if not exists for current_user server oracle options(username 'system', password 'chinook');

create schema if not exists oracle;

create foreign table oracle.album
(
    albumid int not null,
    title varchar(160) not null,
    artistid int not null
) server oracle;

create foreign table oracle.artist
(
    artistid int not null,
    name varchar(120)
) server oracle;

create foreign table oracle.customer
(
    customerid int not null,
    firstname varchar(40) not null,
    lastname varchar(20) not null,
    company varchar(80),
    address varchar(70),
    city varchar(40),
    state varchar(40),
    country varchar(40),
    postalcode varchar(10),
    phone varchar(24),
    fax varchar(24),
    email varchar(60) not null,
    supportrepid int
) server oracle;

create foreign table oracle.employee
(
    employeeid int not null,
    lastname varchar(20) not null,
    firstname varchar(20) not null,
    title varchar(30),
    reportsto int,
    birthdate date,
    hiredate date,
    address varchar(70),
    city varchar(40),
    state varchar(40),
    country varchar(40),
    postalcode varchar(10),
    phone varchar(24),
    fax varchar(24),
    email varchar(60)
) server oracle;

create foreign table oracle.genre
(
    genreid int not null,
    name varchar(120)
) server oracle;

create foreign table oracle.invoice
(
    invoiceid int not null,
    customerid int not null,
    invoicedate date not null,
    billingaddress varchar(70),
    billingcity varchar(40),
    billingstate varchar(40),
    billingcountry varchar(40),
    billingpostalcode varchar(10),
    total numeric(10,2) not null
) server oracle;

create foreign table oracle.invoiceline
(
    invoicelineid int not null,
    invoiceid int not null,
    trackid int not null,
    unitprice numeric(10,2) not null,
    quantity int not null
) server oracle;

create foreign table oracle.mediatype
(
    mediatypeid int not null,
    name varchar(120)
) server oracle;

create foreign table oracle.playlist
(
    playlistid int not null,
    name varchar(120)
) server oracle;

create foreign table oracle.playlisttrack
(
    playlistid int not null,
    trackid int not null
) server oracle;

create foreign table oracle.track
(
    trackid int not null,
    name varchar(200) not null,
    albumid int,
    mediatypeid int not null,
    genreid int,
    composer varchar(220),
    milliseconds int not null,
    bytes int,
    unitprice numeric(10,2) not null
) server oracle;
