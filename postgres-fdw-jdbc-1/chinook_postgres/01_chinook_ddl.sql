create table album
(
    albumid int not null,
    title varchar(160) not null,
    artistid int not null,
    constraint pk_album primary key  (albumid)
);

create table artist
(
    artistid int not null,
    name varchar(120),
    constraint pk_artist primary key  (artistid)
);

create table customer
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
    supportrepid int,
    constraint pk_customer primary key  (customerid)
);

create table employee
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
    email varchar(60),
    constraint pk_employee primary key  (employeeid)
);

create table genre
(
    genreid int not null,
    name varchar(120),
    constraint pk_genre primary key  (genreid)
);

create table invoice
(
    invoiceid int not null,
    customerid int not null,
    invoicedate date not null,
    billingaddress varchar(70),
    billingcity varchar(40),
    billingstate varchar(40),
    billingcountry varchar(40),
    billingpostalcode varchar(10),
    total numeric(10,2) not null,
    constraint pk_invoice primary key  (invoiceid)
);

create table invoiceline
(
    invoicelineid int not null,
    invoiceid int not null,
    trackid int not null,
    unitprice numeric(10,2) not null,
    quantity int not null,
    constraint pk_invoiceline primary key  (invoicelineid)
);

create table mediatype
(
    mediatypeid int not null,
    name varchar(120),
    constraint pk_mediatype primary key  (mediatypeid)
);

create table playlist
(
    playlistid int not null,
    name varchar(120),
    constraint pk_playlist primary key  (playlistid)
);

create table playlisttrack
(
    playlistid int not null,
    trackid int not null,
    constraint pk_playlisttrack primary key  (playlistid, trackid)
);

create table track
(
    trackid int not null,
    name varchar(200) not null,
    albumid int,
    mediatypeid int not null,
    genreid int,
    composer varchar(220),
    milliseconds int not null,
    bytes int,
    unitprice numeric(10,2) not null,
    constraint pk_track primary key  (trackid)
);



/*******************************************************************************
   create primary key unique indexes
********************************************************************************/

/*******************************************************************************
   create foreign keys
********************************************************************************/
alter table album add constraint fk_albumartistid
    foreign key (artistid) references artist (artistid) on delete no action on update no action;

create index ifk_albumartistid on album (artistid);

alter table customer add constraint fk_customersupportrepid
    foreign key (supportrepid) references employee (employeeid) on delete no action on update no action;

create index ifk_customersupportrepid on customer (supportrepid);

alter table employee add constraint fk_employeereportsto
    foreign key (reportsto) references employee (employeeid) on delete no action on update no action;

create index ifk_employeereportsto on employee (reportsto);

alter table invoice add constraint fk_invoicecustomerid
    foreign key (customerid) references customer (customerid) on delete no action on update no action;

create index ifk_invoicecustomerid on invoice (customerid);

alter table invoiceline add constraint fk_invoicelineinvoiceid
    foreign key (invoiceid) references invoice (invoiceid) on delete no action on update no action;

create index ifk_invoicelineinvoiceid on invoiceline (invoiceid);

alter table invoiceline add constraint fk_invoicelinetrackid
    foreign key (trackid) references track (trackid) on delete no action on update no action;

create index ifk_invoicelinetrackid on invoiceline (trackid);

alter table playlisttrack add constraint fk_playlisttrackplaylistid
    foreign key (playlistid) references playlist (playlistid) on delete no action on update no action;

alter table playlisttrack add constraint fk_playlisttracktrackid
    foreign key (trackid) references track (trackid) on delete no action on update no action;

create index ifk_playlisttracktrackid on playlisttrack (trackid);

alter table track add constraint fk_trackalbumid
    foreign key (albumid) references album (albumid) on delete no action on update no action;

create index ifk_trackalbumid on track (albumid);

alter table track add constraint fk_trackgenreid
    foreign key (genreid) references genre (genreid) on delete no action on update no action;

create index ifk_trackgenreid on track (genreid);

alter table track add constraint fk_trackmediatypeid
    foreign key (mediatypeid) references mediatype (mediatypeid) on delete no action on update no action;

create index ifk_trackmediatypeid on track (mediatypeid);
