update "user" set organization_id = org.id from (select organization.id from organization, generate_series(1,100) order by random()) org;