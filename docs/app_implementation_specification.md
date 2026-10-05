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
| Business Owner | ⛔ **Bypassed (Section 1)** — code preserved, UI unreachable | — |
| Driver | ⛔ **Bypassed (Section 1)** — code preserved, UI unreachable | — |

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
creation (see ledger L-08).

## A.4 What "bypassed" means

Bypassed code is **kept in the repository, compiling, and analyzed** — it is only made
unreachable from the UI/navigation layer. Nothing was deleted; every Part C ledger entry
records how to restore an element.

---

# Part B — Assignment Clause Mapping

Legend: ✅ covered · 🟡 partial · ❌ gap (documented, not built) · ⛔ bypassed by prototype decision.
"→ §N" = resolved by prototype Section N of the simplification plan.

## B.1 Assignment §1 — Core Workflows & User Profiles

| Clause | Status | Fulfilling component(s) | Notes / bypassed elements |
|---|---|---|---|
| End-to-end flow: registration → login → search → category → details → wishlist → cart → quantity → checkout → address → payment → confirmation → history → tracking | 🟡 | `features/auth` (login/sign-up/Google OAuth, `auth_repository_impl.dart`); discovery `features/catalog`; cart `features/cart`; checkout `features/checkout`; orders `features/orders` | Wishlist **add** not wired (→ §6); tracking is status-line only (→ §7); card/QR payments ❌ (B.6) |
| User information: ID, Full Name, Gender, DOB, Phone, Email, Photo, Address, Status | 🟡 | `users` table (`20260923000001`); `features/profile/data/repository/profile_repository_impl.dart`; edit = `profile_edit_screen.dart` | Managed: id, name, phone, email (from auth identity), address, account status. Gender / DOB / profile photo ❌ gap (documented) |
| Capabilities: edit profile, change password, manage addresses, order history | 🟡 | Edit profile ✅ (name+phone); addresses ✅ (B.6); history ✅ (`orders_screen.dart`) | Password change ❌ gap — sign-out/re-login only |
| Customer Dashboard: recent orders, active orders, wishlist count, cart items, total spending | ✅ | `features/dashboard` (ARCH-02 three-layer feature; `get_customer_dashboard` RPC, 0035, auth.uid()-scoped server-side aggregation): `dashboard_screen.dart` with stat cards + recent-orders list (tap → order detail); mounted at `/profile/dashboard` with a Profile entry (customer-gated) | Coarse order state (active/completed/cancelled) derived server-side; the fine-grained lifecycle stays in features/orders |

## B.2 Assignment §2 — Product Discovery & Navigation

| Clause | Status | Fulfilling component(s) | Notes / bypassed elements |
|---|---|---|---|
| Home: featured, new arrivals, best sellers, popular categories, flash sales, special offers, recommended, recently viewed + search bar | 🟡 | `features/catalog/presentation/screens/home_screen.dart`; feed providers `home_feed_providers.dart` | Present: search bar, **category card grid ("Shop by category") + brand logo rail ("Top brands") navigating to a per-item `DiscoveryScreen` (Section 2c)**, approved promotion banners (= special offers), newest products (= new arrivals). ❌ featured / best sellers / flash sales / recommended / recently viewed (documented gaps); popular/rating sorts ❌ (documented). ⛔ businesses strip hidden (Section 2, L-05) |
| Categories & subcategories (ID, name, description, image, icon, status) | 🟡 | `categories` table (`20260923000003` + image_url `20261005000030`); `categories_provider.dart`; admin CRUD `categories_admin_screen.dart` (+image URL) | Name ✅, **image ✅ (Section 2c)**; hierarchy: a parent category's discovery page aggregates its own + all sub-category products server-side (`category_id IN (id + children)`); separate sub-category browsing UI deferred (documented). ❌ description/icon/status columns (documented) |
| Search by name/category/brand/price/rating/availability/keyword | 🟡 | `products_screen.dart` + `products_controller.dart` — server-side search matching product name **or brand name** (PostgREST or-filter, Section 2b) + category filter | Name/category/brand ✅; ❌ price/rating/availability (documented) |
| Filters: category, brand, price, rating, stock | 🟡 | Category ✅; brand filter chips ✅ (Section 2b — `brands` table, `products.brand_id`, `fetchBrands`) | Price/rating ❌; stock ⛔ N/A — inventory removed (`20260928000021`, Part D) |
| Sorting: latest, popular, price ↑, price ↓, highest rating | 🟡 | Sort menu: newest / price asc / price desc / name | ❌ popular, ❌ rating (documented) |

## B.3 Assignment §3 — Product Catalog & Details

| Clause | Status | Fulfilling component(s) | Notes / bypassed elements |
|---|---|---|---|
| Product attributes: ID, name, code, category, brand, image, description, price, discount price, stock, rating, status | 🟡 | `products` / `product_variants` / `product_images` / `brands` tables; entity `features/catalog/domain/entities/product.dart` | Covered: id, name, category, **brand (`products.brand_id`, Section 2b)**, images, description, base+variant price, **stock (product-wide, reintroduced Section 2d per user decision — supersedes the old §7 inventory-removal)**, rating (reviews), status. ❌ product code; ⛔ discount price field (discounts are coupon-only, §5); ⛔ vendor identity bypassed (vendor model retained underneath, L-04) |
| Multiple images + variants (size/color/model) | ✅ | `add_product_image` / `add_product_variant` / `update_product_variant` / `set_variant_image` RPCs; `product_image_gallery.dart`, `variant_picker_sheet.dart` | Managed historically via Business portal (⛔ hidden); seeded/demo products carry images+variants |
| Detail screen: gallery, name, price, discount, description, rating, stock, variant selector, related products; select variant, quantity, wishlist, add to cart | 🟡 → ✅ §6 | `product_detail_screen.dart`, `product_detail_controller.dart` | Gallery/name/price/description/**rating UI (visual stars, Section 2d)**/**stock availability + Unavailable state (Section 2d)**/variants/related ✅; purchase blocked when disabled or out of stock (client + server); owning-business card ⛔ hidden (Section 2, L-04); wishlist add wired in §6 |

## B.4 Assignment §4 — Wishlist & Shopping Cart

| Clause | Status | Fulfilling component(s) | Notes / bypassed elements |
|---|---|---|---|
| Wishlist: save, remove, transfer to cart | ✅ | `features/wishlist` (`wishlists` + `wishlist_items` tables); **rendered as the shared catalog `ProductCard` grid via a composition-root card builder (Section 6)**: tap → detail, long-press → quick actions (remove from wishlist / add-to-cart via default variant) | Multi-variant add-to-cart from the card uses the **default variant** per user decision; full variant choice lives on the detail screen's picker |
| Cart: add, remove, update quantity, select variants | ✅ | `features/cart` (`cart_screen.dart`, `cart_controller.dart`, RPCs `add_cart_item`/`update_cart_item`/`remove_cart_item`/`clear_cart`) | Per-business group headers ⛔ **flattened (Section 2, L-06)**; `CartItemTile` keeps its own quantity controls, now capped at **product-wide stock** (Section 6) |
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
| Address management: add, edit, delete, set default, select; fields incl. province/district/commune/street/house/postal/geo | 🟡 | `features/profile`: `addresses_screen.dart`, `address_edit_screen.dart`, `address_repository_impl.dart`; `addresses` table (`20260923000002`: label, recipient, phone, line1, line2, city) | Add/edit/delete/select ✅; **set-default ❌** (no `is_default` column); field set 🟡 (coarser than assignment's; no postal/geo) |
| Multi-step checkout: cart review → address → shipping method → payment → coupon → note → summary; validates items/stock/fields | 🟡 | `features/checkout/presentation/screens/checkout_screen.dart` — single-page covering address, method, coupon, summary; atomic `create_order_from_cart` validates everything server-side | Sequence collapsed to one page (documented 🟡); separate shipping-method step ❌ (delivery fee from `platform_settings`); order note ❌; stock validation ⛔ N/A |
| Mock payments: COD, card prototype, QR prototype; statuses pending/paid/failed/refunded/cancelled | 🟡 | COD ✅ (`mark_delivered`-equivalent flips payment → verified); manual bank transfer ✅ (proof upload → auto-verified, §20.2 of old spec); payment lifecycle `pending / awaiting_payment_verification / transaction_verified / refund_required / refunded` | ❌ card prototype, ❌ QR prototype (documented); status vocabulary mapped in Part D |

## B.7 Assignment §7 — Order Lifecycle, Tracking & Returns

| Clause | Status | Fulfilling component(s) | Notes / bypassed elements |
|---|---|---|---|
| Order creation: unique ID, user info, items, quantities, unit prices, subtotal, discount, shipping fee, total, address, payment method, date, status | ✅ | `create_order_from_cart` (atomic: order + business_orders + order_items + payment + delivery + pickup stops); historical snapshots (Part D) | — |
| Statuses pending→confirmed→processing→packed→shipped→out for delivery→delivered/cancelled/returned + visual timeline | 🟡 → ✅ §7 | `business_order_status` / `delivery_status` enums; derived `CustomerOrderStatus` (`features/orders/domain/entities/order.dart:38`) | Derived statuses map to assignment vocabulary (mapping table in Part D); step-progress timeline UI → §7; **fulfillment driven by admin (Section 3)**: `admin_transition_business_order` (accept/reject → preparing → ready) + `admin_complete_order` (stops + parts complete, delivery delivered, COD verified — mirroring the owner/driver RPC effects so notifications and the customer's derived status keep working) |
| Confirmation screen: order ID, date, total, address, payment method, mock ETA | ✅ | `order_placed_screen.dart` | — |
| Order history: filtered Active/Completed/Cancelled/Returned + detail access | 🟡 | `orders_screen.dart` (paginated; derived status chips), `order_detail_screen.dart` | Status chips ✅; dedicated filtered tabs ❌ (documented) |
| Tracking: real-time progress, ETA, courier details, mock tracking number, step indicators | ✅ | Realtime on `orders`/`deliveries` streams (initial-snapshot-skipping, Part D); **`order_status_timeline.dart` (Section 7)**: step-progress indicator mapping derivedStatus → assignment vocabulary (Part D), embedded on the order detail screen with a mock tracking number (`#<id-prefix>`) and mock ETA (created + 3 days, presentation-only) | Courier details ⛔ (no drivers — admin-fulfilled) |
| Cancellation with reasons, dates, status updates | ✅ | `cancel_order` RPC (only while every business part is `pending`; records `rejection_reason = 'Cancelled by customer'` + state history) | — |
| Returns: select delivered items, reasons, statuses requested→under review→approved/rejected→completed | ✅ | `return_request_screen.dart`, `request_return` RPC, `return_requests`/`return_items` | Outcome decision made by **admin** (`admin_process_return`, Section 3 — mirrors `process_return` including the refund-required consequence) |
| Ratings & reviews post-delivery + aggregate rating | ✅ | `review_compose_screen.dart`, `create_review` RPC (1 per order item, server-verified), aggregate rating on product detail | Unlocked by delivered status — reachable once admin fulfillment (§3) completes orders |

## B.8 Assignment §8 — Security, Roles & Administrative Features

| Clause | Status | Fulfilling component(s) | Notes / bypassed elements |
|---|---|---|---|
| Auth, authorization, session management, validation, secure storage; customers restricted to own data | ✅ | Supabase Auth (email + Google OAuth); RLS everywhere; server-authoritative state (Part D); `Failure` taxonomy at repo boundary (DATA-05/06) | — |
| Customer prototype: personalized wishlist, cart, address book, order history | ✅ | `features/wishlist`, `features/cart`, `features/profile` (addresses), `features/orders` | — |
| Admin prototype: manages Products, Categories, Orders, System Reports | 🟡 → ✅ §4 | Categories ✅ (`categories_admin_screen.dart` + RPCs); **Products ✅ (Section 2b: `admin_products_screen.dart` + `admin_product_form_screen.dart`, admin-guarded RPCs `admin_create_product` / `admin_update_product` / `admin_set_product_archived` / `admin_add_product_image`)**; brand management ✅ (`brands_admin_screen.dart`, RLS `brands_admin_*`); **Orders ✅ (Section 3: `admin_orders_screen.dart` + `admin_order_detail_screen.dart`, RPCs `admin_transition_business_order` / `admin_complete_order` / `admin_process_return` + `orders_admin_read`/`payments_admin_read` policies)**; promotions/banner moderation ✅ (`admin_promotions_screen.dart`); audit logs ✅; platform settings ✅; platform report ✅ | KPI reports → §4; ⛔ role-application review hidden (L-03) |
| Admin dashboard: total products, orders, customers, sales, low-stock, best-selling, sales trends | 🟡 → ✅ §4 | `get_admin_kpis` (Section 4, `20261005000034`) on `admin_dashboard_screen.dart`: KPI cards (total products / orders / customers / total sales), **low-stock (≤5) + out-of-stock counts (unblocked by 2d stock)**, best-sellers list (top 5 by units), and a 14-day sales-trend bar chart (plain Flutter, no charting dependency) alongside the existing `get_platform_report` row | — |
| Notifications (local/in-app): order updates, payment statuses, delivery stages, promotions, coupons | 🟡 | `features/notifications` (realtime inbox); DB triggers notify customers on business-order created/status, delivery status, return status | ❌ FCM push (device_tokens unused); ❌ promotion/coupon notifications (documented) |
| Audit trails: cart additions, wishlist updates, order creation, payment changes, status updates, cancellations | 🟡 | `audit_logs` + `state_history` tables; admin viewer `audit_logs_screen.dart` | Domain events (order/payment/delivery/return states) logged server-side; cart/wishlist additions not audited (🟡 documented) |
| Reporting: daily/weekly/monthly KPIs (orders, completed, cancelled, sales, AOV, best-sellers, low-stock, top categories, purchase frequency) | 🟡 → §4 | `get_platform_report`; §4 adds `get_admin_kpis` (best-selling, trend) | Low-stock ⛔; top categories / purchase frequency ❌ (documented) |
| Error handling & UI states: loading, success, error banners, empty states, retry | ✅ | `core/domain/failures.dart` + `StreamResult`; `AsyncValue` patterns, empty/retry states across screens | — |

---

# Part C — Simplification Ledger

Every over-engineered element bypassed/hidden by the 2-Role prototype, how, and how to restore.
Bypassed code is **not deleted** — it remains compiling and analyzed.

| # | Element | Where it lives | How bypassed | Restore |
|---|---|---|---|---|
| L-01 | **Business Owner portal** (onboarding wizard, product/variant/image CRUD, order fulfillment, analytics, transactions, returns processing, coupon/banner creation) | `features/business/**`; branches `business_*_branch.dart` | **Hidden in Section 1:** removed from `tabsForRole` — branch files no longer imported by `core/router/navigation_tabs.dart`, which falls back to the customer tab set for `business`/`driver` roles | Re-add business case to `tabsForRole` + `defaultRouteForRole` in `core/router/navigation_tabs.dart` |
| L-02 | **Driver portal** (available deliveries, my deliveries, pickup stops, transactions) | `features/delivery/**`; branches `driver_*_branch.dart` | **Hidden in Section 1:** same mechanism as L-01 | Same as L-01 |
| L-03 | **Role applications** (apply to become business/driver + admin review) | `features/role_applications/**`; `/profile/apply` route in `profile_branch.dart`; profile row in `profile_screen.dart`; `/admin/applications` branch | **Hidden in Section 1:** `/profile/apply` GoRoute removed from `profile_branch.dart`, the profile ListTile removed from `profile_screen.dart`, and the admin Applications tab removed from `_adminTabs` (no applications can be submitted once the apply UI is gone). `AppRoutes.roleApplication` const retained (dormant) | Re-add route, profile row, admin tab |
| L-04 | **Business discovery chrome** (home businesses strip, business storefront screen + route, product-detail business card) | `features/catalog/.../home_screen.dart`, `business_detail_screen.dart`, `product_detail_screen.dart` | **Hidden in Section 2:** strip + `_BusinessesStrip`/`_BusinessPlaceholder` widgets removed from `home_screen.dart`; `business/:id` GoRoute removed from `home_branch.dart`; product-detail vendor card removed. `businesses` data model + joins retained | Re-add widgets + `business/:id` nested route in `home_branch.dart` |
| L-05 | Home "businesses" feed provider | `features/catalog/.../home_feed_providers.dart` (`homeBusinesses`) | **Hidden in Section 2:** provider retained, no longer rendered by `home_screen.dart` | Render again on `home_screen.dart` |
| L-06 | Cart per-business grouping | `features/cart/.../cart_screen.dart` | **Hidden in Section 2:** group headers/subtotals flattened to a single list (`_group()` deleted); server totals unchanged | Restore grouping layout |
| L-07 | Driver fulfillment pipeline (atomic driver claims, pickup-stop gating, `start_delivery`, `mark_delivered`, driver earnings) | `features/delivery/**`; RPCs `accept_delivery`, `reject_delivery`, `complete_pickup_stop`, `start_delivery`, `mark_delivered`, `get_driver_transactions`; `deliveries`/`pickup_stops` rows still created at checkout | **Superseded in Section 3** by administrative fulfillment: `admin_transition_business_order` + `admin_complete_order` mirror the old effects (statuses, stop completion, COD verification, notifications, audit); `admin_process_return` replaces business return decisions | Re-mount driver portal (L-02) and use the driver RPCs again |
| L-08 | ~~Admin product **creation**~~ → **Built in Section 2b** (user decision, 2026-10-05). Admin creates/edits products (name, description, base price, category, brand, images) under a designated store business via the admin-guarded RPCs of `20261005000029`; created products auto-receive a 'Default' variant (null price tracks base price) keeping carts strictly variant-based. Variant *editing* stays business-portal-only — seeded products demonstrate variants (documented partial) | `features/admin/presentation/screens/admin_products_screen.dart`, `admin_product_form_screen.dart`, `brands_admin_screen.dart` | — | n/a — built |
| L-09 | Business-order ownership rules (business owner transitions own orders; business processes own returns) | `transition_business_order`, `process_return` RPCs | Superseded **for the prototype** by admin-guarded equivalents (§3); original RPCs remain in force | Re-mount business portal |

Not bypassed but related: **stock/inventory** was removed before the prototype
decision (migration `20260928000021`) and **reintroduced in Section 2d**
(`20261005000031`, product-wide) per user decision — the assignment mandates
stock quantity and pre-checkout stock validation, and Low-Stock reporting
(§8) is unblocked again. Ledger entries unaffected.

---

# Part D — System Model Still in Force

Condensed from the previous as-built specification; these invariants are unchanged by the
prototype simplification (full data-model reference: `supabase/migrations/`).

- **One Flutter app, Supabase-only backend** (Auth, PostgREST, RPCs, Storage, Realtime).
  Server authority for authorization, prices, discounts, coupon validity, state transitions,
  order creation. Client state is never trusted (§35/§50–53 of the old spec).
- **Multi-vendor data model retained underneath:** `products.business_id` → `businesses`;
  cart lines embed variants→products→businesses; one Order → one BusinessOrder per
  participating business → OrderItems; one Payment per order; one Delivery per order with
  one PickupStop per BusinessOrder. The prototype merely hides vendor *discovery* (L-04/L-06)
  and fulfills administratively (L-07).
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
- **Derived order status (customer view):** `pending | accepted | preparing | ready |
  outForDelivery | delivered | cancelled | refundRequired`, derived from business-order,
  payment, and delivery states — no overall order state machine (§10, §52).
  Assignment-vocabulary mapping used by the tracking timeline (§7):
  `pending→Pending, accepted→Confirmed, preparing→Processing, ready→Packed/Shipped,
  outForDelivery→Out for Delivery, delivered→Delivered`.
- **Payment vocabulary mapping:** `pending→Pending, transaction_verified→Paid,
  refund_required/refunded→Refunded/Refund Required`; card/QR prototypes ❌ (B.6).
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
  strictly variant-based; the original owner-guarded RPCs remain untouched (L-09).
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
  was dropped from the dashboard (applications flow hidden, L-03).

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
