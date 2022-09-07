create materialized view if not exists leaderboard_snapshot as
  select
    *
    from
      leaderboard;
