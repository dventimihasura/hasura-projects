CREATE TABLE "ch01"."owner" ("id" serial NOT NULL, "created_at" timestamptz NOT NULL DEFAULT now(), "updated_at" timestamptz NOT NULL DEFAULT now(), "name" text NOT NULL, "restaurants_id" uuid NOT NULL, PRIMARY KEY ("id") );
CREATE OR REPLACE FUNCTION "ch01"."set_current_timestamp_updated_at"()
RETURNS TRIGGER AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER "set_ch01_owner_updated_at"
BEFORE UPDATE ON "ch01"."owner"
FOR EACH ROW
EXECUTE PROCEDURE "ch01"."set_current_timestamp_updated_at"();
COMMENT ON TRIGGER "set_ch01_owner_updated_at" ON "ch01"."owner" 
IS 'trigger to set value of column "updated_at" to current timestamp on row update';
