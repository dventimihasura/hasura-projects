-- Table: public.business_profile

drop table if exists company cascade;

CREATE TABLE IF NOT EXISTS public.company
(
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    "legalName" character varying COLLATE pg_catalog."default" NOT NULL,
    "tradeName" character varying COLLATE pg_catalog."default" NOT NULL,
    "contactEmail" character varying COLLATE pg_catalog."default" NOT NULL,
    "contactPhoneNumber" character varying COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default" NOT NULL,
    iban character varying COLLATE pg_catalog."default" NOT NULL,
    national_company_registration_number character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "PK_056f7854a7afdba7cbd6d45fc20" PRIMARY KEY (id)
);

drop table if exists business_profile cascade;

CREATE TABLE IF NOT EXISTS public.business_profile
(
    value text COLLATE pg_catalog."default" NOT NULL,
    comment text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT business_profile_pkey PRIMARY KEY (value)
);

drop table if exists role cascade;

CREATE TABLE IF NOT EXISTS public.role
(
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    name character varying COLLATE pg_catalog."default" NOT NULL,
    "businessProfile" text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "PK_b36bcfe02fc8de3c57a8b2391c2" PRIMARY KEY (id),
    CONSTRAINT "UQ_b65354c6af446b5cb5dfc2173a1" UNIQUE (name, "businessProfile"),
    CONSTRAINT "role_businessProfile_fkey" FOREIGN KEY ("businessProfile")
        REFERENCES public.business_profile (value) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
);

drop table if exists role_assignment;

CREATE TABLE IF NOT EXISTS public.role_assignment
(
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    "companyId" uuid,
    "roleId" uuid,
    "userId" uuid,
    CONSTRAINT "PK_7e79671a8a5db18936173148cb4" PRIMARY KEY (id),
    CONSTRAINT "UQ_d3f619cb595bd66a7253b1ccc5e" UNIQUE ("companyId", "roleId", "userId"),
    CONSTRAINT "FK_01f83b9a868865de6cd6dca6cfb" FOREIGN KEY ("companyId")
        REFERENCES public.company (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "FK_f0de67fd09cd3cd0aabca79994d" FOREIGN KEY ("roleId")
        REFERENCES public.role (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
