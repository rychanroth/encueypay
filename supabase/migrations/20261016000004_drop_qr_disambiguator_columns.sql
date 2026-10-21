-- Simplification follow-up to 20261016000003: the account pieces are no
-- longer stored as separate columns — platform_settings.qr_account_id
-- holds the admin's pasted value VERBATIM (bare `alias@bank` or the full
-- bank-QR payload), decoded at payment time by
-- core extractBakongAccountParts. No personal data lives in code; the
-- runtime value is admin-entered configuration only.
ALTER TABLE "public"."platform_settings"
  DROP COLUMN "qr_account_information",
  DROP COLUMN "qr_acquiring_bank";
