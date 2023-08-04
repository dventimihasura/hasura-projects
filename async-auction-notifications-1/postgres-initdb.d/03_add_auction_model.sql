-- -*- sql-product: postgres; -*-

create table route (
  id uuid primary key default gen_random_uuid(),
  account_id uuid not null references account (id),
  departure_date daterange not null,
  origin text not null references region (value),
  destination text not null references region (value));

create table delivery (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references product (id),
  pickup_date daterange not null,
  origin text not null references region (value),
  destination text not null references region (value));

create table route_message (
  id uuid primary key default gen_random_uuid(),
  route_id uuid not null references route (id),
  delivery_id uuid not null references delivery (id));

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
