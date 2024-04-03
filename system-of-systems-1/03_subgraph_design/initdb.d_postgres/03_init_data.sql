-- -*- sql-product: postgres; -*-

delete from api.node;
delete from api.design;
delete from api.part;
delete from api.test;

alter sequence core.node_id_seq restart with 1;
alter sequence core.part_id_seq restart with 1;
alter sequence core.test_id_seq restart with 1;

INSERT INTO api.design (id, name, parent_id) VALUES (1, 'CAR', NULL);
INSERT INTO api.design (id, name, parent_id) VALUES (2, 'ENGINE', 1);
INSERT INTO api.design (id, name, parent_id) VALUES (3, 'TRANSMISSION', 1);
INSERT INTO api.design (id, name, parent_id) VALUES (4, 'FUEL', 2);
INSERT INTO api.design (id, name, parent_id) VALUES (5, 'PUMP', 4);
INSERT INTO api.design (id, name, parent_id) VALUES (6, 'EXHAUST', 2);

INSERT INTO api.part (design_id) VALUES (1);
INSERT INTO api.part (design_id) VALUES (2);
INSERT INTO api.part (design_id) VALUES (3);
INSERT INTO api.part (design_id) VALUES (4);
INSERT INTO api.part (design_id) VALUES (5);
INSERT INTO api.part (design_id) VALUES (6);

INSERT INTO api.test (part_id, accepted) VALUES (1, true);
INSERT INTO api.test (part_id, accepted) VALUES (2, true);
INSERT INTO api.test (part_id, accepted) VALUES (3, true);
INSERT INTO api.test (part_id, accepted) VALUES (4, true);
INSERT INTO api.test (part_id, accepted) VALUES (5, true);
INSERT INTO api.test (part_id, accepted) VALUES (6, true);
