create materialized view if not exists account_summary_cached as
  select * from account_summary;
