create or replace view leaderboard as
  select
    rank() over (order by referrals desc, account.name asc),
    leads_aggregate.id
    from
      leads_aggregate
      join account on account.id = account_id;
