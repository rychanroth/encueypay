-- Category sales cover the whole subtree (bug report 2026-11-17).
--
-- A sale scoped to a category matched only products whose `category_id` is
-- exactly that category, so nothing under its sub-categories was discounted —
-- even though browsing that category already lists the sub-category products
-- (catalog_repository_impl expands `parent_id`). Category scope now means
-- "this category and everything under it".
--
-- The taxonomy is 2-level (§2c), but the helper is written recursively so a
-- future depth change does not silently break pricing. `union` dedupes, which
-- also makes a (prevented) cycle terminate instead of looping.
--
-- Both sides of the app need the same answer:
--   * the server prices with `best_sale_price_minor()` (cart, checkout, order);
--   * the client renders struck prices from `active_sales`, so the view exposes
--     the covered category ids as `category_ids` (SQL stays the single source
--     of truth — the client never walks the tree itself).

create or replace function public.category_subtree(p_category_id uuid)
returns setof uuid
    language sql stable
    set search_path to 'public'
    as $$
  with recursive tree(id) as (
    select p_category_id
    union
    select c.id
      from public.categories c
      join tree t on c.parent_id = t.id
  )
  select id from tree;
$$;

comment on function public.category_subtree(uuid) is
  'The category and every descendant. Category-scoped sales and category '
  'browsing both cover the whole subtree.';

-- -------------------------------------------------------------- live sales
-- `category_ids` is a new column, so the view cannot be CREATE OR REPLACEd.
-- Nothing depends on it except the pricing function below, which is recreated
-- afterwards (SQL bodies are validated at creation time).
drop view if exists public.active_sales;

create view public.active_sales with (security_invoker = true) as
  select id, created_by, scope, brand_id, category_id, name, description,
         discount_type, discount_value, active, starts_at, ends_at,
         created_at, updated_at,
         case
           when scope = 'category' and category_id is not null
             then (
               select array_agg(cid)
                 from public.category_subtree(category_id) cid
             )
           else null
         end as category_ids
    from public.sales
   where active
     and archived_at is null
     and (starts_at is null or starts_at <= now())
     and (ends_at is null or ends_at >= now());

grant select on public.active_sales to anon, authenticated;

-- ----------------------------------------------------------- price helper
create or replace function public.best_sale_price_minor(
  p_product_id uuid,
  p_price_minor bigint
) returns bigint
  language sql stable
  set search_path to 'public'
  as $$
  select least(
    p_price_minor,
    coalesce(min(case s.discount_type
      when 'percent' then p_price_minor - (p_price_minor * s.discount_value) / 100
      else greatest(p_price_minor - s.discount_value, 0)
    end), p_price_minor))
    from public.active_sales s
   where s.scope = 'platform'
      or (s.scope = 'brand'
          and s.brand_id = (select p.brand_id from public.products p
                             where p.id = p_product_id))
      or (s.scope = 'category'
          and (select p.category_id from public.products p
                where p.id = p_product_id)
              in (select public.category_subtree(s.category_id)));
$$;
