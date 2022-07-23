CREATE TABLE "public"."timesheet" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "assignment_id" UUID NOT NULL, "hours" integer NOT NULL, PRIMARY KEY ("id") , FOREIGN KEY ("assignment_id") REFERENCES "public"."assignment"("id") ON UPDATE restrict ON DELETE restrict);
CREATE EXTENSION IF NOT EXISTS pgcrypto;
