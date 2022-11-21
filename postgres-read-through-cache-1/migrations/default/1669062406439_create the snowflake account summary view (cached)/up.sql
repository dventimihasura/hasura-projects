create materialized view if not exists snowflake_account_summary_cached as
  select * from snowflake_account_summary;
