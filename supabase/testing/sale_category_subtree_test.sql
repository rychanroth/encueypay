-- Category-scope sale covers the subtree (migration 20261117000005).
--   bash supabase/testing/run_migrations.sh
--   psql -h /tmp -p 55432 -U postgres -d encueypay_test \
--     -v ON_ERROR_STOP=1 -f supabase/testing/sale_category_subtree_test.sql
--
-- Guards the report that a category-wide sale skipped sub-category items.

insert into auth.users (id, email, raw_user_meta_data) values
  ('aaaaaaaa-1111-2222-3333-444444444444', 'subadm@test.dev',
   '{"full_name":"Subtree Admin"}');
update public.users set active_role = 'admin'
 where id = 'aaaaaaaa-1111-2222-3333-444444444444';

-- parent -> child -> (sibling under the same parent) + an unrelated category
insert into public.categories (id, name, parent_id) values
  ('bbbbbbbb-1111-2222-3333-444444444444', 'Parent', null),
  ('bbbbbbbb-2222-3333-4444-555555555555', 'Child', 'bbbbbbbb-1111-2222-3333-444444444444'),
  ('bbbbbbbb-3333-4444-5555-666666666666', 'Sibling', 'bbbbbbbb-1111-2222-3333-444444444444'),
  ('bbbbbbbb-4444-5555-6666-777777777777', 'Unrelated', null);

insert into public.products (id, category_id, name, base_price_minor, stock) values
  ('cccccccc-1111-2222-3333-444444444444', 'bbbbbbbb-1111-2222-3333-444444444444',
   'Parent product', 1000, 10),
  ('cccccccc-2222-3333-4444-555555555555', 'bbbbbbbb-2222-3333-4444-555555555555',
   'Child product', 1000, 10),
  ('cccccccc-3333-4444-5555-666666666666', 'bbbbbbbb-3333-4444-5555-666666666666',
   'Sibling product', 1000, 10),
  ('cccccccc-4444-5555-6666-777777777777', 'bbbbbbbb-4444-5555-6666-777777777777',
   'Unrelated product', 1000, 10);

insert into public.sales (id, created_by, scope, category_id, name,
                          discount_type, discount_value, active)
values ('dddddddd-1111-2222-3333-444444444444',
        'aaaaaaaa-1111-2222-3333-444444444444', 'category',
        'bbbbbbbb-1111-2222-3333-444444444444', 'Parent 20%',
        'percent', 20, true);

-- --------------------------------------------------------- subtree helper
DO $$ BEGIN
  assert (select count(*) from public.category_subtree(
            'bbbbbbbb-1111-2222-3333-444444444444')) = 3,
    'subtree = the category plus both children';
  assert (select count(*) from public.category_subtree(
            'bbbbbbbb-2222-3333-4444-555555555555')) = 1,
    'a leaf subtree is just itself';
  assert not exists (select 1 from public.category_subtree(
            'bbbbbbbb-1111-2222-3333-444444444444')
            where category_subtree = 'bbbbbbbb-4444-5555-6666-777777777777'),
    'an unrelated category is outside the subtree';
END $$;

-- ------------------------------------------------------------ live view
DO $$
declare
  v_ids uuid[];
begin
  select category_ids into v_ids
    from public.active_sales
   where id = 'dddddddd-1111-2222-3333-444444444444';

  assert v_ids is not null, 'category sale exposes its covered ids';
  assert array_length(v_ids, 1) = 3, 'covered ids = subtree, got '
    || coalesce(array_length(v_ids, 1)::text, '<null>');
  assert 'bbbbbbbb-2222-3333-4444-555555555555'::uuid = any(v_ids),
    'the client can match a child product';
end $$;

-- -------------------------------------------------------------- pricing
DO $$ BEGIN
  assert public.best_sale_price_minor(
           'cccccccc-1111-2222-3333-444444444444', 1000) = 800,
    'the category itself is discounted';
  assert public.best_sale_price_minor(
           'cccccccc-2222-3333-4444-555555555555', 1000) = 800,
    'a sub-category product is discounted (the reported bug)';
  assert public.best_sale_price_minor(
           'cccccccc-3333-4444-5555-666666666666', 1000) = 800,
    'a sibling under the same parent is discounted';
  assert public.best_sale_price_minor(
           'cccccccc-4444-5555-6666-777777777777', 1000) = 1000,
    'an unrelated category is untouched';
END $$;

-- Disabling the sale restores list prices everywhere in the subtree.
update public.sales set active = false
 where id = 'dddddddd-1111-2222-3333-444444444444';

DO $$ BEGIN
  assert public.best_sale_price_minor(
           'cccccccc-2222-3333-4444-555555555555', 1000) = 1000,
    'a disabled sale prices nothing';
END $$;

\echo '=== SALE CATEGORY SUBTREE VERIFIED ==='
