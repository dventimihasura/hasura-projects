-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- create or replace view leaderboard as
--   select
--     rank() over (order by referrals desc),
--     leads_aggregate.id
--     from
--       leads_aggregate;
