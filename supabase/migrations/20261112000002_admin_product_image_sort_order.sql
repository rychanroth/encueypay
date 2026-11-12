-- Admin-added product images all landed with sort_order's default 0, so every
-- image of a product tied for first place: the primary thumbnail was whatever
-- the embed happened to return and a newly appended image never became the
-- last gallery item. Append after the current maximum instead.

CREATE OR REPLACE FUNCTION public.admin_add_product_image(
    p_product_id uuid,
    p_storage_path text
) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
declare
  v_image_id uuid;
begin
  if not public.is_admin() then
    raise exception 'Only admins can add product images';
  end if;
  if not exists (select 1 from public.products where id = p_product_id) then
    raise exception 'Product not found';
  end if;

  insert into public.product_images (product_id, storage_path, sort_order)
  values (
    p_product_id,
    p_storage_path,
    coalesce(
      (
        select max(sort_order) + 1
        from public.product_images
        where product_id = p_product_id
      ),
      0
    )
  )
  returning id into v_image_id;

  perform public.record_admin_audit(
    'admin_add_product_image', 'product', p_product_id,
    jsonb_build_object('storage_path', p_storage_path));
  return v_image_id;
end;
$$;

-- Settle rows that already share a position (created before this fix),
-- oldest first. Groups with distinct sort_order (the seed) are untouched.
with ranked as (
  select
    id,
    (row_number() over (
      partition by product_id
      order by sort_order, created_at, id
    ) - 1)::integer as position,
    count(*) over (partition by product_id, sort_order) as tied_count
  from public.product_images
)
update public.product_images pi
   set sort_order = ranked.position
  from ranked
 where ranked.id = pi.id
   and ranked.tied_count > 1
   and pi.sort_order <> ranked.position;
