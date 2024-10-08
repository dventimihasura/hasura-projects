SET check_function_bodies = false;
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
CREATE TABLE public."Album" (
    "AlbumId" integer NOT NULL,
    "Title" character varying(160) NOT NULL,
    "ArtistId" integer NOT NULL
);
CREATE TABLE public."Artist" (
    "ArtistId" integer NOT NULL,
    "Name" character varying(120)
);
CREATE TABLE public."Customer" (
    "CustomerId" integer NOT NULL,
    "FirstName" character varying(40) NOT NULL,
    "LastName" character varying(20) NOT NULL,
    "Company" character varying(80),
    "Address" character varying(70),
    "City" character varying(40),
    "State" character varying(40),
    "Country" character varying(40),
    "PostalCode" character varying(10),
    "Phone" character varying(24),
    "Fax" character varying(24),
    "Email" character varying(60) NOT NULL,
    "SupportRepId" integer
);
CREATE TABLE public."Employee" (
    "EmployeeId" integer NOT NULL,
    "LastName" character varying(20) NOT NULL,
    "FirstName" character varying(20) NOT NULL,
    "Title" character varying(30),
    "ReportsTo" integer,
    "BirthDate" timestamp without time zone,
    "HireDate" timestamp without time zone,
    "Address" character varying(70),
    "City" character varying(40),
    "State" character varying(40),
    "Country" character varying(40),
    "PostalCode" character varying(10),
    "Phone" character varying(24),
    "Fax" character varying(24),
    "Email" character varying(60)
);
CREATE TABLE public."Genre" (
    "GenreId" integer NOT NULL,
    "Name" character varying(120)
);
CREATE TABLE public."Invoice" (
    "InvoiceId" integer NOT NULL,
    "CustomerId" integer NOT NULL,
    "InvoiceDate" timestamp without time zone NOT NULL,
    "BillingAddress" character varying(70),
    "BillingCity" character varying(40),
    "BillingState" character varying(40),
    "BillingCountry" character varying(40),
    "BillingPostalCode" character varying(10),
    "Total" numeric(10,2) NOT NULL
);
CREATE TABLE public."InvoiceLine" (
    "InvoiceLineId" integer NOT NULL,
    "InvoiceId" integer NOT NULL,
    "TrackId" integer NOT NULL,
    "UnitPrice" numeric(10,2) NOT NULL,
    "Quantity" integer NOT NULL
);
CREATE TABLE public."MediaType" (
    "MediaTypeId" integer NOT NULL,
    "Name" character varying(120)
);
CREATE TABLE public."Playlist" (
    "PlaylistId" integer NOT NULL,
    "Name" character varying(120)
);
CREATE TABLE public."PlaylistTrack" (
    "PlaylistId" integer NOT NULL,
    "TrackId" integer NOT NULL
);
CREATE TABLE public."Track" (
    "TrackId" integer NOT NULL,
    "Name" character varying(200) NOT NULL,
    "AlbumId" integer,
    "MediaTypeId" integer NOT NULL,
    "GenreId" integer,
    "Composer" character varying(220),
    "Milliseconds" integer NOT NULL,
    "Bytes" integer,
    "UnitPrice" numeric(10,2) NOT NULL
);
ALTER TABLE ONLY public."Album"
    ADD CONSTRAINT "PK_Album" PRIMARY KEY ("AlbumId");
ALTER TABLE ONLY public."Artist"
    ADD CONSTRAINT "PK_Artist" PRIMARY KEY ("ArtistId");
ALTER TABLE ONLY public."Customer"
    ADD CONSTRAINT "PK_Customer" PRIMARY KEY ("CustomerId");
ALTER TABLE ONLY public."Employee"
    ADD CONSTRAINT "PK_Employee" PRIMARY KEY ("EmployeeId");
ALTER TABLE ONLY public."Genre"
    ADD CONSTRAINT "PK_Genre" PRIMARY KEY ("GenreId");
ALTER TABLE ONLY public."Invoice"
    ADD CONSTRAINT "PK_Invoice" PRIMARY KEY ("InvoiceId");
ALTER TABLE ONLY public."InvoiceLine"
    ADD CONSTRAINT "PK_InvoiceLine" PRIMARY KEY ("InvoiceLineId");
ALTER TABLE ONLY public."MediaType"
    ADD CONSTRAINT "PK_MediaType" PRIMARY KEY ("MediaTypeId");
ALTER TABLE ONLY public."Playlist"
    ADD CONSTRAINT "PK_Playlist" PRIMARY KEY ("PlaylistId");
ALTER TABLE ONLY public."PlaylistTrack"
    ADD CONSTRAINT "PK_PlaylistTrack" PRIMARY KEY ("PlaylistId", "TrackId");
ALTER TABLE ONLY public."Track"
    ADD CONSTRAINT "PK_Track" PRIMARY KEY ("TrackId");
CREATE INDEX "IFK_AlbumArtistId" ON public."Album" USING btree ("ArtistId");
CREATE INDEX "IFK_CustomerSupportRepId" ON public."Customer" USING btree ("SupportRepId");
CREATE INDEX "IFK_EmployeeReportsTo" ON public."Employee" USING btree ("ReportsTo");
CREATE INDEX "IFK_InvoiceCustomerId" ON public."Invoice" USING btree ("CustomerId");
CREATE INDEX "IFK_InvoiceLineInvoiceId" ON public."InvoiceLine" USING btree ("InvoiceId");
CREATE INDEX "IFK_InvoiceLineTrackId" ON public."InvoiceLine" USING btree ("TrackId");
CREATE INDEX "IFK_PlaylistTrackTrackId" ON public."PlaylistTrack" USING btree ("TrackId");
CREATE INDEX "IFK_TrackAlbumId" ON public."Track" USING btree ("AlbumId");
CREATE INDEX "IFK_TrackGenreId" ON public."Track" USING btree ("GenreId");
CREATE INDEX "IFK_TrackMediaTypeId" ON public."Track" USING btree ("MediaTypeId");
ALTER TABLE ONLY public."Album"
    ADD CONSTRAINT "FK_AlbumArtistId" FOREIGN KEY ("ArtistId") REFERENCES public."Artist"("ArtistId");
ALTER TABLE ONLY public."Customer"
    ADD CONSTRAINT "FK_CustomerSupportRepId" FOREIGN KEY ("SupportRepId") REFERENCES public."Employee"("EmployeeId");
ALTER TABLE ONLY public."Employee"
    ADD CONSTRAINT "FK_EmployeeReportsTo" FOREIGN KEY ("ReportsTo") REFERENCES public."Employee"("EmployeeId");
ALTER TABLE ONLY public."Invoice"
    ADD CONSTRAINT "FK_InvoiceCustomerId" FOREIGN KEY ("CustomerId") REFERENCES public."Customer"("CustomerId");
ALTER TABLE ONLY public."InvoiceLine"
    ADD CONSTRAINT "FK_InvoiceLineInvoiceId" FOREIGN KEY ("InvoiceId") REFERENCES public."Invoice"("InvoiceId");
ALTER TABLE ONLY public."InvoiceLine"
    ADD CONSTRAINT "FK_InvoiceLineTrackId" FOREIGN KEY ("TrackId") REFERENCES public."Track"("TrackId");
ALTER TABLE ONLY public."PlaylistTrack"
    ADD CONSTRAINT "FK_PlaylistTrackPlaylistId" FOREIGN KEY ("PlaylistId") REFERENCES public."Playlist"("PlaylistId");
ALTER TABLE ONLY public."PlaylistTrack"
    ADD CONSTRAINT "FK_PlaylistTrackTrackId" FOREIGN KEY ("TrackId") REFERENCES public."Track"("TrackId");
ALTER TABLE ONLY public."Track"
    ADD CONSTRAINT "FK_TrackAlbumId" FOREIGN KEY ("AlbumId") REFERENCES public."Album"("AlbumId");
ALTER TABLE ONLY public."Track"
    ADD CONSTRAINT "FK_TrackGenreId" FOREIGN KEY ("GenreId") REFERENCES public."Genre"("GenreId");
ALTER TABLE ONLY public."Track"
    ADD CONSTRAINT "FK_TrackMediaTypeId" FOREIGN KEY ("MediaTypeId") REFERENCES public."MediaType"("MediaTypeId");
