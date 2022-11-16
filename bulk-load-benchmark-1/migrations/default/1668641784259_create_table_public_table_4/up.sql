CREATE TABLE "public"."table_4" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "name" text NOT NULL, "parent_id" UUID NOT NULL, PRIMARY KEY ("id") , FOREIGN KEY ("parent_id") REFERENCES "public"."table_3"("id") ON UPDATE restrict ON DELETE restrict);
CREATE EXTENSION IF NOT EXISTS pgcrypto;
