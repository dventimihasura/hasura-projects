CREATE FUNCTION search_articles(@search varchar)
RETURNS table return (
  SELECT *
  FROM articles
  WHERE
    title like ('%' + @search + '%')
    OR content like ('%' + @search + '%')
);
