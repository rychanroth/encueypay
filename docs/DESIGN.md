# EncueYPay — DESIGN.md (Comprehensive Specification & UI Blueprint)

**Platform:** Flutter (Dart) · Mobile-First Responsive  
**Architecture:** 2-Role Academic Prototype (Customer & Admin Prototype)  
**Backend:** Supabase-Only (Auth, PostgREST, RPCs, Storage, Realtime)  
**System Invariants:** Exact `numeric` minor-unit currency, server-authoritative state, unified `ThemeData` token hierarchy, Material 3 design system, 8dp spatial rhythm, 48dp minimum touch targets.

---

## 1. System Invariants & Architectural Directives

1. **2-Role Prototype Simplification**:
    - Strictly two roles: **Customer** (default end-user) and **Admin Prototype** (executive management).
    - Multi-vendor store portals (`Business Owner`) and courier delivery portals (`Driver`) are completely bypassed/removed from Flutter routing and UI shells.
    - Catalog ownership is retained under the hood (`products.business_id` pointing to a seeded prototype business), but the customer experiences a unified store without vendor fragmentation.
2. **Server Authoritative State**:
    - Client UI state is never trusted for price calculation, stock reservation, or state changes.
    - Line prices are strictly resolved server-side: `coalesce(variant.price, product.base_price)`.
    - Checkout is fully atomic (`create_order_from_cart` RPC).
3. **Product-Wide Stock Invariant (§2d)**:
    - Stock is maintained at the product level (`products.stock`), not per variant. Purchasing any variant deducts the product-wide counter.
    - Low stock threshold: `stock <= 5`.
    - Out of stock / Archived items remain visible with an **"Unavailable"** badge; client purchase and checkout RPCs fail-closed.
4. **Currency & Financial Math**:
    - Exact `numeric` minor-unit precision without floating-point drift.
    - **Dual Currency peg**: USD primary (`$XX.XX`), Cambodian Riel secondary (`≈ XX,XXX KHR` or `~XX,XXX ៛`) pegged at the NBC reference rate of **4,100 KHR / USD**.
5. **Mobile-First Touch Ergonomics**:
    - Layouts adhere strictly to iOS and Android touch target guidelines (minimum 48×48 dp interactive targets, comfortable bottom-sheet ergonomics, thumb-zone primary action placement).
    - Floating action docks use bottom clearance and safe area insets to prevent clipping above navigation bars.

---

## 2. Color Palette & Token Specification

### 2.1 Core Material 3 Palette

```dart
// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand Primary & Shell Chrome
  static const Color primaryNavy = Color(0xFF0F172A);      // Slate 900 (Shell headers, Nav, Major titles)
  static const Color primaryRoyal = Color(0xFF1E3A8A);     // Blue 900 (Primary CTAs, Active States, Key accents)
  static const Color primaryRoyalHover = Color(0xFF1D4ED8);// Blue 700
  static const Color primarySubtle = Color(0xFFEFF6FF);    // Blue 50

  // Semantic & Financial Accents
  static const Color accentEmerald = Color(0xFF059669);    // Emerald 600 (Success, KHQR Verified, Paid)
  static const Color accentEmeraldLight = Color(0xFFECFDF5);// Emerald 50
  static const Color accentAmber = Color(0xFFD97706);      // Amber 600 (Ratings, Pending, Warnings)
  static const Color accentAmberLight = Color(0xFFFFFBEB);  // Amber 50
  static const Color accentRose = Color(0xFFE11D48);       // Rose 600 (Out of stock, Cancelled, Errors)
  static const Color accentRoseLight = Color(0xFFFFF1F2);   // Rose 50
  static const Color promotionCoral = Color(0xFFFF5722);   // Deep Orange (Promotions, Coupons, Flash sales)

  // Surface & Neutrals (Light Mode)
  static const Color backgroundLight = Color(0xFFF8FAFC);  // Slate 50 (Main page background)
  static const Color surfaceLight = Color(0xFFFFFFFF);     // Pure White (Cards, Bottom sheets, Inputs)
  static const Color surfaceContainer = Color(0xFFF1F5F9); // Slate 100 (Secondary containers, chips)
  static const Color borderLight = Color(0xFFE2E8F0);       // Slate 200 (Hairline dividers, borders)
  static const Color textPrimaryLight = Color(0xFF0F172A);  // Slate 900 (High contrast headlines)
  static const Color textSecondaryLight = Color(0xFF64748B);// Slate 500 (Subtitles, labels, descriptions)
  static const Color textMutedLight = Color(0xFF94A3B8);    // Slate 400 (Placeholder, inactive text)

  // Surface & Neutrals (Dark Mode)
  static const Color backgroundDark = Color(0xFF090D16);   // Deep Obsidian
  static const Color surfaceDark = Color(0xFF131B2E);      // Surface Card
  static const Color surfaceContainerDark = Color(0xFF1E293B); // Slate 800
  static const Color borderDark = Color(0xFF27354F);       // Subtle borders
  static const Color textPrimaryDark = Color(0xFFF8FAFC);   // Crisp White
  static const Color textSecondaryDark = Color(0xFF94A3B8); // Slate 400
  static const Color textMutedDark = Color(0xFF64748B);     // Slate 500

  // Cambodia Payment Standard (National Bank of Cambodia — Bakong)
  static const Color khqrRed = Color(0xFFD32027);           // Official KHQR Header Red
  static const Color khqrBg = Color(0xFFFFFFFF);
}
```

### 2.2 Order Lifecycle & Payment Status Badges (§7A & §7D)

| Status (`orders.status` / `payments.status`) | Badge Background | Badge Text/Icon | Purpose & Handling |
|---|---|---|---|
| `pending` | `Amber 50` (`#FFFBEB`) | `Amber 700` (`#B45309`) | Order placed; awaiting customer payment or validation |
| `confirmed` | `Blue 50` (`#EFF6FF`) | `Blue 700` (`#1D4ED8`) | KHQR settlement verified / COD confirmed |
| `processing` | `Indigo 50` (`#EEF2FF`) | `Indigo 700` (`#4338CA`) | Order in warehouse staging & assembly |
| `packed` | `Sky 50` (`#F0F9FF`) | `Sky 700` (`#0369A1`) | Boxed, labeled & ready for dispatch |
| `shipped` | `Cyan 50` (`#ECFEFF`) | `Cyan 700` (`#0E7490`) | Dispatched to delivery fleet; tracking prefix assigned |
| `out_for_delivery` | `Teal 50` (`#F0FDFA`) | `Teal 700` (`#0F766E`) | Courier en route (final mile delivery) |
| `delivered` | `Emerald 50` (`#ECFDF5`)| `Emerald 700` (`#047857`)| Delivery completed; enables review & return actions |
| `cancelled` | `Rose 50` (`#FFF1F2`) | `Rose 700` (`#BE123C`) | Cancelled; stock restored to warehouse |
| `returned` | `Purple 50` (`#FAF5FF`)| `Purple 700` (`#7E22CE`)| Item returned; RMA inspection passed |
| `refund_required` | `Rose 50` (`#FFF1F2`)| `Rose 700` (`#BE123C`)| Verified payment requires admin reverse settlement |
| `refunded` | `Slate 100` (`#F1F5F9`)| `Slate 700` (`#334155`)| Reverse settlement logged & closed |

---

## 3. Typography Scale (Material 3 Native)

Google Fonts (`Plus Jakarta Sans`) token specifications:

```dart
// lib/core/theme/app_typography.dart
import 'dart:ui';
import 'package:flutter/material.dart';

abstract class AppTypography {
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.8,
    height: 1.2,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.25,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.3,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.35,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.45,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.2,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    height: 1.2,
  );

  static const TextStyle priceHighlight = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontFeatures: [FontFeature.tabularFigures()],
    letterSpacing: -0.4,
  );
}
```

---

## 4. Spacing, Elevation & Shape System

### 4.1 Spatial Rhythm (8dp Grid)
- `xs`: **4dp** (Badge internal margins, icon-label gap)
- `sm`: **8dp** (Tight item spacing, chip internal padding, form row spacing)
- `md`: **16dp** (Standard screen margins, card padding, form field gaps)
- `lg`: **24dp** (Section vertical gaps, modal header padding)
- `xl`: **32dp** (Hero section gaps, modal dialog padding)
- `xxl`: **48dp** (Top/bottom clearance, empty-state illustration margins)

### 4.2 Border Radius Constants
- `r8`: **8dp** (Buttons, filter chips, status badges)
- `r12`: **12dp** (Text fields, small cards, notification tiles)
- `r16`: **16dp** (Product cards, order items, bottom-sheet cards)
- `r24`: **24dp** (Bottom sheets, modal dialogs, hero containers)
- `full`: **999dp** (Avatars, pill tags, quantity circular steppers)

### 4.3 Elevation & Shadows
- **Elevation 0**: Flat surfaces with subtle `1dp` border (`AppColors.borderLight`).
- **Elevation 1 (Card Default)**: `BoxShadow(color: Color(0x080F172A), blurRadius: 8, offset: Offset(0, 2))`.
- **Elevation 2 (Floating Action Dock)**: `BoxShadow(color: Color(0x120F172A), blurRadius: 16, offset: Offset(0, -4))`.
- **Elevation 3 (KHQR Modal / Bottom Sheet)**: `BoxShadow(color: Color(0x240F172A), blurRadius: 24, offset: Offset(0, 8))`.

---

## 5. Navigation & Shell Architecture

### 5.1 Customer Navigation (5-Tab Persistent Shell)
1. **Home (`/home`)**:
    - Hero promotion banner carousel (with validity windows).
    - Category card grid ("Shop by Category") navigating to Discovery.
    - Top brand logo rail ("Top Brands") navigating to Brand-filtered Discovery.
    - Newest arrivals product grid.
2. **Discovery (`/discovery`)**:
    - Full search input with keyword matching on product name or brand name.
    - Filter chips: Categories and Brands (`brands` table, `products.brand_id`).
    - Sort dropdown: Newest, Price Ascending, Price Descending, Name.
    - 2-column `ProductCard` grid with product-wide stock indicators.
3. **Cart (`/cart`)**:
    - Dedicated tab with active bag count badge (e.g. `2`).
    - Line items with product-wide stock-capped quantity steppers.
    - Voucher code input with scope recognition (`platform` vs `brand`).
    - **Floating Action Dock (`fixed bottom-16`)** with total payable and one-tap checkout entry.
4. **Orders (`/orders`)**:
    - Status group filter tabs: `All`, `Active`, `Completed`, `Cancelled`, `Returned`.
    - Date-range filter picker (`showDateRangePicker`).
    - Card actions: Track Order, Leave Review, Request Return.
5. **Profile (`/profile`) — Embedded Dashboard**:
    - Spending stats hero (`total_spending` strictly excluding cancelled/returned orders).
    - Order count badges (Active, Completed, Cancelled).
    - Saved delivery addresses management (`addresses.is_default`).
    - Personalized Wishlist rail (shared `ProductCard` items).
    - App settings, customer support, and sign-out.

### 5.2 Admin Prototype Navigation (4-Tab Executive Shell)
1. **Dashboard (`/admin/dashboard`)**:
    - Gross realized revenue KPI card with momentum trend percentage.
    - Order volume split (Done, Pending, Cancelled) & Verified customer accounts.
    - **Critical Stock Alert Card**: Surfacing items where `stock <= 5` or `stock == 0` with quick Restock shortcuts.
    - **14-Day Sales Momentum Chart**: Native Flutter bar chart (`DEPS-03` compliant).
    - Top-3 performing SKUs and quick actions (Add Product, Review Orders, Simulate KHQR, Audit Logs).
2. **Products (`/admin/products`)**:
    - Catalog inventory manager with product-wide stock counter (`products.stock`).
    - Filter chips: `All Products`, `Low Stock (≤5)`, `Out of Stock`.
    - Archive/Visibility control: Displays archived products with **"Unavailable"** badge and an **Unarchive / Restore** action.
    - Quick inline `[- Stock +]` adjustment controls and full `+ Create` product wizard.
3. **Orders (`/admin/orders`)**:
    - Executive state machine controller advancing orders through the single lifecycle (§7A).
    - Forward transition CTAs: `Advance to Processing`, `Mark as Packed & Ready`, `Mark Out for Delivery`.
    - Reverse payment authorization: **"Authorize & Record Bakong Refund"** button on returned/cancelled orders (§7D).
4. **Reports (`/admin/reports`)**:
    - Date range selector (`7D`, `15D`, `30D`, `MTD`, Custom Window).
    - Executive KPI summary: Gross Realized Revenue, Net Settled Balance, Completed Orders, AOV ($91.93), and Purchase Frequency.
    - Sales breakdown by catalog department.
    - **Payment Gateway Distribution**: Bakong KHQR (82%) vs Cash on Delivery (18%).
    - Brand revenue rankings and current inventory capital valuation.

---

## 6. Shared Component Specifications

### 6.1 `ProductCard` (Shared Catalog Component)
- **Visuals**: 1:1 Aspect ratio image container with fallback skeleton.
- **Badges**:
    - Top-left: Brand chip or Discount percent badge (`-13%`, `NEW`).
    - Top-right: Wishlist heart toggle with micro-animation.
    - Bottom-center of image: "Unavailable" / "Sold Out" pill if stock is 0 or archived.
- **Metadata**: Brand name in `textMuted`, product title (2 lines max with ellipsis), star rating with review count, price in bold currency format.
- **Interactions**:
    - `onTap`: Navigate to `ProductDetailScreen`.
    - `onLongPress`: Open `ProductCardActions` modal bottom sheet (Add to Wishlist, Quick Add default variant to Cart).

### 6.2 `OrderStatusTimeline` (Order Detail & Tracking)
- **Visuals**: Vertical connected stepper node track.
- **Stages**:
  `Pending` → `Confirmed` → `Processing` → `Packed` → `Shipped` → `Out for Delivery` → `Delivered`.
- **States**:
    - Completed nodes: Solid emerald fill with checkmark icon.
    - Current active node: Pulsing primary royal node with status time or ETA label.
    - Future nodes: Muted gray hollow outline.
    - Special branch: Cancelled or Refunded replaces stepper with a dedicated status callout banner.

### 6.3 7-Step Checkout Wizard (`CheckoutScreen`)
- **Step 1: Cart Review** — Item list with quantity steppers and variant labels.
- **Step 2: Shipping Address** — Radio selector showing default badge (`addresses.is_default`) + 'Manage Addresses' link.
- **Step 3: Shipping Method** — Fixed fee from `platform_settings` with delivery timeline description.
- **Step 4: Payment Method** — Radio selector between `Bakong KHQR (Instant Bank Settlement)` and `Cash on Delivery (COD)`.
- **Step 5: Coupon** — Input field + validation button + scope chip ('Platform' / 'Brand').
- **Step 6: Order Note** — Optional textarea saved to `orders.note`.
- **Step 7: Order Summary** — Price breakdown (Subtotal, Discounts, Delivery Fee, Grand Total) + atomic `Place Order` button.

### 6.4 Bakong KHQR Payment Modal & Card (`OrderPlacedScreen`)
- **Visuals**: Official NBC Bakong KHQR card with red header bar, EMV-compliant QR code generated client-side, merchant name "EncueYPay Prototype", and dynamic transaction amount ($USD and ~KHR).
- **Status Observer**: Realtime listener on `payments` table. Instant transition to success celebration when webhook or poller confirms payment.
- **Admin Simulation Trigger**: In-app button to trigger `simulate_qr_payment` for local testing without bank API keys.

### 6.5 Floating Checkout Action Dock (`CartScreen`)
- **Visuals**: Anchored dock floating above the 5-tab bottom navigation (`fixed bottom-16`).
- **Ergonomics**: Backdrop blur (`backdrop-blur-md`), elevation shadow (`shadow-xl`), showing Total Payable and instant "Proceed to Checkout (Step 1 of 7) →" action.

---

## 7. Supabase Database Wiring & Server Authority

### 7.1 Core Tables & Schema Invariants
- `users`: Managed auth profile with `active_role` enum (`customer | business | driver | admin`). Self-promotion blocked by trigger.
- `products`: Product catalog with `brand_id`, `business_id`, and product-wide `stock`.
- `product_variants`: Variant options (color, size, model). Null price defaults to product base price.
- `brands`: Brand catalog (`id`, `name`, `image_url`, `status`).
- `categories`: Category taxonomy (`id`, `name`, `image_url`, `parent_id`).
- `orders`: Single lifecycle record (`status` = `order_status` enum, `note`, `cancelled_at`, `cancellation_reason`).
- `order_items`: Historical immutable snapshots (`product_id`, `variant_id`, `quantity`, `unit_price`, `business_name`).
- `payments`: Payment record (`order_id`, `amount`, `payment_method` = `qr | cod`, `qr_payload`, `qr_md5`, `status`).
- `promotions` & `coupons`: Multi-tier promotional rules (scope `platform | brand`, `min_order_amount_minor`, `starts_at`, `ends_at`).

### 7.2 Security Definer RPC Endpoints
- `create_order_from_cart(p_note)`: Atomic checkout transaction with row-level locks on `products.stock`.
- `validate_coupon(p_code, p_cart_subtotal)`: Server validation of expiration window, minimum order threshold, and brand eligibility.
- `admin_transition_order(p_order_id, p_new_status)`: Validated single-direction status machine with automated notifications.
- `simulate_qr_payment(p_payment_id)`: Mock settlement trigger for prototype demonstration.
- `get_admin_kpis()` & `get_sales_report(p_start_date, p_end_date)`: Security-definer aggregation queries excluding cancelled/returned orders.
- `get_customer_dashboard()`: Aggregated user spending and recent orders.

---

## 8. Flutter Architecture & Code Structure

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart         # Color tokens & status palettes
│   │   ├── app_typography.dart     # Material 3 TextTheme definitions
│   │   ├── app_theme.dart          # Light and Dark ThemeData builders
│   │   └── app_dimensions.dart     # Margins, padding, radii constants
│   ├── router/
│   │   ├── app_routes.dart         # GoRouter route declarations
│   │   ├── navigation_tabs.dart    # Customer (5-tab) & Admin (4-tab) shells
│   │   └── product_card_actions.dart# Composition-root action sheet builder
│   ├── utils/
│   │   ├── responsive_layout.dart  # Breakpoint builders & adaptive helpers
│   │   └── currency_formatter.dart # Exact minor-unit currency formatters (USD & KHR)
│   └── widgets/
│       ├── encue_button.dart       # Primary, secondary, outline, destructive
│       ├── encue_card.dart         # Styled card with standard radii & borders
│       ├── status_badge.dart       # Single lifecycle order & payment status chip
│       ├── khqr_card.dart          # NBC Bakong EMV QR widget
│       └── async_value_widget.dart # Uniform loading/error state handler
├── features/
│   ├── auth/                       # Login, sign-up, session state
│   ├── catalog/                    # Home, Discovery, ProductDetail, Reviews
│   ├── cart/                       # CartItemTile, FloatingCartDock, CartController
│   ├── checkout/                   # 7-Step Checkout Wizard, Address, Shipping, Payment
│   ├── orders/                     # OrderStatusTimeline, History, ReturnRequest
│   ├── profile/                    # DashboardOverviewPanel, AddressesScreen
│   └── admin/                      # AdminDashboard, ProductsAdmin, OrdersAdmin, Reports
└── main.dart
```
