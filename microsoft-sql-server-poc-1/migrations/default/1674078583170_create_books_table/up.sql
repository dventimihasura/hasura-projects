CREATE TABLE books (
  id              INT           NOT NULL    IDENTITY    PRIMARY KEY,
  title           VARCHAR(100)  NOT NULL,
  primary_author  VARCHAR(100),
);
