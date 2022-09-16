drop trigger if exists account_update on account cascade;

drop function if exists account_update cascade;

drop trigger if exists account_delete on account cascade;

drop function if exists account_delete cascade;

drop trigger if exists account_insert on account cascade;

drop function if exists account_insert cascade;

drop view if exists account;

alter table core.account set schema core;

drop schema if exists core cascade;
