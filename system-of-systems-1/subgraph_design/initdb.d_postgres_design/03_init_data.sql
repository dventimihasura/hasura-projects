-- -*- sql-product: postgres; -*-

INSERT INTO api.design (id, name, parent_id) VALUES (1, 'Alice', NULL);
INSERT INTO api.design (id, name, parent_id) VALUES (2, 'Bob', 1);
INSERT INTO api.design (id, name, parent_id) VALUES (3, 'Carol', 1);
INSERT INTO api.design (id, name, parent_id) VALUES (4, 'David', 2);
INSERT INTO api.design (id, name, parent_id) VALUES (5, 'Eve', 4);
INSERT INTO api.design (id, name, parent_id) VALUES (6, 'Frank', 2);

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

