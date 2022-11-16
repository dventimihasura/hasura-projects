CREATE TABLE "public"."table_3" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "name" Text NOT NULL, "parent_id" uuid NOT NULL, PRIMARY KEY ("id") , FOREIGN KEY ("parent_id") REFERENCES "public"."table_2"("id") ON UPDATE restrict ON DELETE restrict);
CREATE EXTENSION IF NOT EXISTS pgcrypto;
