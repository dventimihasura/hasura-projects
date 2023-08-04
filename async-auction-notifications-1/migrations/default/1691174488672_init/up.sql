SET check_function_bodies = false;
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
CREATE TYPE public.status AS ENUM (
    'new',
    'processing',
    'fulfilled'
);
CREATE FUNCTION public.generate_messages() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    begin
      insert into route_message (delivery_id, route_id)
      select
	d.id as delivery_id,
	r.id as route_id
	from
	  delivery d
	  join route r on pickup_date && departure_date and d.origin = r.origin and d.destination = r.destination
	  left join route_message rm on rm.delivery_id = d.id and rm.route_id = r.id
       where true
	 and rm.id is null;
      return new;
    end
$$;
CREATE TABLE public.product (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    name text NOT NULL,
    price integer NOT NULL,
    CONSTRAINT non_negative_price CHECK ((price > 0))
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
CREATE FUNCTION public.run_simulation(ndeliveries integer, nroutes integer) RETURNS void
    LANGUAGE sql
    AS $$
  insert into delivery (product_id, pickup_date, origin, destination)
  select
  p.id as product_id,
  format('[%s, %s]', pickup_date, pickup_date)::daterange as pickup_date_range,
  o.value as origin,
  d.value as destination
  from
  region o,
  region d,
  product p,
  (select (current_date + (random()*10)::int * interval '1 days')::date as pickup_date from generate_series(1, 10)) t
  where true
  and o.value != d.value order by random()
  limit ndeliveries;
  insert into route (account_id, departure_date, origin, destination)
  select
    a.account_id,
    format('[%s, %s]', departure_date, departure_date)::daterange as departure_date_range,
    o.value as origin,
    d.value as destination
    from
      (select id as account_id from account order by random() limit 10) a,
      region o,
      region d,
      (select (current_date + (random()*10)::int * interval '1 days')::date as departure_date from generate_series(1, 10)) t
   where true
     and o.value != d.value order by random()
   limit nroutes;
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
CREATE TABLE public.delivery (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    pickup_date daterange NOT NULL,
    origin text NOT NULL,
    destination text NOT NULL
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
CREATE TABLE public.region (
    value text NOT NULL,
    description text
);
CREATE TABLE public.route (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    account_id uuid NOT NULL,
    departure_date daterange NOT NULL,
    origin text NOT NULL,
    destination text NOT NULL
);
CREATE TABLE public.route_message (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    route_id uuid NOT NULL,
    delivery_id uuid NOT NULL
);
ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.delivery
    ADD CONSTRAINT delivery_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_pkey PRIMARY KEY (value);
ALTER TABLE ONLY public.route_message
    ADD CONSTRAINT route_message_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.route
    ADD CONSTRAINT route_pkey PRIMARY KEY (id);
CREATE INDEX account_name_idx ON public.account USING btree (name);
CREATE INDEX order_account_id_idx ON public."order" USING btree (account_id);
CREATE INDEX order_detail_order_id_idx ON public.order_detail USING btree (order_id);
CREATE INDEX order_detail_product_id_idx ON public.order_detail USING btree (product_id);
CREATE INDEX order_region_idx ON public."order" USING btree (region);
CREATE INDEX order_status_idx ON public."order" USING btree (status);
CREATE TRIGGER generate_messages AFTER INSERT ON public.delivery FOR EACH STATEMENT EXECUTE FUNCTION public.generate_messages();
CREATE TRIGGER generate_messages AFTER INSERT ON public.route FOR EACH STATEMENT EXECUTE FUNCTION public.generate_messages();
CREATE TRIGGER set_public_account_updated_at BEFORE UPDATE ON public.account FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_account_updated_at ON public.account IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_order_detail_updated_at BEFORE UPDATE ON public.order_detail FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_order_detail_updated_at ON public.order_detail IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_order_updated_at BEFORE UPDATE ON public."order" FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_order_updated_at ON public."order" IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_product_updated_at BEFORE UPDATE ON public.product FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_product_updated_at ON public.product IS 'trigger to set value of column "updated_at" to current timestamp on row update';
ALTER TABLE ONLY public.delivery
    ADD CONSTRAINT delivery_destination_fkey FOREIGN KEY (destination) REFERENCES public.region(value);
ALTER TABLE ONLY public.delivery
    ADD CONSTRAINT delivery_origin_fkey FOREIGN KEY (origin) REFERENCES public.region(value);
ALTER TABLE ONLY public.delivery
    ADD CONSTRAINT delivery_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(id);
ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.account(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_region_fkey FOREIGN KEY (region) REFERENCES public.region(value) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.route
    ADD CONSTRAINT route_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.account(id);
ALTER TABLE ONLY public.route
    ADD CONSTRAINT route_destination_fkey FOREIGN KEY (destination) REFERENCES public.region(value);
ALTER TABLE ONLY public.route_message
    ADD CONSTRAINT route_message_delivery_id_fkey FOREIGN KEY (delivery_id) REFERENCES public.delivery(id);
ALTER TABLE ONLY public.route_message
    ADD CONSTRAINT route_message_route_id_fkey FOREIGN KEY (route_id) REFERENCES public.route(id);
ALTER TABLE ONLY public.route
    ADD CONSTRAINT route_origin_fkey FOREIGN KEY (origin) REFERENCES public.region(value);
