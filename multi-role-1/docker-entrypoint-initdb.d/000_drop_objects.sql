-- -*- sql-product: postgres; -*-

drop table if exists account cascade;

drop table if exists "order" cascade;

drop table if exists order_detail cascade;

drop table if exists product cascade;

drop table if exists region cascade;

drop function if exists product_search(text);

drop function if exists product_search_slow(text, real);
