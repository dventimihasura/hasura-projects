create or replace view leaderboard as
  select
    rank() over (order by referrals desc),
    leads_aggregate.id
    from
      leads_aggregate;
