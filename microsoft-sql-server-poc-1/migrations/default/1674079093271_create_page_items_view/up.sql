create view page_items as
  select title, content from articles
  union all
  select title, description from alerts;
