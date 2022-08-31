create materialized view if not exists asset_with_traits_as_jsonb_table as
  select * from asset_with_traits_as_jsonb_view;
