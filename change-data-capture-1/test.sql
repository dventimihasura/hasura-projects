-- -*- sql-mode: postgres; -*-

insert into account (name) values ((select faker.name()));
