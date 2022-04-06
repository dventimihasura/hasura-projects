ALTER TABLE company ADD business_profile TEXT NULL;
ALTER TABLE company
  ADD CONSTRAINT business_profile FOREIGN KEY(business_profile) REFERENCES business_profile (value);
With subquery AS (
  SELECT cmp.id, r."businessProfile" FROM company AS cmp
					  INNER JOIN
					  role_assignment AS ra
					      ON cmp.id = ra."companyId"
					  INNER JOIN role AS r
					      ON ra."roleId" = r."id"
)
    UPDATE company AS cmp
    SET business_profile = subquery."businessProfile"
    FROM subquery
    WHERE subquery.id = cmp.id;
ALTER TABLE company ALTER COLUMN business_profile SET NOT NULL;
