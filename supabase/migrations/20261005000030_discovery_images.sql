-- 2-Role Academic Prototype, Section 2c (living spec Part B §2).
--
-- Discovery images: assignment §2 gives categories "Description, Image,
-- Icon, Status" and discovery needs visually intuitive navigation. Both
-- brands and categories gain an image_url column storing a FULL public URL
-- — the same convention promotion banners already use (0024: the read path
-- accepts URLs directly; no new Storage plumbing for the prototype).
--
-- Category writes go through the guarded RPCs (0012), so create_category /
-- rename_category are re-created with an optional image parameter. Brand
-- writes are direct PostgREST CRUD through the brands_admin_* RLS policies
-- (0029), so no brand RPC is needed.

alter table public.brands add column image_url text;
alter table public.categories add column image_url text;

create or replace function public.create_category(
  p_name text,
  p_parent_id uuid default null,
  p_image_url text default null
)
returns uuid
language plpgsql
as $$
declare
  v_id uuid;
begin
  if not public.is_admin() then
    raise exception 'Only admins can manage categories';
  end if;
  if coalesce(trim(p_name), '') = '' then
    raise exception 'Category name is required';
  end if;
  insert into public.categories (name, parent_id, image_url)
  values (trim(p_name), p_parent_id, p_image_url)
  returning id into v_id;
  return v_id;
end;
$$;

create or replace function public.rename_category(
  p_category_id uuid,
  p_name text,
  p_image_url text default null
)
returns void
language plpgsql
as $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can manage categories';
  end if;
  update public.categories
  set name = trim(p_name),
      image_url = p_image_url
  where id = p_category_id;
  if not found then
    raise exception 'Category not found';
  end if;
end;
$$;
