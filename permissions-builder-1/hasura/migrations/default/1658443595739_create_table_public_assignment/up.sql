CREATE TABLE "public"."assignment" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "user_id" uuid NOT NULL, "project_id" uuid NOT NULL, PRIMARY KEY ("id") , FOREIGN KEY ("user_id") REFERENCES "public"."user"("id") ON UPDATE restrict ON DELETE restrict, FOREIGN KEY ("project_id") REFERENCES "public"."project"("id") ON UPDATE restrict ON DELETE restrict);
CREATE EXTENSION IF NOT EXISTS pgcrypto;
