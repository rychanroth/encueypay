-- Structured Cambodian administrative hierarchy on saved addresses.
--
-- The address book previously had only free-text line1/line2/city. These
-- nullable code columns let the app preselect the official 2025
-- province/district/commune/village pickers and keep that structure when an
-- address is edited. The existing line1/line2/city fields remain the
-- snapshot consumed by checkout/orders (city is composed from the selected
-- hierarchy on save), so no order-table or RPC changes are needed.
--
-- Existing rows stay valid with null codes.

ALTER TABLE public.addresses
  ADD COLUMN province_code text,
  ADD COLUMN district_code text,
  ADD COLUMN commune_code text,
  ADD COLUMN village_code text,
  ADD COLUMN latitude double precision,
  ADD COLUMN longitude double precision;

ALTER TABLE public.addresses
  ADD CONSTRAINT addresses_latitude_check
    CHECK (latitude IS NULL OR latitude BETWEEN -90 AND 90),
  ADD CONSTRAINT addresses_longitude_check
    CHECK (longitude IS NULL OR longitude BETWEEN -180 AND 180);

COMMENT ON COLUMN public.addresses.province_code IS
  'Official 2025 province/capital code (assets/geo).';
COMMENT ON COLUMN public.addresses.district_code IS
  'Official 2025 district/khan/krong code.';
COMMENT ON COLUMN public.addresses.commune_code IS
  'Official 2025 commune/sangkat code.';
COMMENT ON COLUMN public.addresses.village_code IS
  'Official 2025 village/phum code.';
