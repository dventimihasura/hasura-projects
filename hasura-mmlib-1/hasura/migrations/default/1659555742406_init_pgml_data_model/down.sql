-- -*- sql-product: postgres; -*-

drop view if exists breast_cancer cascade;

drop view if exists diabetes cascade;

drop view if exists digits cascade;

drop view if exists iris cascade;

drop view if exists linnerud cascade;

drop table if exists pulse cascade;

drop function if exists pulse_rate;
