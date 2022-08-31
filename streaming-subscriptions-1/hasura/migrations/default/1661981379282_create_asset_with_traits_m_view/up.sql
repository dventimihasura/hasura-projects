create materialized view if not exists asset_with_traits as
  select
    *
    from
      asset_denormed;
