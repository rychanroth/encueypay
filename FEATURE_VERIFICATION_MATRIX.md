# FEATURE VERIFICATION MATRIX

**Audit date:** 2026-10-07 · **Auditor:** Lead Flutter Architect & QA (automated trace)
**Spec sources:** `docs/assignment_specification.md` (ASSIGN §) × `docs/app_implementation_specification.md` (SPEC B.x — living 2-role spec)
**Codebase scope:** `alib/features/**`, `lib/core/**` @ branch `impl/mvp` (HEAD `731ad86`)

**Trace procedure (Step 3):**
1. Route registration = `GoRoute(name: AppRoutes.*)` in `core/router/branches/*` + `app_router.dart` (30 routes ↔ 30 screen files, 1:1).
2. Tab destinations = `StatefulShellBranch` entries in `navigation_tabs.dart` (4 customer + 6 admin) rendered by `app_shell.dart` (ROUTE-05) — these are reachable **without** a `pushNamed` call.
3. Navigation triggers = all `pushNamed`/`goNamed` call sites outside the router (multiline-tolerant grep) + embedded sheet/card interactions.
4. Data binding = every screen watches `@riverpod` codegen controllers (28 files) → repository interfaces → Supabase RPCs/PostgREST. Mock-data grep across `lib/`: **zero hits**.
5. Import fences verified: no feature→feature imports; `core→features` only via `core/router` (composition root).

**Legend:** `[WIRED]` route + trigger + live binding · `[ORPHANED / UNLINKED]` code exists, no route/trigger · `[MISSING]` specified, no code.

---

## §1 — Core Workflows, Auth, Account (SPEC B.1)

| Feature / Requirement | Spec Source Clause | Physical File Paths (UI / State / Data) | Route Registered? | Navigation Trigger Exists? | Wiring Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Registration + email/password sign-in | ASSIGN §1, §8 / SPEC B.8 | `features/auth/presentation/screens/login_screen.dart` / `controllers/login_controller.dart` / `data/repository/auth_repository_impl.dart` | Yes (`/login`, overlay) | Yes (router redirect on unauth + sign-out) | **[WIRED]** |
| Google OAuth sign-in | ASSIGN §8 / SPEC B.8, DEPS-04 | same as above (`signInWithGoogle` in repo) | Yes (`/login`) | Yes (OAuth button) | **[WIRED]** |
| Role detection & per-role shell | SPEC A.1, ROUTE-07 / B.8 | `auth/domain/entities/user_role.dart` / `auth/presentation/controllers/auth_controller.dart` / `core/router/navigation_tabs.dart` + `app_shell.dart` | Yes (`tabsForRole` → branch list) | Yes (NavigationBar destinations) | **[WIRED]** |
| Customer account overview (dashboard) | ASSIGN §1 / SPEC B.1 (8A) | `features/dashboard/presentation/widgets/dashboard_overview_panel.dart` / `controllers/dashboard_controller.dart` / `data/repository/dashboard_repository_impl.dart` (`get_customer_dashboard`) | Yes (embedded in `/profile`) | Yes (Profile tab, customer-gated) | **[WIRED]** |
| Profile edit (name, phone) | ASSIGN §1 / SPEC B.1 | `features/profile/presentation/screens/profile_edit_screen.dart` / `controllers/profile_controller.dart` / `data/repository/profile_repository_impl.dart` | Yes (`/profile/edit`) | Yes (Profile → Edit profile) | **[WIRED]** |
| Address book: add / edit / delete / set default / select | ASSIGN §6 / SPEC B.6 (6b) | `features/profile/presentation/screens/addresses_screen.dart` + `address_edit_screen.dart` / `controllers/addresses_controller.dart` / `data/repository/address_repository_impl.dart` (`set_default_address`) | Yes (`/profile/addresses`, `/profile/addresses/edit`) | Yes (Profile → Addresses; star action) | **[WIRED]** |
| Theme + sign-out (settings) | SPEC B.1, THEME-01 | `features/profile/presentation/screens/settings_screen.dart` / theme_controller.dart | Yes (`/profile/settings`) | Yes (Profile → Settings) | **[WIRED]** |

## §2 — Product Discovery & Navigation (SPEC B.2)

| Feature / Requirement | Spec Source Clause | Physical File Paths (UI / State / Data) | Route Registered? | Navigation Trigger Exists? | Wiring Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Home feed: banner strip, category card grid, brand rail, new arrivals | ASSIGN §2 / SPEC B.2 (2c) | `features/catalog/presentation/screens/home_screen.dart` / `controllers/home_feed_providers.dart`, `brands_provider.dart` / `data/repository/catalog_repository_impl.dart` | Yes (`/home`, tab 1) | Yes (bottom nav) | **[WIRED]** |
| Product search (name OR brand, server-side) | ASSIGN §2 / SPEC B.2 (2b) | `features/catalog/presentation/screens/products_screen.dart` / `controllers/products_controller.dart` / `catalog_repository_impl.dart` (`or`-filter) | Yes (`/home/products`) | Yes (Home search bar) | **[WIRED]** |
| Category + brand filter chips | ASSIGN §2 / SPEC B.2 | same as above (+ `widgets/category_chip.dart`) | Yes (same route) | Yes (chip rows) | **[WIRED]** |
| Sorting (newest / price ↑ / price ↓ / name) | ASSIGN §2 / SPEC B.2 | same as above (`ProductSort` menu) | Yes (same route) | Yes (app-bar sort menu) | **[WIRED]** |
| Discovery screen per category/brand (aggregates subcategories) | ASSIGN §2 / SPEC B.2 (2c) | `features/catalog/presentation/screens/discovery_screen.dart` / `controllers/products_controller.dart` (family) / `catalog_repository_impl.dart` (`category_id IN (id+children)`) | Yes (`/home/discovery`) | Yes (Home category cards + brand rail) | **[WIRED]** |

## §3 — Product Catalog & Details (SPEC B.3)

| Feature / Requirement | Spec Source Clause | Physical File Paths (UI / State / Data) | Route Registered? | Navigation Trigger Exists? | Wiring Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Product detail: gallery, name, price, brand, availability, description, variants, related | ASSIGN §3 / SPEC B.3 | `features/catalog/presentation/screens/product_detail_screen.dart` / `controllers/product_detail_controller.dart` / `catalog_repository_impl.dart` (`fetchProductDetail`) | Yes (`/home/product/:id`) | Yes (5 triggers: grids, cart tile, wishlist, dashboard) | **[WIRED]** |
| Variant picker sheet (dynamic price, stock-capped qty) | ASSIGN §3 / SPEC B.3 | `features/catalog/presentation/widgets/variant_picker_sheet.dart` / `domain/entities/product_variant.dart` | Embedded (bottom sheet) | Yes (Add to cart button) | **[WIRED]** |
| Full-screen image gallery | ASSIGN §3 / SPEC B.3 | `features/catalog/presentation/widgets/product_image_gallery.dart` | Embedded | Yes (tap image) | **[WIRED]** |
| Review cards (avatar, name, stars, text, date) + aggregate | ASSIGN §3, §7 / SPEC B.7 (7F) | `features/catalog/presentation/widgets/review_card.dart` + `rating_stars.dart` / `product_detail_controller.dart` / `catalog_repository_impl.dart` (users embed w/ avatar) | Embedded | Yes (detail scroll) | **[WIRED]** |

## §4 — Wishlist & Shopping Cart (SPEC B.4)

| Feature / Requirement | Spec Source Clause | Physical File Paths (UI / State / Data) | Route Registered? | Navigation Trigger Exists? | Wiring Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Wishlist grid (shared ProductCard via composition-root builder) | ASSIGN §4 / SPEC B.4 (6) | `features/wishlist/presentation/screens/wishlist_screen.dart` / `controllers/wishlist_controller.dart` / `data/repository/wishlist_repository_impl.dart` | Yes (`/profile/wishlist`) | Yes (Profile → Wishlist) | **[WIRED]** |
| Wishlist add/remove + cart quick actions (long-press, default variant) | ASSIGN §4 / SPEC B.4 (6) | `features/catalog/presentation/widgets/product_card_actions.dart` / `core/router/product_card_actions.dart` / cart+wishlist controllers | Embedded (long-press sheet) | Yes (long-press on any ProductCard: Home/Discovery/Wishlist) | **[WIRED]** |
| Cart: flat list, quantity stepper (product-wide stock cap), remove, clear | ASSIGN §4 / SPEC B.4 | `features/cart/presentation/screens/cart_screen.dart` / `controllers/cart_controller.dart` / `data/repository/cart_repository_impl.dart` (RPCs `add/update/remove/clear_cart_item`) | Yes (`/cart`, tab 2) | Yes (bottom nav) | **[WIRED]** |
| Cart totals display (server-authoritative pricing) | ASSIGN §4 / SPEC B.4 | same as above (`CartItem.lineTotalMinor`, `Money`) | n/a (same screen) | n/a | **[WIRED]** |

## §5 — Pricing, Coupons & Promotions (SPEC B.5)

| Feature / Requirement | Spec Source Clause | Physical File Paths (UI / State / Data) | Route Registered? | Navigation Trigger Exists? | Wiring Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Coupon validation + application at checkout (min order, window, scope) | ASSIGN §5 / SPEC B.5 (5b) | `features/checkout/presentation/screens/checkout_screen.dart` (coupon step) / `controllers/checkout_controller.dart` / `data/repository/checkout_repository_impl.dart` (`validate_coupon`) | Yes (checkout step 5) | Yes (coupon field) | **[WIRED]** |
| Admin coupon creation (atomic rule+code; platform/brand scope; min order; window) | ASSIGN §5 / SPEC B.5 (5b) | `features/promotions/presentation/screens/admin_promotions_screen.dart` / `controllers/admin_promotions_controller.dart` / `data/repository/promotions_repository_impl.dart` (`create_platform_promotion`) | Yes (`/admin/promotions`, tab) | Yes (tab + `+` action) | **[WIRED]** |
| Banner moderation (approve/reject/disable) | ASSIGN §5 / SPEC B.5 (5b) | same as above (`moderate_banner`) | Yes (same tab) | Yes (per-banner menu) | **[WIRED]** |
| Admin banner upload (replaces business submission) | ASSIGN §5 / SPEC B.5 (9) | same as above (`createBanner` → `admin_create_banner`) | Yes (same tab) | Yes (app-bar campaign action) | **[WIRED]** |
| Customer banner strip (approved, in-window) | ASSIGN §2 / SPEC B.2 | `features/catalog/presentation/screens/home_screen.dart` (`_BannersStrip`) / `home_feed_providers.dart` / `catalog_repository_impl.dart` (`fetchApprovedBanners`) | n/a (Home section) | n/a (passive display) | **[WIRED]** |

## §6 — Checkout, Shipping & Payments (SPEC B.6)

| Feature / Requirement | Spec Source Clause | Physical File Paths (UI / State / Data) | Route Registered? | Navigation Trigger Exists? | Wiring Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Multi-step checkout wizard (Cart review → Address → Shipping method → Payment → Coupon → Note → Summary) | ASSIGN §6 / SPEC B.6 (6b) | `features/checkout/presentation/screens/checkout_screen.dart` (Stepper) / `controllers/checkout_controller.dart` + `states/checkout_state.dart` / `domain/usecases/place_order.dart` → `create_order_from_cart` | Yes (`/cart/checkout`) | Yes (Cart → Checkout) | **[WIRED]** |
| Address selection (default preselected) | ASSIGN §6 / SPEC B.6 | same (address step) + `address_repository_impl.dart` (default-first ordering) | Yes (same step) | Yes | **[WIRED]** |
| Shipping method step (fixed fee from `platform_settings`) | ASSIGN §6 / SPEC B.6 | same (shipping step) | Yes (same step) | Yes | **[WIRED]** |
| Payment methods: Cash on Delivery / QR (KHQR) | ASSIGN §6 / SPEC B.6 (6b) | same (payment step) + `domain/entities/payment_method.dart` | Yes (same step) | Yes | **[WIRED]** |
| Order note | ASSIGN §6 / SPEC B.6 (6b) | same (note step) → `orders.note` via RPC `p_note` | Yes (same step) | Yes | **[WIRED]** |
| Order summary + atomic placement | ASSIGN §6 / SPEC B.6 | same (summary step) + `domain/usecases/place_order.dart` | Yes (same step) | Yes (Place order) | **[WIRED]** |
| Order confirmation screen (id, date, total, address, method, mock ETA) | ASSIGN §6, §7 / SPEC B.7 | `features/checkout/presentation/screens/order_placed_screen.dart` / `controllers/order_payment_controller.dart` (realtime `payments` stream) | Yes (`/cart/checkout/placed/:id`) | Yes (post-placement) | **[WIRED]** |
| KHQR generation + registration (server-side MD5) | ASSIGN §6 / SPEC B.6 (6b) | `features/checkout/data/khqr_generator.dart` + `order_payment_controller.dart` (`ensureQrRegistered`) / `register_qr_payment` RPC | Embedded | Yes (QR payment flow) | **[WIRED]** |
| QR realtime confirmation + Bakong poll | ASSIGN §6 / SPEC B.6 (6b) | `order_payment_controller.dart` (`pollBakong`) / `supabase/functions/bakong-check`, `confirm_qr_payment` | n/a (data) | Yes (auto 5s poll) | **[WIRED]** (inert w/o `BAKONG_TOKEN`; simulate path active) |
| Admin "Simulate QR payment" (dev-only gateway stand-in) | SPEC B.6 (6b) | `features/admin/presentation/screens/admin_order_detail_screen.dart` / `admin_orders_controller.dart` / `simulate_qr_payment` | n/a (admin view) | Yes (conditional button) | **[WIRED]** |
| Bank-transfer proof upload (LEGACY rows only) | ASSIGN §6 / SPEC B.6 | `features/orders/presentation/screens/order_detail_screen.dart` (`_pickAndUploadProof`) / `orders_repository_impl.dart` (`submit_payment_proof`) | n/a (order detail) | Yes (legacy `bank_transfer` payments only; method removed from checkout UI in 6b) | **[WIRED]** (legacy-dormant) |

## §7 — Order Lifecycle, Tracking, Cancellation, Returns, Reviews (SPEC B.7)

| Feature / Requirement | Spec Source Clause | Physical File Paths (UI / State / Data) | Route Registered? | Navigation Trigger Exists? | Wiring Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Single order lifecycle (`orders.status`, assignment vocabulary) | ASSIGN §7 / SPEC B.7 (7A) | `features/orders/domain/entities/order.dart` (`OrderStatus`) / `orders_repository_impl.dart` / SQL `create_order_from_cart` (0040) | n/a (data model) | n/a | **[WIRED]** |
| Order History w/ status-group + date-range filters (server-side) | ASSIGN §7 / SPEC B.7 (7B) | `features/orders/presentation/screens/orders_screen.dart` / `controllers/orders_controller.dart` + `states/order_history_state.dart` / `fetchMyOrders` filters | Yes (`/orders`, tab 3) | Yes (bottom nav) | **[WIRED]** |
| Order detail (items, payment, address snapshot, note) | ASSIGN §7 / SPEC B.7 | `features/orders/presentation/screens/order_detail_screen.dart` / `controllers/order_detail_controller.dart` (realtime `orders` stream) | Yes (`/orders/:id`) | Yes (history tap + dashboard panel) | **[WIRED]** |
| Tracking timeline (verbatim lifecycle) + mock tracking # + conditional ETA + courier line | ASSIGN §7 / SPEC B.7 (7C) | `features/orders/presentation/widgets/order_status_timeline.dart` / detail screen header | Embedded | Yes (order detail) | **[WIRED]** |
| Realtime status updates (initial-snapshot-skipping stream) | ASSIGN §7 / SPEC B.7, §31 | `orders_repository_impl.dart` (`watchOrderChanges`) / `order_detail_controller.dart` | n/a (data) | n/a (auto) | **[WIRED]** |
| Customer cancellation (pending/confirmed; reason, date, stock restore, refund routing) | ASSIGN §7 / SPEC B.7 (7D) | `order_detail_screen.dart` (`_confirmCancel`) / `order_detail_controller.dart` / `cancel_order` RPC | n/a (order detail) | Yes (Cancel button) | **[WIRED]** |
| Admin lifecycle transitions + cancel-with-reason | ASSIGN §7, §8 / SPEC B.7 (7A) | `features/admin/presentation/screens/admin_order_detail_screen.dart` / `controllers/admin_orders_controller.dart` / `admin_transition_order` | Yes (`/admin/orders/:id`) | Yes (next-step + cancel buttons) | **[WIRED]** |
| Admin "Mark refunded" (verified payment → refunded + reference) | ASSIGN §7 / SPEC B.7 (7D) | same as above (`markRefunded` → `mark_refunded`) | n/a (admin view) | Yes (conditional button) | **[WIRED]** |
| Return request submission (delivered orders, per-item qty ≤ purchased, reasons) | ASSIGN §7 / SPEC B.7 (7E) | `features/returns/presentation/screens/return_request_screen.dart` / `controllers/return_request_controller.dart` / `data/repository/returns_repository_impl.dart` (`request_return`) | Yes (`/orders/:id/return`) | Yes (order detail, delivered) | **[WIRED]** |
| Customer return tracker (status label + reason) | ASSIGN §7 / SPEC B.7 (7E) | `order_detail_screen.dart` (return section) / `domain/entities/order.dart` (`ReturnRequestInfo`, `ReturnStatus.label`) | Embedded | Yes (order detail) | **[WIRED]** |
| Admin return review: approve/reject → complete | ASSIGN §7 / SPEC B.7 (7E) | `admin_order_detail_screen.dart` (`_ReturnTile`) / `admin_orders_controller.dart` / `admin_process_return` + `admin_complete_return` | n/a (admin order view) | Yes (per-request buttons) | **[WIRED]** |
| Review compose (tappable 5-star → integer, server-verified 1/item) | ASSIGN §7 / SPEC B.7 (7F) | `features/reviews/presentation/screens/review_compose_screen.dart` / `controllers/review_compose_controller.dart` / `create_review` RPC | Yes (`/orders/:id/review`) | Yes (delivered item rows) | **[WIRED]** |
| Notifications inbox (realtime, tap-to-read, mark-all) | ASSIGN §8 / SPEC B.8 | `features/notifications/presentation/screens/notifications_screen.dart` / `controllers/notifications_controller.dart` / `notifications_repository_impl.dart` (stream + RPCs) | Yes (`/home/notifications`) | Yes (Home app-bar bell) | **[WIRED]** |
| FCM push registration + dispatch | ASSIGN §8 / SPEC B.8 (8E) | `features/notifications/data/push_notification_registrar.dart` / `main.dart` / `register_device_token` RPC + `supabase/functions/push-dispatch` | n/a (startup/data) | n/a (startup hook) | **[WIRED]** (inert w/o Firebase config — Part A.6; foreground display not wired, background/terminated tray only) |

## §8 — Security, Roles & Administrative Features (SPEC B.8)

| Feature / Requirement | Spec Source Clause | Physical File Paths (UI / State / Data) | Route Registered? | Navigation Trigger Exists? | Wiring Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Server-authoritative security (RLS + is_admin RPC guards) | ASSIGN §8 / SPEC B.8 | `supabase/migrations/*` (RLS), repo boundary `Failure` mapping (DATA-05) | n/a | n/a | **[WIRED]** |
| Admin dashboard (sales hero + momentum, stock alerts, trend, top sellers) | ASSIGN §8 / SPEC B.8 (8B) | `features/admin/presentation/screens/admin_dashboard_screen.dart` / `controllers/admin_report_provider.dart` (`AdminKpisController`) / `get_admin_kpis` | Yes (`/admin/dashboard`, tab 1) | Yes (bottom nav, admin role) | **[WIRED]** |
| Admin product management (CRUD, images, stock, default variant) | ASSIGN §8 / SPEC B.8 (2b) | `features/admin/presentation/screens/admin_products_screen.dart` + `admin_product_form_screen.dart` / `controllers/admin_products_controller.dart` / `admin_create/update_product`, `admin_add_product_image` | Yes (`/admin/products` + `/form`) | Yes (tab + FAB + edit tiles) | **[WIRED]** |
| Admin brand management (CRUD + archive) | ASSIGN §8 / SPEC B.8 (2b) | `features/admin/presentation/screens/brands_admin_screen.dart` / `controllers/admin_brands_controller.dart` / brands RLS | Yes (`/admin/products/brands`) | Yes (Products app-bar) | **[WIRED]** |
| Admin category management (CRUD, images, audit) | ASSIGN §8 / SPEC B.8 | `features/admin/presentation/screens/categories_admin_screen.dart` / `controllers/admin_categories_controller.dart` / `create/rename/delete_category` | Yes (`/admin/categories`, tab) | Yes (bottom nav) | **[WIRED]** |
| Admin order oversight & fulfillment (lifecycle, cancel, refunds, returns) | ASSIGN §8 / SPEC B.8 (3, 7A/7D/7E) | `features/admin/presentation/screens/admin_orders_screen.dart` + `admin_order_detail_screen.dart` / `controllers/admin_orders_controller.dart` / `admin_transition_order` et al. | Yes (`/admin/orders` + `:id`, tab) | Yes (bottom nav + list tap) | **[WIRED]** |
| Audit logs viewer (admin mutations fully covered) | ASSIGN §8 / SPEC B.8 (8D) | `features/admin/presentation/screens/audit_logs_screen.dart` / `controllers/admin_audit_controller.dart` / `audit_logs` table | Yes (`/admin/dashboard/audit`) | Yes (dashboard link) | **[WIRED]** |
| Platform settings (delivery fee, payment account, QR account) | ASSIGN §8 / SPEC B.8 | `features/admin/presentation/screens/platform_settings_screen.dart` / `controllers/admin_settings_controller.dart` / `platform_settings` RLS | Yes (`/admin/dashboard/settings`) | Yes (dashboard link) | **[WIRED]** |
| Reporting & Analytics (date-range KPI report) | ASSIGN §8 / SPEC B.8 (8C) | `features/admin/presentation/screens/admin_reports_screen.dart` / `controllers/admin_reports_controller.dart` / `get_sales_report` | Yes (`/admin/dashboard/reports`) | Yes (dashboard link) | **[WIRED]** |
| Admin promotions tab (coupons + banners sections) | ASSIGN §8 / SPEC B.8 (5b) | see §5 rows 21–23 | Yes (`/admin/promotions`, tab) | Yes (bottom nav) | **[WIRED]** |

---

## Summary

| Status | Count |
| :--- | :--- |
| **[WIRED]** | 44 feature rows (+1 legacy-dormant variant) |
| **[ORPHANED / UNLINKED]** | **0** |
| **[MISSING]** (documented-deferred in SPEC B) | see below |

**Audit conclusions:**
- 30/30 screen files are route-registered 1:1; zero orphaned screens, controllers, or widgets remain after the Section 9 cleanup (`features/business`, `features/delivery`, `features/role_applications` deleted with their branches/routes).
- All 28 controller files are Riverpod codegen (`@riverpod`); zero mock/fake data sources detected; all screens bind to live Supabase repositories.
- Only dormant path: bank-transfer proof upload — reachable exclusively on legacy `bank_transfer` payments (method removed from checkout UI in Section 6b); code intentionally retained for historical rows.
- Router-fence and trigger verification commands recorded in the audit; re-runnable via the grep procedure in the trace-procedure preamble.

## [MISSING] — Intentionally Deferred (documented in SPEC Part B; not built by design)

| Deferred item | SPEC Clause |
| :--- | :--- |
| Password change/reset (sign-out/re-login only) | B.1 |
| Gender / DOB / profile-photo profile fields | B.1 |
| Card-prototype payment method | B.6 |
| Product `code` field; category description/icon/status columns; postal/geo address fields | B.3, B.6 |
| Mock tax line in checkout | B.5 |
| Popular / Highest-rating sorts; featured / flash-sale / recently-viewed home sections; price/rating/availability filters | B.2 |
| Daily/weekly/monthly report buckets (range-based implemented) | B.8 |
| Multi-code coupons per promotion | B.5 |
| Reviewer public profile screens (card is non-interactive) | B.7 |
| FCM foreground display listener; promotion/coupon notification triggers | B.8 |
| Category subcategory browsing UI (aggregation implemented server-side) | B.2 |
