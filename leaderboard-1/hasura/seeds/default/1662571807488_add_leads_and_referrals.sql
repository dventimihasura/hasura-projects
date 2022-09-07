insert into leads_aggregate (account_id, referrals)
select
  id,
  floor(random()*1e6)
  from
    account;
