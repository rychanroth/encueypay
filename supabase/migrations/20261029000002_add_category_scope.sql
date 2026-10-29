-- Sales gain a category scope (the promotions→sales rename follows in
-- 20261029000003). ALTER TYPE ... ADD VALUE cannot share a transaction with
-- statements that then use the value on older Postgres, so it lives alone.
ALTER TYPE public.promotion_scope ADD VALUE IF NOT EXISTS 'category';
