-- Profile avatars: public read; each authenticated user writes only inside
-- their own `{uid}/...` folder. The profile upload stores the resolved
-- public URL on `users.avatar_url`, matching the OAuth-provided avatar
-- convention.

INSERT INTO "storage"."buckets" ("id", "name", "public")
VALUES ('avatars', 'avatars', true)
ON CONFLICT ("id") DO NOTHING;

DROP POLICY IF EXISTS "avatars_bucket_public_read" ON "storage"."objects";
CREATE POLICY "avatars_bucket_public_read" ON "storage"."objects"
  FOR SELECT TO anon, authenticated
  USING ("bucket_id" = 'avatars');

DROP POLICY IF EXISTS "avatars_bucket_insert_own" ON "storage"."objects";
CREATE POLICY "avatars_bucket_insert_own" ON "storage"."objects"
  FOR INSERT TO authenticated
  WITH CHECK (
    "bucket_id" = 'avatars'
    AND ("storage"."foldername"("name"))[1] = "auth"."uid"()::"text"
  );

DROP POLICY IF EXISTS "avatars_bucket_update_own" ON "storage"."objects";
CREATE POLICY "avatars_bucket_update_own" ON "storage"."objects"
  FOR UPDATE TO authenticated
  USING (
    "bucket_id" = 'avatars'
    AND ("storage"."foldername"("name"))[1] = "auth"."uid"()::"text"
  )
  WITH CHECK (
    "bucket_id" = 'avatars'
    AND ("storage"."foldername"("name"))[1] = "auth"."uid"()::"text"
  );

DROP POLICY IF EXISTS "avatars_bucket_delete_own" ON "storage"."objects";
CREATE POLICY "avatars_bucket_delete_own" ON "storage"."objects"
  FOR DELETE TO authenticated
  USING (
    "bucket_id" = 'avatars'
    AND ("storage"."foldername"("name"))[1] = "auth"."uid"()::"text"
  );
