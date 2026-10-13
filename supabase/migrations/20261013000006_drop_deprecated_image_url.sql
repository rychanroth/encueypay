-- Drops the deprecated brands/categories image_url columns (DESIGN.md
-- imagery pipeline, migration 20261013000001). The columns were created by
-- the M3 schema evolution (20261008000003) mirroring the "store the full
-- URL" idea, but nothing ever wrote or read them — the imagery pipeline
-- uses image_path (bare storage path or http passthrough, resolved at the
-- repository boundary). Safe: zero data (always NULL), zero consumers.

ALTER TABLE "public"."brands" DROP COLUMN IF EXISTS "image_url";
ALTER TABLE "public"."categories" DROP COLUMN IF EXISTS "image_url";
