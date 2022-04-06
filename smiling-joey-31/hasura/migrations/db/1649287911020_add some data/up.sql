insert into business_profile ("value", "comment") values
('bronze', 'Bronze Profile'),
('silver', 'Silver Profile'),
('gold', 'Gold Profile');

insert into role (name, "businessProfile") values
('Junior', 'bronze'),
('Senior', 'silver'),
('Executive', 'gold');

insert into company ("legalName", "tradeName", "contactEmail", "contactPhoneNumber", "description", "iban", "national_company_registration_number") values
('Acme Enterprises', 'Acme', 'help@acme.com', '415-555-1212', 'Pest Control', 'test', '12345'),
('Ajax Corporation', 'Ajax', 'help@ajax.com', '415-555-1212', 'Contracting', 'test', '12345'),
('Commercial Paper', 'Paper', 'help@paper.com', '415-555-1212', 'Office Supplies', 'test', '12345');

insert into role_assignment("companyId", "roleId", "userId")
select company.id, role.id, gen_random_uuid()
from company, role
where "tradeName" = 'Acme' and "name" = 'Junior'
union
select company.id, role.id, gen_random_uuid()
from company, role
where "tradeName" = 'Acme' and "name" = 'Junior'
union
select company.id, role.id, gen_random_uuid()
from company, role
where "tradeName" = 'Acme' and "name" = 'Junior';
