-- This helper counter exists only in the temporary transaction exercise.
-- Original case columns and constraints are preserved. It is not part of the P1 design.
ALTER TABLE portfolio."order_line" ADD COLUMN "p3_processed_count" integer NOT NULL DEFAULT 0;
ALTER TABLE portfolio."order_line" ADD CONSTRAINT "p3_count_nonnegative" CHECK ("p3_processed_count" >= 0);

BEGIN ISOLATION LEVEL READ COMMITTED;
UPDATE portfolio."order_line" SET "p3_processed_count" = "p3_processed_count" + 1 WHERE "line_id" IS NOT DISTINCT FROM 5 RETURNING json_build_object('processed_count',"p3_processed_count");
COMMIT;
SELECT "line_id", "p3_processed_count" FROM portfolio."order_line" WHERE "line_id" IS NOT DISTINCT FROM 5;

BEGIN ISOLATION LEVEL READ COMMITTED;
UPDATE portfolio."order_line" SET "p3_processed_count" = "p3_processed_count" + 10 WHERE "line_id" IS NOT DISTINCT FROM 5 RETURNING json_build_object('processed_count',"p3_processed_count");
-- A negative counter deliberately fails its CHECK. Keep psql open so ROLLBACK can run.
\set ON_ERROR_STOP off
\set VERBOSITY verbose
UPDATE portfolio."order_line" SET "p3_processed_count" = -1 WHERE "line_id" IS NOT DISTINCT FROM 5 RETURNING json_build_object('processed_count',"p3_processed_count");
-- A failed transaction rejects another statement until it is rolled back.
SELECT 1;
ROLLBACK;
\set ON_ERROR_STOP on
SELECT "line_id", "p3_processed_count" FROM portfolio."order_line" WHERE "line_id" IS NOT DISTINCT FROM 5;
