-- Category hierarchy authoring (Section 2c — 2-level taxonomy). The read
-- side (parent aggregation in the product query) already worked; this
-- completes the write side: rename_category gains parent assignment
-- (NULL = promote to top-level), and both category RPCs enforce the
-- documented 2-level maximum — a parent must itself be top-level.

CREATE OR REPLACE FUNCTION "public"."create_category"(
    p_name text,
    p_parent_id uuid DEFAULT NULL,
    p_image_path text DEFAULT NULL
) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
declare
  v_category_id uuid;
begin
  if not public.is_admin() then
    raise exception 'Only admins can create categories';
  end if;
  if p_parent_id is not null then
    if not exists (
      select 1 from public.categories where id = p_parent_id
    ) then
      raise exception 'Parent category not found';
    end if;
    -- 2-level hierarchy (§2c): the parent must itself be top-level.
    if exists (
      select 1 from public.categories where id = p_parent_id and parent_id is not null
    ) then
      raise exception 'Subcategories cannot nest deeper than two levels';
    end if;
  end if;

  insert into public.categories (name, parent_id, image_path)
  values (p_name, p_parent_id, p_image_path)
  returning id into v_category_id;

  perform public.record_admin_audit(
    'create_category', 'category', v_category_id, jsonb_build_object('name', p_name));
  return v_category_id;
end;
$$;

CREATE OR REPLACE FUNCTION "public"."rename_category"(
    p_category_id uuid,
    p_name text,
    p_image_path text DEFAULT NULL,
    p_parent_id uuid DEFAULT NULL
) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can rename categories';
  end if;
  if p_parent_id is not null then
    if p_parent_id = p_category_id then
      raise exception 'A category cannot be its own parent';
    end if;
    if not exists (
      select 1 from public.categories where id = p_parent_id
    ) then
      raise exception 'Parent category not found';
    end if;
    -- 2-level hierarchy (§2c): the new parent must be top-level.
    if exists (
      select 1 from public.categories
      where id = p_parent_id and parent_id is not null
    ) then
      raise exception 'Subcategories cannot nest deeper than two levels';
    end if;
  end if;

  update public.categories
     set name = p_name,
         image_path = coalesce(p_image_path, image_path),
         parent_id = p_parent_id
   where id = p_category_id;
  if not found then
    raise exception 'Category not found';
  end if;

  perform public.record_admin_audit(
    'rename_category', 'category', p_category_id,
    jsonb_build_object('name', p_name, 'parent_id', p_parent_id));
end;
$$;
