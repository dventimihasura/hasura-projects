create schema if not exists core;

alter table account set schema core;

alter table core.account drop column country;

drop view if exists account;

create or replace view account as
  select
    account.id,
    account.name,
    account.created_at,
    account.updated_at,
    account.country_id,
    country.name as country
    from
      core.account
      join country on country.id = account.country_id;

create or replace function account_insert () returns trigger as $$
  begin
    if exists (select 1 from country where country.name = new.country) then
      new.country_id := (select id from country where name = new.country);
    else
      insert into country (name) values (new.country) returning (id) into new.country_id;
    end if;
    insert into core.account (name, country_id) values (new.name, new.country_id);
    return new;
  end;
$$ language plpgsql;

create trigger account_insert instead of insert on account
  for each row execute function account_insert();

create or replace function account_delete () returns trigger as $$
  begin
    delete from core.account where id = old.id;
    return old;
  end;
$$ language plpgsql;

create trigger account_delete instead of delete on account
  for each row execute function account_delete();

create or replace function account_update () returns trigger as $$
  begin
    if exists (select 1 from country where country.name = new.country) then
      new.country_id := (select id from country where name = new.country);
    else
      insert into country (name) values (new.country) returning (id) into new.country_id;
    end if;
    update core.account set name = new.name, country_id = new.country_id where id = old.id;
    return new;
  end;
$$ language plpgsql;

create trigger account_update instead of update on account
  for each row execute function account_update();
