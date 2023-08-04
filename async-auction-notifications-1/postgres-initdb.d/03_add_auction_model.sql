-- -*- sql-product: postgres; -*-

create table route (
  id uuid primary key default gen_random_uuid(),
  account_id uuid not null references account (id), --Truckers have routes.
  departure_date daterange not null,		    --Dates are modelled as date ranges in case we want to get fancy with overlaps.
  origin text not null references region (value),   --TODO add constraint so that origin cannot = destination
  destination text not null references region (value));

create index on route (account_id);

create index on route (departure_date, origin, destination);

comment on table route is 'A route represents a planned journey by a trucker between regions beginning within a date range.';

create table delivery (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references product (id), --Products have deliveries.
  pickup_date daterange not null,		    --Same thing as above with date ranges
  origin text not null references region (value),   --TODO likewise add a constraint so that origin cannot = destination.
  destination text not null references region (value));

create index on delivery (product_id);

create index on delivery (pickup_date, origin, destination);

comment on table delivery is 'A delivery represents a desired journey by a product between regions beginning within a date range.';

create table route_message (
  id uuid primary key default gen_random_uuid(),
  route_id uuid not null references route (id), --Don't need anything other than route_id and delivery_id because everything else
  delivery_id uuid not null references delivery (id)); --(e.g. account_id, product_id) is implied.  TODO:  add timestamp and status fields to the message.

create index on route_message (route_id, delivery_id);

comment on table route_message is 'A route_message represents a notification about a match between a route and a delivery.';

create or replace function generate_messages ()
  returns trigger
  language plpgsql
  volatile
  not leakproof
as $plpgsql$
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
$plpgsql$;

comment on function generate_messages is 'The generate_messages function is a trigger function that creates route_message rows when matching conditions arise.';

create trigger generate_messages after insert on delivery execute function generate_messages();

create trigger generate_messages after insert on route execute function generate_messages();

create or replace function run_simulation (ndeliveries int, nroutes int)
  returns void
  language sql
  volatile
  not leakproof as $sql$
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
  $sql$;

comment on function run_simulation is 'The run_simulation function creates the desired number of deliveries and routes in order to demonstrate the creation of messages.';
