-- Faithful QR reproduction for banks whose consumer KHQRs carry a generic
-- account ID (e.g. ACLEDA's 'khqr@aclb'): the official KHQR SDK's
-- IndividualInfo supports optional accountInformation (sub-tag 01, the
-- customer's account number) and acquiringBank (sub-tag 02) alongside the
-- bakongAccountID (sub-tag 00). Storing all three lets the generated
-- dynamic QR mirror exactly what the receiver's own bank app encodes.
ALTER TABLE "public"."platform_settings"
  ADD COLUMN "qr_account_information" "text" DEFAULT '' NOT NULL,
  ADD COLUMN "qr_acquiring_bank" "text" DEFAULT '' NOT NULL;
