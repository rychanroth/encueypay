-- Product image management for business owners (spec §5.2, §48).
--
-- Table-level CRUD on public.product_images was already granted to owners
-- (product_images_owner_all, business portal). Three storage/SQL gaps closed
-- here:
-- 1. object UPLOADS were broken: product_images_owner_write's unqualified
--    `name` bound to businesses.name inside its EXISTS, so every upload was
--    rejected with 403 — fixed with a parameterized ownership helper;
-- 2. object DELETION had no policy — removing an image reference left the
--    binary orphaned in the bucket forever;
-- 3. a server-computed insertion point for sort_order — the client would
--    otherwise have to read-then-write the next position (racy) or maintain
--    counters across devices.

-- Ownership of an object path: first folder segment must be the id of a
-- business owned by the caller. As a function so the object's `name` is
-- passed as a parameter — inside a policy qual over `businesses b`, a bare
-- `name` binds to `businesses.name` (the store's name column), which is
-- exactly the bug that made product_images_owner_write (0008) reject every
-- upload with 403.
create or replace function public.owns_product_image_object(p_object_name text)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.businesses b
    where b.id::text = (storage.foldername(p_object_name))[1]
      and b.owner_id = auth.uid()
  );
$$;

-- Fix 0008's upload policy (unqualified `name` resolved to businesses.name,
-- so no upload ever passed) and add the missing delete path.
drop policy if exists "product_images_owner_write" on storage.objects;
create policy "product_images_owner_write" on storage.objects
  for insert with check (
    bucket_id = 'product_images'
    and public.owns_product_image_object(name)
  );

drop policy if exists "product_images_owner_delete" on storage.objects;
create policy "product_images_owner_delete" on storage.objects
  for delete using (
    bucket_id = 'product_images'
    and public.owns_product_image_object(name)
  );

-- Registers an uploaded image against its product. SECURITY INVOKER on
-- purpose: product_images_owner_all gates the insert; the explicit ownership
-- check just makes the error message actionable.
create or replace function public.add_product_image(
  p_product_id uuid,
  p_storage_path text
)
returns uuid
language plpgsql
as $$
declare
  v_user uuid := auth.uid();
  v_image_id uuid;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  if not exists (
    select 1
    from public.products p
    join public.businesses b on b.id = p.business_id
    where p.id = p_product_id and b.owner_id = v_user
  ) then
    raise exception 'Product not found';
  end if;

  insert into public.product_images (product_id, storage_path, sort_order)
  values (
    p_product_id,
    p_storage_path,
    coalesce((
      select max(sort_order) + 1
      from public.product_images
      where product_id = p_product_id
    ), 0)
  )
  returning id into v_image_id;
  return v_image_id;
end;
$$;
