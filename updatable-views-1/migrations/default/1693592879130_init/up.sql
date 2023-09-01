SET check_function_bodies = false;
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
CREATE TYPE public.status AS ENUM (
    'new',
    'processing',
    'fulfilled'
);
CREATE FUNCTION public.delete_product_private() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  delete from product_name where id = old.id;
  delete from product_price where id = old.id;
  delete from product where id = old.id;
  return new;
end;
$$;
CREATE FUNCTION public.insert_product_private() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  declare
    product_id uuid;
begin
  insert into product default values returning id into product_id;
  insert into product_name values (product_id, new.name);
  insert into product_price values (product_id, new.price);
  return new;
end;
$$;
CREATE TABLE public.product (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
CREATE FUNCTION public.product_search(search text) RETURNS SETOF public.product
    LANGUAGE sql STABLE
    AS $$
  select product.*
  from product
  where
  name ilike ('%' || search || '%')
$$;
CREATE FUNCTION public.product_search_slow(search text, wait real) RETURNS SETOF public.product
    LANGUAGE sql STABLE
    AS $$
  select product.*
  from product, pg_sleep(wait)
  where
  name ilike ('%' || search || '%')
$$;
CREATE FUNCTION public.set_current_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE
    _new record;
  BEGIN
    _new := NEW;
    _new."updated_at" = NOW();
    RETURN _new;
  END;
$$;
CREATE TABLE public.account (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
CREATE TABLE public.account_address (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    account_id uuid NOT NULL,
    physical_address text,
    email_address text
);
CREATE TABLE public."order" (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    account_id uuid NOT NULL,
    status public.status,
    region text
);
CREATE TABLE public.order_detail (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    units integer NOT NULL,
    order_id uuid NOT NULL,
    product_id uuid NOT NULL
);
CREATE TABLE public.product_name (
    id uuid NOT NULL,
    name text
);
CREATE TABLE public.product_price (
    id uuid NOT NULL,
    price integer
);
CREATE VIEW public.product_private AS
 SELECT product.id,
    product.created_at,
    product.updated_at,
    product_name.name,
    product_price.price
   FROM ((public.product
     JOIN public.product_name ON ((product_name.id = product.id)))
     JOIN public.product_price ON ((product_price.id = product.id)));
CREATE TABLE public.region (
    value text NOT NULL,
    description text
);
ALTER TABLE ONLY public.account_address
    ADD CONSTRAINT account_address_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.product_name
    ADD CONSTRAINT product_name_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.product_price
    ADD CONSTRAINT product_price_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_pkey PRIMARY KEY (value);
CREATE INDEX account_name_idx ON public.account USING btree (name);
CREATE INDEX order_account_id_idx ON public."order" USING btree (account_id);
CREATE INDEX order_detail_order_id_idx ON public.order_detail USING btree (order_id);
CREATE INDEX order_detail_product_id_idx ON public.order_detail USING btree (product_id);
CREATE INDEX order_region_idx ON public."order" USING btree (region);
CREATE INDEX order_status_idx ON public."order" USING btree (status);
CREATE RULE update_product_private AS
    ON UPDATE TO public.product_private DO INSTEAD ( UPDATE public.product SET id = new.id, created_at = new.created_at, updated_at = new.updated_at
  WHERE (product.id = old.id);
 UPDATE public.product_name SET id = new.id, name = new.name
  WHERE (product_name.id = old.id);
 UPDATE public.product_price SET id = new.id, price = new.price
  WHERE (product_price.id = old.id);
);
CREATE TRIGGER delete_product_private INSTEAD OF DELETE ON public.product_private FOR EACH ROW EXECUTE FUNCTION public.delete_product_private();
CREATE TRIGGER insert_product_private INSTEAD OF INSERT ON public.product_private FOR EACH ROW EXECUTE FUNCTION public.insert_product_private();
CREATE TRIGGER set_public_account_updated_at BEFORE UPDATE ON public.account FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_account_updated_at ON public.account IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_order_detail_updated_at BEFORE UPDATE ON public.order_detail FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_order_detail_updated_at ON public.order_detail IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_order_updated_at BEFORE UPDATE ON public."order" FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_order_updated_at ON public."order" IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_product_updated_at BEFORE UPDATE ON public.product FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_product_updated_at ON public.product IS 'trigger to set value of column "updated_at" to current timestamp on row update';
ALTER TABLE ONLY public.account_address
    ADD CONSTRAINT account_address_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.account(id);
ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.account(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_region_fkey FOREIGN KEY (region) REFERENCES public.region(value) ON UPDATE RESTRICT ON DELETE RESTRICT;
