-- 2-Role Academic Prototype, Section 8E: FCM device-token registration.
-- The Flutter app registers its FCM token per signed-in user (upsert on the
-- unique token). The push-dispatch Edge Function reads these tokens when a
-- notification row is inserted (Database Webhook on public.notifications).

create or replace function public.register_device_token(
  p_token text,
  p_platform text default 'unknown'
)
returns void
language plpgsql
as $$
declare
  v_user uuid := auth.uid();
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;

  insert into public.device_tokens (user_id, token, platform)
  values (v_user, p_token, p_platform)
  on conflict (token) do update
    set user_id = excluded.user_id,
        platform = excluded.platform,
        updated_at = now();
end;
$$;
