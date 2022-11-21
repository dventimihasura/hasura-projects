CREATE OR REPLACE FUNCTION refresh_snowflake_account_summary_cached ()
  RETURNS setof snowflake_account_summary_cached AS $$
  BEGIN
    refresh materialized view snowflake_account_summary_cached;
    return query select * from snowflake_account_summary_cached limit 1;
  END;
$$ LANGUAGE plpgsql;
