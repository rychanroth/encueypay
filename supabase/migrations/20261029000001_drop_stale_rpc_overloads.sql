-- Drop stale RPC overloads that PostgREST cannot disambiguate.
--
-- CREATE OR REPLACE FUNCTION with a *different* signature does not replace
-- the old function — it adds a second overload (the signature is the
-- function's identity). PostgREST then rejects calls that are valid for
-- both: its candidate check only requires every provided argument name to
-- exist and the remaining ones to have defaults, so it cannot pick the
-- exact-match overload and fails with "Could not choose the best candidate
-- function".
--
-- 1. admin_create_banner: the 20261028000004 restatement (display-only, no
--    target parameters) left the 20261016000001 7-arg version alive; every
--    admin_create_banner call then failed at resolution time. The stale
--    version also still names the banner target columns that migration
--    dropped.
-- 2. admin_update_product: the 20261028000003 variant-list overload left
--    the pre-variant 7-arg version alive. Today's only caller always sends
--    p_variants, so this one is latent — but any future call omitting it
--    would fail the same way.
DROP FUNCTION IF EXISTS public.admin_create_banner(
  p_name text, p_description text, p_image_url text, p_ends_at timestamptz,
  p_target_kind text, p_target_id uuid, p_target_name text);
DROP FUNCTION IF EXISTS public.admin_update_product(
  p_product_id uuid, p_category_id uuid, p_name text, p_description text,
  p_base_price_minor bigint, p_brand_id uuid, p_stock integer);
