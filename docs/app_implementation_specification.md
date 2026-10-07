# EncueYPay — Living Implementation Specification

**Mode:** 2-Role Academic Prototype · **Status:** Living document · **Owner:** Project maintainer
**Source of requirements:** `docs/assignment_specifications.md` (E-Commerce Mobile Application assignment)
**Architectural law:** `docs/architecture-contract.md` (v2.1.0) — unchanged and still fully in force.

This document is the **living alignment record** between the assignment specification and the
codebase. It is updated incrementally: each time a section of the app is refactored or
simplified, its Part B subsection is updated in the same change set — recording (1) the exact
assignment clause being fulfilled, (2) the codebase path/component handling that clause, and
(3) which over-engineered elements were bypassed or hidden for that section.

The app previously implemented a 4-role multi-vendor ecosystem (Customer, Business Owner,
Driver, Admin). Per the prototype decision (2026-10-05) it is simplified to a **2-Role
Academic Prototype** (Customer + Admin Prototype) by **bypassing, hiding, or stubbing**
unnecessary workflows in the UI/navigation layer — **all previously verified customer-facing
code is preserved** and the multi-vendor data model remains intact underneath (Part D).

---

# Part A — Prototype Scope & Role Model

## A.1 Roles

| Role | Status | Entry |
|---|---|---|
| **Customer** | Active — the default and only end-user role | Every new account (Supabase Auth → `users.active_role = 'customer'`) |
| **Admin Prototype** | Active — manages Products, Categories, Orders, System Reports | Server-side promotion only (below) |
| Business Owner | ❌ **Removed (Section 9)** — feature and server paths deleted | — |
| Driver | ❌ **Removed (Section 9)** — feature and server paths deleted | — |

The `user_role` DB enum keeps its legacy values (`business`, `driver`) — a
DB row holding one falls back to the customer surface; no Dart/UI path
mounts anything for them.

The `user_role` DB enum (`customer | business | driver | admin`, migration `20260923000001`)
is **unchanged**; the simplification lives entirely in the navigation layer
(`core/router/navigation_tabs.dart`) plus removed entry points. Role gating inside features
never existed (roles only decide which tab set is mounted).

## A.2 Becoming an admin (prototype operations)

There is no self-service path (by design — the DB trigger `users_block_role_self_change`
blocks it). Promote a user with SQL in the Supabase SQL editor:

```sql
update public.users set active_role = 'admin' where email = '<your-email>';
```

The client picks the role up on the next auth state change (token refresh / re-login);
the GoRouter rebuilds and mounts the admin tab set (`ROUTE-07`).

## A.3 Demo data

`supabase/seed.sql` seeds categories; a prototype business + products are seeded for the
demo (Section 3). Catalog products require an owning business row (`products.business_id`);
the prototype seeds one "Prototype Store" business rather than introducing admin product
creation (Section 2b).

## A.4 What "removed" means

Sections 0–2 originally **bypassed** the obsolete surfaces (hidden in the
navigation layer, code preserved). Per the user mandate change (2026-10-05,
during the two-role pivot): *obsolete code is deleted, not preserved for
legacy compatibility.* Section 9 therefore **removed** the actor features and
their superseded server paths outright; the current product's codebase no
longer carries them. Part C is the removal record.

## A.5 QR payment external prerequisites (Section 6b)

The confirmation paths are fully implemented and inert without credentials — the
simulation path demos the flow locally:

| Prerequisite | Purpose | How obtained |
|---|---|---|
| `QR_ACCOUNT_ID` platform setting | The Bakong account encoded into the generated KHQR | Admin → Platform settings (a personal Bakong ID demos end-to-end) |
| `BAKONG_TOKEN` secret | Bakong `check_transaction_by_md5` confirmation polling | Register at the NBC Bakong developer portal; `supabase secrets set BAKONG_TOKEN=…` |
| `PAYWAY_API_KEY` secret | ABA PayWay webhook HMAC validation (real push confirmation) | ABA merchant account with PayWay enabled; `supabase secrets set PAYWAY_API_KEY=…`; configure the callback URL to `https://<project>.supabase.co/functions/v1/payway-webhook` |
| Deployed Edge Functions | `payway-webhook`, `bakong-check` | `supabase functions deploy` (or `supabase functions serve` locally) |

The KHQR tag layout mirrors the khqr-sdk convention — verify a generated code with a
real banking app before pointing it at a production account.

## A.6 FCM push prerequisites (Section 8E)

The full wiring is implemented and **gracefully inert without configuration** — the
in-app realtime inbox is unaffected, and `registerPushNotifications` no-ops when
Firebase is unconfigured:

| Prerequisite | Purpose |
|---|---|
| Firebase project + `android/app/google-services.json` (+ Gradle `google-services` plugin) and/or `ios/Runner/GoogleService-Info.plist` | `Firebase.initializeApp()` on the platforms (the Gradle plugin step is deliberately NOT pre-wired — the Android build fails without the JSON, so add it together) |
| `supabase secrets set FCM_SERVICE_ACCOUNT='{...service-account json...}'` | The `push-dispatch` Edge Function signs FCM HTTP v1 requests (RS256 JWT → OAuth exchange, implemented in Deno) |
| Database Webhook on `public.notifications` (INSERT) → `https://<project>.supabase.co/functions/v1/push-dispatch` | Delivers every notification row to the dispatcher |
| `supabase functions deploy push-dispatch` | Serves the function |

Flow: domain event → trigger inserts a `notifications` row → webhook → `push-dispatch`
→ recipient's `device_tokens` → FCM HTTP v1. Tokens are registered at startup
(`register_device_token` RPC, user-scoped upsert; refreshed on rotation). Events covered
by existing triggers: order updates, payment statuses (7D), delivery stages, returns;
promotions/coupons events would need new triggers (documented, not built).

---

# Part B — Assignment Clause Mapping

Legend: ✅ covered · 🟡 partial · ❌ gap (documented, not built) · ⛔ intentionally excluded.
"Section N" references the prototype work packages; superseded actor concepts
are covered by the removal record (Part C).

## B.1 Assignment §1 — Core Workflows & User Profiles

| Clause | Status | Fulfilling component(s) | Notes / bypassed elements |
|---|---|---|---|
| End-to-end flow: registration → login → search → category → details → wishlist → cart → quantity → checkout → address → payment → confirmation → history → tracking | 🟡 | `features/auth` (login/sign-up/Google OAuth, `auth_repository_impl.dart`); discovery `features/catalog`; cart `features/cart`; checkout `features/checkout`; orders `features/orders` | Wishlist add/quick-actions wired (Section 6); tracking timeline ✅ (Section 7); card/QR payments ❌ (B.6) |
| User information: ID, Full Name, Gender, DOB, Phone, Email, Photo, Address, Status | 🟡 | `users` table (`20260923000001`); `features/profile/data/repository/profile_repository_impl.dart`; edit = `profile_edit_screen.dart` | Managed: id, name, phone, email (from auth identity), address, account status. Gender / DOB / profile photo ❌ gap (documented) |
| Capabilities: edit profile, change password, manage addresses, order history | 🟡 | Edit profile ✅ (name+phone); addresses ✅ (B.6); history ✅ (`orders_screen.dart`) | Password change ❌ gap — sign-out/re-login only |
| Customer Dashboard | ✅ (Section 8A) | **The Profile tab IS the account overview** (user decision): the profile-embedded `DashboardOverviewPanel` shows the spending hero (total spending **excluding cancelled/returned** + completed/cancelled/total counts), a **combined** Orders panel (recent orders, status-flagged, View all → Orders tab), a wishlist rail of interactive ProductCards (4–6, via composition-root builders), and a Cart summary (count + subtotal + View cart). RPC `get_customer_dashboard` (0044) feeds it; the standalone dashboard screen/route was removed | Overview only — full history lives in the dedicated screens; reviewer/detail duplication avoided |

## B.2 Assignment §2 — Product Discovery & Navigation

| Clause | Status | Fulfilling component(s) | Notes / bypassed elements |
|---|---|---|---|
| Home: featured, new arrivals, best sellers, popular categories, flash sales, special offers, recommended, recently viewed + search bar | 🟡 | `features/catalog/presentation/screens/home_screen.dart`; feed providers `home_feed_providers.dart` | Present: search bar, **category card grid ("Shop by category") + brand logo rail ("Top brands") navigating to a per-item `DiscoveryScreen` (Section 2c)**, approved promotion banners (= special offers), newest products (= new arrivals). ❌ featured / best sellers / flash sales / recommended / recently viewed (documented gaps); popular/rating sorts ❌ (documented). businesses strip removed (Section 9) |
| Categories & subcategories (ID, name, description, image, icon, status) | 🟡 | `categories` table (`20260923000003` + image_url `20261005000030`); `categories_provider.dart`; admin CRUD `categories_admin_screen.dart` (+image URL) | Name ✅, **image ✅ (Section 2c)**; hierarchy: a parent category's discovery page aggregates its own + all sub-category products server-side (`category_id IN (id + children)`); separate sub-category browsing UI deferred (documented). ❌ description/icon/status columns (documented) |
| Search by name/category/brand/price/rating/availability/keyword | 🟡 | `products_screen.dart` + `products_controller.dart` — server-side search matching product name **or brand name** (PostgREST or-filter, Section 2b) + category filter | Name/category/brand ✅; ❌ price/rating/availability (documented) |
| Filters: category, brand, price, rating, stock | 🟡 | Category ✅; brand filter chips ✅ (Section 2b — `brands` table, `products.brand_id`, `fetchBrands`) | Price/rating ❌; stock ⛔ N/A — inventory removed (`20260928000021`, Part D) |
| Sorting: latest, popular, price ↑, price ↓, highest rating | 🟡 | Sort menu: newest / price asc / price desc / name | ❌ popular, ❌ rating (documented) |

## B.3 Assignment §3 — Product Catalog & Details

| Clause | Status | Fulfilling component(s) | Notes / bypassed elements |
|---|---|---|---|
| Product attributes: ID, name, code, category, brand, image, description, price, discount price, stock, rating, status | 🟡 | `products` / `product_variants` / `product_images` / `brands` tables; entity `features/catalog/domain/entities/product.dart` | Covered: id, name, category, **brand (`products.brand_id`, Section 2b)**, images, description, base+variant price, **stock (product-wide, reintroduced Section 2d per user decision — supersedes the old §7 inventory-removal)**, rating (reviews), status. ❌ product code; ⛔ discount price field (discounts are coupon-only, §5); vendor identity removed from the customer UI (vendor model retained underneath; removal record) |
| Multiple images + variants (size/color/model) | ✅ | `add_product_image` / `add_product_variant` / `update_product_variant` / `set_variant_image` RPCs; `product_image_gallery.dart`, `variant_picker_sheet.dart` | Managed historically via Business portal (⛔ hidden); seeded/demo products carry images+variants |
| Detail screen: gallery, name, price, discount, description, rating, stock, variant selector, related products; select variant, quantity, wishlist, add to cart | ✅ | `product_detail_screen.dart`, `product_detail_controller.dart` | Gallery/name/price/description/**rating UI (visual stars, Section 2d)**/**stock availability + Unavailable state (Section 2d)**/variants/related ✅; purchase blocked when disabled or out of stock (client + server); owning-business card removed (Section 9); long-press quick actions wired (Section 6) |

## B.4 Assignment §4 — Wishlist & Shopping Cart

| Clause | Status | Fulfilling component(s) | Notes / bypassed elements |
|---|---|---|---|
| Wishlist: save, remove, transfer to cart | ✅ | `features/wishlist` (`wishlists` + `wishlist_items` tables); **rendered as the shared catalog `ProductCard` grid via a composition-root card builder (Section 6)**: tap → detail, long-press → quick actions (remove from wishlist / add-to-cart via default variant) | Multi-variant add-to-cart from the card uses the **default variant** per user decision; full variant choice lives on the detail screen's picker |
| Cart: add, remove, update quantity, select variants | ✅ | `features/cart` (`cart_screen.dart`, `cart_controller.dart`, RPCs `add_cart_item`/`update_cart_item`/`remove_cart_item`/`clear_cart`) | Per-business group headers removed (Section 9); `CartItemTile` keeps its own quantity controls, now capped at **product-wide stock** (Section 6) |
| Calculations: unit price, quantity, subtotal, discount, shipping fee, grand total | ✅ | Server-authoritative (`coalesce(variant price, product base price)`, Part D); totals rendered display-only | — |
| Validation: quantity + stock before checkout | ✅ | Server validates product/variant/business status **and product-wide stock** at checkout (`create_order_from_cart`, 0032): line quantity > product stock → order rejected; stock deducted atomically under row locks; cancellation restores stock | Quantity capped client-side in the variant sheet (stock cap) |

## B.5 Assignment §5 — Pricing, Coupons & Promotions

| Clause | Status | Fulfilling component(s) | Notes / bypassed elements |
|---|---|---|---|
| Calculation engine: price, qty, subtotal, item discounts, coupon discounts, shipping, mock tax, grand total, instant updates | 🟡 | `create_order_from_cart` + `validate_coupon` RPCs (server-authoritative, exact `numeric`); `checkout_state.dart` preview getters | ✅ all except mock tax (❌ not modeled — documented) |
| Coupons: ID, code, discount type, discount value, min order amount, start/end date, status; validated before applying | ✅ | **Section 5b redesign** (0036): promotion = rule (scope platform/brand/legacy business, mechanic, kill switch) + coupon = instrument (code, **min_order_amount_minor**, **starts_at/ends_at window**, status); `validate_coupon` + `create_order_from_cart` validate the full attribute set (existence → status → derived window → kill switch → scope eligibility → min order on the eligible-scope subtotal); admin creation is one atomic flow (`create_platform_promotion`); per-coupon enable/disable toggles; legacy business-scoped rows still validate | Status/expiration **derived from dates at validation time** — no Edge Function/cron; multi-code-per-promotion deferred (documented) |

## B.6 Assignment §6 — Checkout, Shipping & Payments

| Clause | Status | Fulfilling component(s) | Notes / bypassed elements |
|---|---|---|---|
| Address management: add, edit, delete, set default, select; fields incl. province/district/commune/street/house/postal/geo | ✅ (fields 🟡) | `features/profile`: `addresses_screen.dart` (star action + default badge), `address_edit_screen.dart`, `address_repository_impl.dart`; `addresses.is_default` + one-default-per-user partial unique index (`20261005000038`, `set_default_address` RPC); checkout preselects the default (repository ordering) | Field set 🟡 (coarser than assignment's; no postal/geo); map/geolocation ⛔ not needed per user decision |
| Multi-step checkout: cart review → address → shipping method → payment → coupon → note → summary; validates items/stock/fields | ✅ | **Section 6b wizard**: `checkout_screen.dart` rebuilt as a 7-step Stepper (Cart review, Address, Shipping method — fixed fee from `platform_settings`, Payment, Coupon, Order note → `orders.note`, Summary); per-step continue gated; placement stays the atomic `create_order_from_cart` (now with `p_note`) | Stock validation ✅ (2d); shipping method is a single informational method (fixed fee) — no carrier choice |
| Mock payments: COD, card prototype, QR prototype; statuses pending/paid/failed/refunded/cancelled | 🟡 | **QR (KHQR) replaces bank transfer in the UI (Section 6b)**: order-success screen renders a generated dynamic KHQR (dependency-free EMV builder + `qr_flutter` renderer, user-approved) and follows the payment via realtime; confirmation converges on `confirm_qr_payment` (service-role/admin): **PayWay webhook** (`payway-webhook` Edge Function, HMAC fail-closed) / **Bakong poller** (`bakong-check` + Postgres-computed MD5) / **admin simulate** (`simulate_qr_payment`). COD ✅ (verified on delivery). Legacy bank-transfer rows keep validating | ❌ card prototype (documented); real gateway confirmation needs external credentials (Part A.5); status vocabulary mapped in Part D |

## B.7 Assignment §7 — Order Lifecycle, Tracking & Returns

| Clause | Status | Fulfilling component(s) | Notes / bypassed elements |
|---|---|---|---|
| Order creation: unique ID, user info, items, quantities, unit prices, subtotal, discount, shipping fee, total, address, payment method, date, status | ✅ | `create_order_from_cart` (atomic: order + order_items + payment; **Section 7A: one lifecycle — no fulfillment split**); historical snapshots (Part D) | — |
| Statuses pending→confirmed→processing→packed→shipped→out for delivery→delivered/cancelled/returned + visual timeline | ✅ | **Section 7A: ONE lifecycle** — `orders.status` (`order_status` enum, assignment vocabulary verbatim); `admin_transition_order` advances it (validated forward steps + administrative cancellation); the timeline reads it verbatim; notifications fire on status change; state_history records every transition | Pickup stops **permanently omitted** (user decision); business_orders/deliveries tables dropped |
| Confirmation screen: order ID, date, total, address, payment method, mock ETA | ✅ | `order_placed_screen.dart` | — |
| Order history: filtered Active/Completed/Cancelled/Returned + detail access | ✅ | **Section 7B**: `orders_screen.dart` — status-group chips (All/Active/Completed/Cancelled/Returned, mapped onto the lifecycle) + a date-range filter (`showDateRangePicker`, inclusive end day), **applied server-side** on the paginated query and kept in controller state (refetches page 0; loadMore carries the filter set); detail access unchanged | — |
| Tracking: real-time progress, ETA, courier details, mock tracking number, step indicators | ✅ (scoped, §7C) | Realtime on the `orders` stream (status changes auto-refresh); **`order_status_timeline.dart`** reads the single lifecycle verbatim; mock tracking number (`#<id-prefix>`); **ETA shown only while in transit** (hidden once delivered/cancelled/returned); static **'Delivery managed by EncueYPay'** line stands in for courier details (no courier entity exists) | Full real-time logistics, maps, live location ⛔ (prototype scope, user decision) |
| Cancellation with reasons, dates, status updates | ✅ | `cancel_order` (customer; pending/confirmed) and `admin_transition_order` → cancelled: records `cancelled_at` + `cancellation_reason`, restores product-wide stock; **Section 7D: a verified payment (QR included) flips to refund_required** on cancellation (self-service allowed, recorded — the prototype does not move money); the admin **marks refunded** (→ `refunded` + reference) on cancelled orders, completing the payment vocabulary; payment-status notifications fire (received / refund pending / refund recorded) | Real money movement ⛔ (prototype) |
| Returns: select delivered items, reasons, statuses requested→under review→approved/rejected→completed | ✅ | `return_request_screen.dart`, `request_return` RPC, `return_requests`/`return_items` | Outcome decision made by **admin** (`admin_process_return`, Section 3 — mirrors `process_return` including the refund-required consequence) |
| Ratings & reviews post-delivery + aggregate rating | ✅ | `review_compose_screen.dart` (tappable five-star input → integer, server-verified 1-per-item), `create_review` RPC, aggregate `RatingStars` on detail; **Section 7F review card**: reviewer avatar + name + stars + text + date (`ReviewCard` widget; avatar via the `users` embed) | Reviewer profile screens deferred (no bio column / public-profile RLS — user decision, card is non-interactive) |

## B.8 Assignment §8 — Security, Roles & Administrative Features

| Clause | Status | Fulfilling component(s) | Notes / bypassed elements |
|---|---|---|---|
| Auth, authorization, session management, validation, secure storage; customers restricted to own data | ✅ | Supabase Auth (email + Google OAuth); RLS everywhere; server-authoritative state (Part D); `Failure` taxonomy at repo boundary (DATA-05/06) | — |
| Customer prototype: personalized wishlist, cart, address book, order history | ✅ | `features/wishlist`, `features/cart`, `features/profile` (addresses), `features/orders` | — |
| Admin prototype: manages Products, Categories, Orders, System Reports | ✅ | Categories ✅ (`categories_admin_screen.dart` + RPCs); **Products ✅ (Section 2b: `admin_products_screen.dart` + `admin_product_form_screen.dart`, admin-guarded RPCs `admin_create_product` / `admin_update_product` / `admin_set_product_archived` / `admin_add_product_image`)**; brand management ✅ (`brands_admin_screen.dart`, RLS `brands_admin_*`); **Orders ✅ (Section 3: `admin_orders_screen.dart` + `admin_order_detail_screen.dart`, RPCs `admin_transition_business_order` / `admin_complete_order` / `admin_process_return` + `orders_admin_read`/`payments_admin_read` policies)**; promotions/banner moderation ✅ (`admin_promotions_screen.dart`); audit logs ✅; platform settings ✅; platform report ✅ | Dashboard KPIs ✅ (Section 4, next row); role-application review removed (Section 9) |
| Admin dashboard: total products, orders, customers, sales, low-stock, best-selling, sales trends | ✅ (curated, §8B) | **Hero insight first**: total sales + order/customer counts + a 7-day-vs-prior momentum chip (computed from the trend); an actionable **stock-alerts card** (low-stock/out-of-stock → jump to Products); the 14-day trend bars; top-3 sellers; quick links. Raw counts moved to the Reporting area (8C) | — |
| Notifications (local/in-app + push): order updates, payment statuses, delivery stages, promotions, coupons | ✅ (🟡 promos) | In-app realtime inbox (existing); **Section 8E FCM**: `register_device_token` RPC + `registerPushNotifications` startup hook (guarded — no-ops without Firebase config) + `push-dispatch` Edge Function (FCM HTTP v1, Database Webhook on notifications); payment-status notifications added (7D). Promotion/coupon notification triggers ❌ (documented); external prerequisites in Part A.6 |
| Audit trails: cart additions, wishlist updates, order creation, payment changes, status updates, cancellations | 🟡 | `audit_logs` + `state_history` tables; admin viewer `audit_logs_screen.dart` | Domain events (order/payment/delivery/return states) logged server-side; cart/wishlist additions not audited (🟡 documented) |
| Reporting: KPI summary (orders, completed, cancelled, sales, AOV, best-sellers, low-stock, top categories, purchase frequency) | ✅ (Section 8C) | **Reports & Analytics screen** (`/admin/dashboard/reports`, `get_sales_report` RPC 0045): admin selects an inclusive date range (`showDateRangePicker`); KPI summary + best sellers + top categories + purchase frequency for the range, low-stock as a current snapshot; spending excludes cancelled/returned (consistent with 8A) | Daily/weekly/monthly buckets ❌ (range-based instead, documented) |
| Error handling & UI states: loading, success, error banners, empty states, retry | ✅ | `core/domain/failures.dart` + `StreamResult`; `AsyncValue` patterns, empty/retry states across screens | — |

---

# Part C — Removal Record

The original simplification ledger documented *bypassed* elements (hidden,
code preserved). Per the mandate change (A.4), Section 9 **removed** the
obsolete actor infrastructure. What remains load-bearing is listed last.

## Removed with their features (Section 9a)

| Removed | Where it lived |
|---|---|
| Business Owner portal (onboarding, product/variant/image CRUD, fulfillment, analytics, transactions) | `features/business/**`; `business_*` branch files |
| Driver portal (available deliveries, my deliveries, pickup stops, transactions) | `features/delivery/**`; `driver_*` branch files |
| Role applications (apply flow + admin review) | `features/role_applications/**`; `/profile/apply` route; admin review screen/controller |
| Business storefront discovery (detail screen/controller, `Business`/`BusinessDetail` entities, `homeBusinesses` feed) | `features/catalog` |
| Business-side screens in shared features (banner submission, returns processing) | `features/promotions`, `features/returns` |
| Their route-name constants | `core/router/app_routes.dart` |

## Removed server-side (Section 9b, migration `20261005000039`)

| Removed | Superseded by |
|---|---|
| `transition_business_order` | `admin_transition_business_order` (Section 3) |
| Business product/variant/image CRUD (`create_product`, `update_product`, `set_product_archived`, `add/update_product_variant`, `set_variant_image`, `add_product_image`), `create_business`, `update_my_business` | `admin_*` equivalents (Section 2b) |
| `get_business_analytics`, `get_business_transactions`, `get_driver_transactions` | `get_admin_kpis` / `get_platform_report` (Section 4) |
| Driver pipeline (`accept_delivery`, `reject_delivery`, `complete_pickup_stop`, `start_delivery`, `mark_delivered`) | `admin_transition_order` (Section 7A — one validated machine) |
| `process_return` (business authority) | `admin_process_return` (Section 3) |
| `submit_banner` (business submission), `create_coupon_promotion` (business coupons) | `admin_create_banner` (Section 9), admin coupon creation (§5b) |
| `is_driver()` + `driver_can_view_*` helpers and all driver/owner RLS policies | admin read/write policies (same migration) |

## Removed server-side (Section 7A, migration `20261005000040`)

| Removed | Superseded by |
|---|---|
| `business_orders`, `deliveries`, `pickup_stops` tables (+ `business_order_status` / `delivery_status` / `pickup_stop_status` enums) | **`orders.status`** — the single lifecycle (assignment vocabulary) |
| `admin_transition_business_order`, `admin_ship_order`, `admin_complete_order` | `admin_transition_order` (one validated machine) |
| `notify_on_*` per-family notification triggers | `orders_notify_status` + `payments_notify_status` on `orders`/`payments` |
| Business-owner "new order" notification insert | customer notifications only |
| `pending_applications` in the platform report | applications flow removed |

## Applied server-side (DB bridge, migrations `20261008000001`–`20261008000006`)

The frozen 4-role baseline (`20261007000000_frozen_baseline.sql`, the consolidated
pre-pivot dump) predates Sections 9b/7A and everything from 2b–8E. The bridge
series applies the database side of this specification on top of it (the earlier
`2026100500*` migration files were consolidated away and no longer exist):

| Migration | Content |
|---|---|
| `…000001_drop_deprecated_tables` | Drops `business_orders` / `deliveries` / `pickup_stops` / `role_applications` + their enums; pivots `order_items.business_order_id` → `order_id` (direct orders FK); re-attaches the `auth.users` signup trigger lost in the baseline dump |
| `…000002_drop_deprecated_routines` | Drops the 9b function/policy inventory + `platform_settings.driver_commission_percent` + the promotions banner/window columns; strict `discount_value > 0` restored |
| `…000003_schema_evolution` | `brands`, `banners` tables; `products.stock`/`brand_id`; `order_status` enum + `orders.status`/`note`/`cancelled_at`/`cancellation_reason`; `payments` QR columns + method `'qr'`; `coupons` min-order/windows (absorbs `expires_at`); `addresses.is_default`; `promotions.active`/`brand_id` + scope `'brand'`; `platform_settings.qr_account_id` + singleton row; realtime `payments` |
| `…000004_rls_authority_storage` | Admin `is_admin()` read/ALL policies (mandatory for PostgREST embeds); public products-any-status/brands/banners reads; promotions RPC-only; storage buckets `product_images` / `promo_assets` / `payment_proofs` + object policies |
| `…000005_triggers` | `orders_record_state` (state_history), `orders_notify_status` + `payments_notify_status` (customer notifications); brands touch trigger |
| `…000006_rpcs_2role` | Full §6 RPC inventory with the §4 stock/coupon/QR/return chokepoints; narrow admin UPDATE policies on `orders`/`payments`/`return_requests` |

Two documented authority nuances: `create_order_from_cart` and `validate_coupon`
run as SECURITY DEFINER (stock deduction and promotions reads cannot run
INVOKER as a customer without unsafe policies); admin mutations audit via the
definer-only `record_admin_audit` helper. Full lifecycle verified end-to-end by
`supabase/testing/smoke_test_2role.sql`.

## Kept — load-bearing in the current workflow (not legacy)

* `businesses` + `products.business_id` — catalog ownership, pricing, checkout
  splits, admin product management (a businesses row is still required; the
  prototype store is created via the seed snippet, Part A.3).
* The legacy `business` promotion scope and `payment_method='bank_transfer'`
  values remain valid on the wire for historical rows; no creation path exists.
* The `user_role` DB enum keeps its four values; unknown/legacy roles fall
  back to the customer surface.

---

# Part D — System Model Still in Force

Condensed from the previous as-built specification; these invariants are unchanged by the
prototype simplification (full data-model reference: `supabase/migrations/`).

- **One Flutter app, Supabase-only backend** (Auth, PostgREST, RPCs, Storage, Realtime).
  Server authority for authorization, prices, discounts, coupon validity, state transitions,
  order creation. Client state is never trusted (§35/§50–53 of the old spec).
- **Catalog ownership retained:** `products.business_id` → `businesses` (pricing,
  availability, admin product management); cart lines embed variants→products→businesses.
  Orders no longer split per business (Section 7A): one Order → OrderItems → one Payment.
  Vendor discovery is absent from the customer UI (Section 9).
- **Availability & stock (Section 2d):** purchase requires variant active + product
  active + business active + product stock ≥ quantity. Stock is **product-wide**
  (purchasing any variant deducts the product's counter; variants carry no stock).
  Disabled (archived) products of active businesses remain **visible** to customers,
  rendered "Unavailable" with purchase blocked client- and server-side.
- **Coupon scopes (Section 2d/5b):** `platform` (cart-wide), `brand` (the brand's cart
  lines; discount distributed across participating businesses proportionally), and
  legacy `business` rows (still validate; creation path bypassed with the portal).
- **Promotion/coupon/banner model (Section 5b):** promotion = discount rule
  (scope + mechanic + `active` kill switch); coupon = redemption instrument
  (code, min order amount, start/end window, status → assignment §5 set);
  banner = advertising surface (separate `banners` table, optional promotion
  reference, moderation status). Expiration is **derived at validation time**;
  no scheduled jobs.
- **Money:** exact `numeric` server-side; decimal display, no float arithmetic (§22).
- **Historical integrity:** order items, shipping address, applied coupon amounts, and
  purchased prices are snapshots; later catalog/profile/coupon edits never rewrite history
  (§17–19, §26, §55).
- **Checkout atomicity:** `create_order_from_cart` commits order + business orders + items +
  payment + delivery + pickup stops together or not at all (§51).
- **ONE order lifecycle (Section 7A):** `orders.status` uses the assignment's own
  vocabulary (`pending → confirmed → processing → packed → shipped → out_for_delivery
  → delivered`, plus `cancelled`/`returned`). No derivation — the admin transitions it,
  the timeline reads it, notifications fire on it, `state_history` records every step.
  The multi-business split (`business_orders`/`deliveries`/`pickup_stops`) was removed
  with the marketplace design; `order_items` reference the order directly (with a
  business-name snapshot for display). Payment remains its own flow (pending → paid →
  refunded), which is standard e-commerce separation of progress vs money.
- **Payment vocabulary mapping:** `pending→Pending, transaction_verified→Paid,
  refund_required/refunded→Refunded/Refund Required`; QR confirmation is
  webhook/poller-driven (Section 6b), COD verifies on delivery.
- **Status ownership (Section 6b):** the four state families stay on their four
  entities — admin manages business-order (accept/reject → preparing → ready),
  delivery (`admin_ship_order` → delivery_in_progress, then `admin_complete_order`
  → delivered) and pickup-stop states; payment states are system/webhook-driven.
  Ship-before-complete keeps the customer timeline's full progression.
- **Realtime scope:** only `notifications`, `orders`, `deliveries`, `business_orders` are in
  the `supabase_realtime` publication; every subscription's initial snapshot is skipped
  (§31, §54).
- **No local persistence** (CORE-05): the only client-side storage is the theme mode.

---

# Part E — As-Built Deltas

Implementation decisions that extend or supersede the model above. Migrations reference
`supabase/migrations/`. (Carried from the previous specification; prototype deltas are
appended as sections land.)

## Section 2b — Brands + admin catalog management (`20261005000029`)

* `brands` table (`product_status` vocabulary, unique name) + `products.brand_id`
  (nullable FK, ON DELETE SET NULL). RLS: public reads active brands, admin reads all
  and writes (`brands_admin_*`), mirroring the categories policy shape.
* Admin product authority: `admin_create_product` / `admin_update_product` /
  `admin_set_product_archived` / `admin_add_product_image` — explicit `is_admin()`
  guards, audit-logged, mirroring the business-portal RPC shapes. `admin_create_product`
  auto-creates a 'Default' variant (null price → tracks base price) so carts stay
  strictly variant-based; the original owner-guarded RPCs were removed (Section 9).
* `products_admin_read` lets the admin list see archived products;
  `product_images_admin_all` + storage `product_images_admin_write/delete` give admin
  full image-row and binary management under the same `{business_id}/...` path
  convention.
* Brand writes are direct PostgREST CRUD through the RLS policies (no RPC layer) —
  same pattern as platform settings.
* Catalog read path: `fetchBrands()`, brand filter (`brand_id` eq), brand-name search
  (PostgREST or-filter with `,()` sanitized from user input), and `brands(name)` embed
  for the detail screen's brand line.

## Section 2c — Discovery images + card navigation (`20261005000030`)

* `brands.image_url` / `categories.image_url` — full public URLs (banner
  convention, 0024); no new Storage plumbing. `create_category` /
  `rename_category` re-created with an optional `p_image_url`.
* Home discovery navigation redesigned from chip strips to **category card
  grid + brand logo rail** (assignment §2 "intuitive navigation"), both
  tapping into a per-item `DiscoveryScreen` (`/home/discovery?kind=&id=`,
  hero header + the shared `ProductGrid` extracted from the products
  screen per PRES-06). Filter chips remain in the products screen's filter
  bar.
* Parent categories aggregate their sub-category products server-side
  (`category_id IN (id + children)`); no separate sub-category browsing
  level (deferred, documented in Part B §2).

## Section 2d — Stock, availability visibility, brand coupons (`20261005000031` + `0032`)

* Stock reintroduced **product-wide** (`products.stock`): `create_order_from_cart`
  locks product rows (`FOR UPDATE`), rejects any line exceeding stock, deducts on
  commit; `cancel_order` restores from historical order items. Variants carry no
  stock (user decision — supersedes the old §7 inventory removal).
* Visibility: `products_public_read` replaces `products_public_read_active` —
  products of active businesses stay listable while archived ("Unavailable"
  badge, purchase blocked client- and server-side).
* Coupon scope `brand`: `promotions.brand_id` + enum value; `validate_coupon`
  previews brand-scope discounts; `create_order_from_cart` distributes the brand
  discount across participating businesses proportionally (rounding remainder to
  the largest share). `create_platform_promotion` gains `p_brand_id`
  (null → platform scope); the admin promotions dialog gains a scope picker.
* Admin product RPCs manage stock (`p_stock`); the product form gains a stock
  field and **searchable pickers** (bottom-sheet search over fetched options)
  for store/category/brand; the list shows stock.
* Customer UI: product-wide stock line + Unavailable state on the detail screen,
  availability badges on cards, quantity capped to stock in the variant sheet,
  and a `RatingStars` visual aggregate (assignment §3).

## Section 3 — Admin fulfillment (`20261005000033`)

* `admin_transition_business_order` — the owner state machine with explicit
  admin authority; rejection restores product-wide stock and applies the
  refund-required payment consequence when every part is dead.
* `admin_complete_order` — one-shot completion mirroring
  `complete_pickup_stop` + `mark_delivered`: pending parts must be decided
  first; all stops + business parts complete with timestamps, the delivery
  delivers, COD verifies. Existing notification triggers keep the customer
  informed at every step.
* `admin_process_return` — `process_return` under admin authority (same
  payment consequences).
* `orders_admin_read` / `payments_admin_read` select policies for oversight;
  the customer-scoped policies are untouched. Mutations run through the
  admin Orders tab (`/admin/orders`, list + fulfillment detail view).
* Prototype ops: businesses need an auth-user owner — `supabase/seed.sql`
  documents the store + admin promotion snippets (Part A.2/A.3).

## Section 4 — Admin dashboard KPIs (`20261005000034`)

* `get_admin_kpis` (is_admin via SQL-function default invoker rights guarded
  by the definer `is_admin()`; stable, security definer): total/active
  products, total orders, total customers, total sales, low-stock (≤5) and
  out-of-stock counts, top-5 best sellers by units, and a 14-day sales
  trend (zero-filled via `generate_series`).
* Dashboard renders KPI cards, best-seller list, and a plain-Flutter bar
  chart (DEPS-03: no charting package). The pending-applications mention
  was dropped from the dashboard (applications flow removed, Section 9).

## Section 5 — Customer dashboard (`20261005000035` + `features/dashboard`)

* `get_customer_dashboard` — one jsonb aggregation per sign-in user
  (active orders, wishlist count, cart-item quantity, total spending, 5
  most-recent orders with a coarse server-side state bucket); security
  definer, auth.uid()-scoped, so no per-table read policies are relied on.
* New `features/dashboard` (GLOBAL-05 approved): entity `DashboardSummary`
  / `DashboardOrder`, repository (interface + impl, DATA-05/07), `@riverpod`
  controller, screen with stat cards + recent orders; route
  `/profile/dashboard` (profile branch) + customer-gated Profile entry.
  Cross-tab navigation via `AppRoutes.orderDetail` (ROUTE-02).

## Section 6 — Product Card quick actions (`features/catalog` + composition root)

* The reusable **ProductCard** is shared by Home, Discovery, and Wishlist;
  tap always navigates to product detail, long-press opens a quick-actions
  sheet: add/remove wishlist + add/remove cart, reflecting current state.
* The wishlist/cart logic is **injected**, never imported by features
  (ARCH-04): `ProductCardActions` (catalog contract) is built by
  `core/router/product_card_actions.dart` (composition root, ROUTE-08),
  which watches the cart/wishlist controllers and surfaces `Failure`
  snackbars; screens take an `actionsBuilder`, the wishlist screen a
  `cardBuilder` (item → ProductCard mapping in the profile branch).
* Add-to-cart uses the product's **default variant** (`products` embed now
  carries variant ids; `Product.defaultVariantId`); remove-from-cart drops
  every cart line of the product.
* Cart keeps its independent `CartItemTile` (per user decision — no
  refactor into ProductCard); its quantity stepper is now capped at the
  product-wide stock carried on the cart line; the server re-validates at
  checkout.
* Wishlist rows carry stock/status/default-variant so the composition root
  can rebuild full cards; `CartItemTile`'s click still opens detail (no
  variant preservation needed — the detail sheet owns variant choice).

## Section 7 — Tracking timeline (`features/orders`)

* `OrderStatusTimeline` (presentation-only): maps the derived customer
  status onto the assignment's step vocabulary (Pending → Confirmed →
  Processing → Packed → Shipped → Out for delivery → Delivered);
  cancelled/refund orders render a notice instead of the stepper.
* Mock tracking number (order-id prefix) + mock ETA (created + 3 days)
  on the order detail header — no data-model changes.

## Section 5b — Coupon/banner redesign (`20261005000036`)

* Convention enforced: **promotion = discount rule** (scope, mechanic,
  `active` kill switch), **coupon = redemption instrument** (code,
  `min_order_amount_minor`, `starts_at`/`ends_at`, status — the assignment
  §5 set), **banner = advertising surface** (separate `banners` table with
  optional promotion reference, display window, moderation status).
* Expiration/status **derived at validation time** in `validate_coupon` +
  `create_order_from_cart` (window, kill switch, scope eligibility, min
  order on the eligible-scope subtotal). No Edge Function/cron.
* `create_platform_promotion` atomically creates the rule + its first
  coupon; legacy `expires_at` migrated to `ends_at`; banner rows migrated
  into `banners`; banner columns and the discount-check exemption dropped
  (strict `discount_value > 0` restored).
* Admin Promotions tab: Coupons section (atomic creation incl. min-order +
  date pickers + scope picker; per-coupon enable/disable) + Banners section
  (moderation). Business screen lists its submitted banners from the new
  table; `submit_banner`/`moderate_banner` re-pointed (portal bypassed but
  runtime-correct). Home strip reads approved in-window banners.

## Section 6b — Checkout, shipping & payments (`20261005000037` + `0038`)

* Multi-step checkout wizard (assignment §6 sequence incl. shipping-method
  and order-note steps); `orders.note` plumbed through placement.
* `addresses.is_default` + one-default-per-user index + `set_default_address`
  RPC; checkout preselects the default.
* Status clarification: `admin_ship_order` splits completion so the customer
  timeline demos Shipped → Out for delivery → Delivered; ownership documented
  (Part D).
* QR payment: `payment_method += 'qr'`, `payments.qr_payload/qr_md5/
  transaction_reference`, `platform_settings.qr_account_id`; KHQR generated
  client-side (EMV builder, `qr_flutter` rendering — user-approved dep),
  registered via `register_qr_payment` (MD5 computed server-side);
  `confirm_qr_payment` (service-role/admin) converges webhook + poller +
  `simulate_qr_payment` (admin); `payments` added to the realtime
  publication. Edge Functions: `payway-webhook` (HMAC fail-closed),
  `bakong-check` (Bakong check_transaction_by_md5). Bank transfer removed
  from the checkout UI; legacy rows still validate.

## Section 7A — single order lifecycle (`20261005000040`)

* `order_status` enum on `orders.status` (assignment vocabulary);
  `cancelled_at`/`cancellation_reason` recorded on cancellation; state
  history + customer notification via triggers on the order.
* `order_items.order_id` (business-name snapshot kept); checkout RPC no
  longer writes fulfillment tables; `cancel_order` (pending/confirmed)
  restores stock + records reason; `admin_transition_order` (validated
  forward steps; administrative cancellation with reason); `request_return`
  and `create_review` re-pointed to the direct order reference;
  `get_customer_dashboard` buckets from `orders.status`.
* Dropped: `business_orders` / `deliveries` / `pickup_stops` + their enums,
  per-family notification triggers, `driver_commission_percent` setting.
* Realtime note: `orders` remains a publication member; the dropped tables
  leave it automatically.

## Realtime

* `notifications`, `orders`, `deliveries`, `business_orders` are members of the
  `supabase_realtime` publication (`20260927000027`) — without it, every
  `postgres_changes` subscription errors after its initial fetch.
* Every stream subscription also emits an initial snapshot of current rows — clients skip
  it and refetch only on real change events.

## Catalog and product lifecycle

* Inventory tracking removed (`20260928000021`): no stock columns, no reservation, no
  manual correction. Availability is status-based: variant active + product active +
  business active → purchasable.
* Variant lifecycle RPCs: `add_product_variant` (`20260926000022`, duplicate-name guarded)
  and `update_product_variant` (`20260927000025`).
* Product image management (`20260928000020`): `add_product_image` (server-computed
  `sort_order` append) plus a Storage DELETE policy; `owns_product_image_object` fixed the
  upload policy's column-shadowing bug. Variant images: `product_variants.image_path` +
  `set_variant_image` under the business-owned `product_images/` path convention.

## Policies and authorization

* Security-definer policy helpers terminate policy recursion: returns (`20260927000019`),
  `is_admin()`/`is_driver()` (`20260927000019`), business-order driver checks and owner
  updates (`20260927000023`), driver delivery visibility (`20260928000028`).
* `cancel_order` and `mark_delivered` run as security definer (self-authorizing) so
  customer cancellation and the COD payment flip are not dropped by missing row policies.
* Table grants for `anon`/`authenticated` maintained explicitly (`20260926000015`);
  `users` gained admin read (`20260927000017`) and backfill (`20260927000018`).

## Pricing and promotions

* The server prices every line as `coalesce(variant price, product base price)`; cart,
  checkout summary, and placed order all use it; product grids display the minimum
  effective variant price.
* Banner rows are exempt from the `discount_value > 0` check (`20260927000024`) — banners
  carry no discount; `banner_image_path` stores the full public Storage URL, read paths
  accept URLs and bare paths.

## Profit history

* `business_orders.completed_at` (pickup completion) and `deliveries.delivered_at`
  (delivery) book when profit is realized (`20260927000026`);
  `get_business_transactions(p_day)` / `get_driver_transactions(p_day)` serve the per-day
  transaction tabs. (Both portals are ⛔ bypassed — L-01/L-02 — but the booking logic is
  mirrored by the admin fulfillment RPCs, §3.)

---

## Update protocol

Each prototype section (0–8) updates **its own** Part B subsection and any Part C ledger
entries in the same change set, runs the Definition of Done (`architecture-contract.md`
§12: analyze clean, codegen regenerated, import fences, error mapping, no scope creep),
and only then does the next section begin. No simultaneous multi-section refactors.
