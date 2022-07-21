CREATE TABLE "public"."project" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "name" text NOT NULL, "organization_id" UUID NOT NULL, PRIMARY KEY ("id") , FOREIGN KEY ("organization_id") REFERENCES "public"."organization"("id") ON UPDATE restrict ON DELETE restrict);
CREATE EXTENSION IF NOT EXISTS pgcrypto;
