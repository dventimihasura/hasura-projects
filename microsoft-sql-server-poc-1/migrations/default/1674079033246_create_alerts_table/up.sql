drop table alerts;

CREATE TABLE alerts (
  id              INT           NOT NULL    IDENTITY    PRIMARY KEY,
  title           VARCHAR(100)  NULL,
  description     VARCHAR(100)  NULL
);
