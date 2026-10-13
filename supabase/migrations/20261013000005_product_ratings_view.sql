-- Card ratings (DESIGN.md §6.1) without PostgREST aggregate selects: this
-- backend's PostgREST does not support inline aggregates in the select
-- parameter (≥ v12, opt-in), so the aggregation lives in a plain SQL view.
-- PostgREST detects the products → product_ratings relationship through the
-- underlying reviews.product_id FK, making `product_ratings(rating_avg,
-- review_count)` an ordinary (cheap) embed. security_invoker keeps the view
-- under the reviews RLS (reviews_public_read), so no privilege widening.

CREATE OR REPLACE VIEW "public"."product_ratings"
WITH (security_invoker = true) AS
SELECT
    "r"."product_id",
    avg("r"."rating")::double precision AS "rating_avg",
    count(*)::integer AS "review_count"
FROM "public"."reviews" "r"
GROUP BY "r"."product_id";

GRANT SELECT ON "public"."product_ratings" TO anon, authenticated;
