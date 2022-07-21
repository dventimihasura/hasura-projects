with sample as (select "user".id as user_id, organization.id as organization_id from "user", organization order by random() limit 10000) update "user" set organization_id = sample.organization_id from sample where "user".id = sample.user_id;