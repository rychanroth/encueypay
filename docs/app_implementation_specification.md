# E-commerce App Implementation Specification

## 1. System Overview

The system is a **single Flutter-based multi-vendor e-commerce application** backed by **Supabase**, serving four user roles:

* **Customer**
* **Business**
* **Driver**
* **Admin**

The application supports:

* User authentication and role management
* Multi-vendor product discovery
* Shopping carts and wishlists
* Multi-business checkout
* Business-specific order processing
* One delivery containing multiple business pickup stops
* Cash on Delivery
* Manual bank transfer
* Product inventory management
* Promotions and coupons
* Returns
* Product reviews
* Persistent notifications and push notifications
* Limited realtime synchronization
* Administrative management
* Audit/history tracking

The system is intentionally designed as an **MVP/prototype**, with real banking, refunds, external logistics, and real GPS infrastructure outside its scope.

---

# 2. Actors and Roles

## 2.1 Customer

A newly registered account is a Customer by default.

Customers can:

* Manage their profile and addresses
* Browse businesses, categories, products, and variants
* Search, filter, and sort products
* Add products to a cart
* Manage a wishlist
* Apply eligible coupons
* Place multi-business orders
* Select Cash on Delivery or Manual Bank Transfer
* View their orders
* Cancel an order when permitted
* Track order and delivery status
* Request returns
* Submit one review per purchased OrderItem
* Receive and read notifications
* Apply to become a Business or Driver

---

## 2.2 Business

A user may operate one Business account.

A Business can:

* Manage its business profile
* Manage its products and variants
* Archive products
* Maintain stock
* View its BusinessOrders
* Accept or reject BusinessOrders
* Mark orders as preparing
* Mark orders as ready
* Create ordinary business-scoped coupons/promotions
* Submit promotional banners for admin approval
* View business-level analytics
* Process customer returns for its products

A Business cannot access or modify another Business's resources.

---

## 2.3 Driver

A Driver can:

* View available deliveries
* Accept an available delivery
* Reject/cancel an assigned delivery
* View assigned delivery details
* View pickup stops
* Complete pickup stops
* Start delivery
* Mark delivery completed
* View delivery history

Only one Driver may actively own a Delivery assignment at a time.

---

## 2.4 Admin

Admin capabilities are explicit and management-oriented.

Admin can:

* Review role applications
* Approve or reject role applications
* Manage global categories
* Manage platform-wide promotions/coupons
* Review and manage business promotional banners
* Disable or edit approved business banners
* Access reports and analytics
* Access audit records
* Manage platform settings

Admin does **not** receive unrestricted ability to arbitrarily mutate operational Order or Delivery states.

---

# 3. Role Model

Each user has exactly **one active role**.

```text
Customer
Business
Driver
Admin
```

New accounts:

```text
User created
    ↓
active_role = Customer
```

A user may apply to become:

* Business
* Driver

Role application flow:

```text
User
  ↓
Submit Role Application
  ↓
Pending
  ↓
Admin Approves / Rejects
```

After approval:

```text
active_role = requested role
```

There is no dedicated role-department workflow.

If a user previously held another role and wants to return to it, they submit a new application.

### Pending application rule

There may be only **one pending role application per user**.

Submitting another pending application replaces the previous pending application.

---

# 4. Business Ownership Model

A user may own at most one Business.

```text
User
  │
  └── 0..1 Business
```

One Business corresponds to one store/business account managed by that user.

The system does not support one user simultaneously operating multiple Businesses in the MVP.

---

# 5. Product and Catalog Model

## 5.1 Category

Categories are platform-level catalog structures.

Categories may support:

* Parent categories
* Child categories

Example:

```text
Electronics
├── Phones
├── Laptops
└── Accessories
```

---

## 5.2 Product

A Product belongs to:

* One Business
* One Category

A Product may contain:

* Name
* Description
* Base price
* Stock information
* Images
* Status
* Timestamps

---

## 5.3 Product Variant

A Product may have multiple variants.

Examples:

```text
T-Shirt
├── Small / Black
├── Medium / Black
├── Large / Black
└── Medium / White
```

A variant may have its own:

* Attributes
* Price
* Stock
* Status

The selected sellable unit in the cart is the ProductVariant where applicable.

---

# 6. Product Lifecycle

Products are not destructively deleted once they may have participated in transactions.

Instead:

```text
Active
  ↓
Archived / Inactive
```

Historical OrderItems retain their original product information independently from the current catalog.

This prevents later product edits from corrupting historical orders.

---

# 7. Inventory Model

Each Business maintains its own product/variant stock.

The system conceptually distinguishes:

```text
Current Stock
Reserved Stock
Available Stock
```

Where:

```text
Available Stock = Current Stock - Reserved Stock
```

## Reservation

Stock is reserved when an order is successfully created.

```text
Checkout
  ↓
Validate Stock
  ↓
Reserve Stock
  ↓
Create Order
```

## BusinessOrder cancellation/rejection

If a BusinessOrder is rejected or cancelled:

```text
Reserved Stock
      ↓
Released
```

## Successful fulfillment

Reserved stock becomes consumed as part of successful fulfillment.

## Manual correction

Business users may manually update stock because platform inventory is not synchronized with external warehouses or real-world inventory systems.

There is no external warehouse/inventory integration in the MVP.

---

# 8. Shopping Cart

Each Customer has one active cart.

A Cart contains CartItems.

Each CartItem references a ProductVariant and quantity.

The same ProductVariant must not appear as duplicate CartItems within one cart.

The client may display cached/current information, but the server is authoritative for:

* Current product state
* Current variant state
* Current price
* Stock
* Business ownership
* Validity of cart contents

---

# 9. Multi-Vendor Ordering

The central ordering model is:

```text
Order
├── BusinessOrder A
│   ├── OrderItem
│   ├── OrderItem
│   └── ...
├── BusinessOrder B
│   ├── OrderItem
│   └── ...
└── ...
```

A single customer checkout may contain products from multiple Businesses.

There is therefore:

* One overall `Order`
* One `BusinessOrder` per participating Business
* Multiple `OrderItem`s within each BusinessOrder

Each BusinessOrder has its own lifecycle.

---

# 10. Overall Order Model

The system deliberately does **not** maintain a large authoritative overall Order state machine.

Instead, the operational state is distributed across:

* `BusinessOrder`
* `Payment`
* `Delivery`

The customer-facing overall order presentation is derived from those independent states.

This avoids creating a giant state machine containing every possible combination of business, payment, and delivery conditions.

---

# 11. BusinessOrder Lifecycle

A BusinessOrder represents the portion of the overall Order belonging to one Business.

Typical lifecycle:

```text
Pending
  ↓
Accepted
  ↓
Preparing
  ↓
Ready
  ↓
Completed
```

Alternative terminal/exception path:

```text
Pending
  ↓
Rejected / Cancelled
```

BusinessOrders are processed independently.

For example:

```text
Order #1001

Business A → Preparing
Business B → Ready
Business C → Rejected
```

The overall customer order remains one Order, but each BusinessOrder retains its own state.

---

# 12. Customer Order Cancellation

A Customer may cancel/reject their order when the established business-state conditions permit cancellation.

Cancellation affects the relevant order/business-order and any related reservations or payment consequences.

If a BusinessOrder is already rejected/cancelled after payment has occurred, the payment/order records may enter:

```text
RefundRequired
```

Actual refund execution remains outside the system.

---

# 13. Business Rejection

A Business may reject/cancel its BusinessOrder before preparation according to the established lifecycle rules.

The BusinessOrder stores the rejection/cancellation reason.

Consequences may include:

* BusinessOrder becomes cancelled/rejected
* Reserved inventory is released
* The overall Order remains represented through its other independent states
* Payment may require refund handling where applicable

---

# 14. Delivery Model

The MVP uses:

> **One Delivery per overall Order.**

Even when an Order contains products from multiple Businesses, it still has one Delivery.

A Delivery contains multiple PickupStops:

```text
Delivery
├── PickupStop → Business A
├── PickupStop → Business B
├── PickupStop → Business C
└── ...
```

Each PickupStop corresponds to one participating BusinessOrder.

---

# 15. Delivery Lifecycle

The Delivery includes driver assignment and delivery progression.

Conceptually:

```text
Available
  ↓
Assigned
  ↓
Pickup in Progress
  ↓
Delivery In Progress
  ↓
Delivered
```

The exact stored state transitions are validated by backend logic.

---

## 15.1 Driver Assignment

Available deliveries are visible to eligible Drivers.

When a Driver accepts a Delivery:

```text
Available Delivery
      ↓
Atomic assignment
      ↓
Driver assigned
```

The assignment must be atomic so two Drivers cannot successfully claim the same Delivery.

The first valid Driver acceptance wins.

---

## 15.2 Driver Rejection/Cancellation

If the assigned Driver rejects/cancels the Delivery:

```text
Assigned
   ↓
Available again
```

Another eligible Driver may then accept it.

---

# 16. Pickup Stops

Each participating BusinessOrder generates one PickupStop.

Example:

```text
Order #1001

Business A → BusinessOrder A → PickupStop 1
Business B → BusinessOrder B → PickupStop 2
Business C → BusinessOrder C → PickupStop 3
```

The Driver completes each PickupStop independently.

The Delivery cannot proceed beyond required pickup conditions until the appropriate stops are satisfied.

---

# 17. Address Handling

Addresses are mutable user-owned records before checkout.

At checkout, the shipping address is copied into the Order as a **historical snapshot**.

The Order therefore stores the exact address used for that purchase.

Later editing the Customer's profile address must not alter historical orders.

---

# 18. Business Historical Snapshot

Historical transaction records preserve sufficient Business identity information for historical display.

Current Business profile edits must not rewrite the meaning of past orders.

---

# 19. OrderItem Historical Snapshot

Each OrderItem stores historical purchase information, including:

* Product name
* Variant description
* Purchased unit price
* Discount
* Quantity
* Line total

Current catalog edits must not alter historical purchase information.

---

# 20. Payment Model

There is one Payment associated with the overall Order.

Supported MVP methods:

```text
Cash on Delivery
Manual Bank Transfer
```

---

## 20.1 Cash on Delivery

COD means payment is collected during successful delivery.

There is no internal wallet or stored monetary balance.

The system records the payment lifecycle but does not implement a financial wallet.

---

## 20.2 Manual Bank Transfer

The Customer uploads transfer proof.

The file is stored in Supabase Storage.

The Payment record stores only its file/path/reference.

```text
Storage
    owns binary file

Payment
    owns reference to file
```

For the prototype:

```text
AwaitingPaymentVerification
        ↓
TransactionVerified
```

occurs immediately after valid proof submission.

The `AwaitingPaymentVerification` concept remains available for future real verification.

---

# 21. Refund Model

The system models refund-related states but does not execute actual refunds.

Possible Payment states include:

* `AwaitingPaymentVerification`
* `TransactionVerified`
* `RefundRequired`
* `Refunded`

Example:

```text
Bank transfer verified
        ↓
Business rejects order
        ↓
RefundRequired
```

Actual transfer of money back to the customer occurs outside the MVP.

---

# 22. Monetary Representation

Money is displayed using normal decimal values:

```text
10.00
125.50
999.99
```

However, implementation must **not rely on binary floating-point arithmetic for financial calculations**.

Monetary calculations must use an exact decimal-compatible representation.

The system must preserve:

* Unit prices
* Discounts
* Subtotals
* Delivery fees
* Platform fees
* Commission values
* Total amounts

without floating-point rounding errors.

---

# 23. Checkout

Checkout is conceptually one transactional operation:

```text
CreateOrderFromCart
```

The server validates the complete purchase before committing it.

## Required validation

* Customer identity
* Cart ownership
* Cart contents
* Product status
* Variant status
* Current prices
* Current stock
* Business ownership
* Coupon validity
* Discount applicability
* Payment method
* Delivery address

## Checkout processing

Conceptually:

```text
Load cart
   ↓
Validate products/variants
   ↓
Validate stock
   ↓
Validate coupons
   ↓
Calculate prices
   ↓
Reserve stock
   ↓
Create Order
   ↓
Create BusinessOrders
   ↓
Create OrderItems
   ↓
Create Payment
   ↓
Create Delivery
   ↓
Commit atomically
```

A partial checkout must not be left behind.

---

# 24. Coupon Model

Coupons are simple MVP discounts.

There are two primary scopes:

### Business-scoped coupon

Created by a Business.

The coupon applies only to cart items belonging to that Business.

If the cart contains no matching items, the coupon has no effect.

### Platform-scoped coupon

Created by Admin.

The coupon applies according to the platform-wide eligibility rules.

Multiple Business coupons may coexist during a single checkout when their corresponding Businesses are represented in the cart.

---

# 25. Coupon Validation

Coupon validation is server-authoritative.

The server checks:

* Coupon exists
* Coupon is active
* Coupon is within validity period
* Scope is valid
* Applicable Business exists where required
* Cart contains eligible items
* Discount calculation is valid

The client may preview a discount, but the server recalculates the final amount during checkout.

---

# 26. Historical Coupon Results

Order records preserve the applied coupon and resulting discount rather than relying on the coupon's current definition.

This prevents later changes to a coupon from rewriting historical transactions.

The relevant structure includes:

```text
Order
  ↓
OrderCoupon
  ↓
Coupon / Promotion
```

with the actual applied discount amount retained for historical correctness.

---

# 27. Promotions

The Promotion model supports:

* Business promotions
* Platform promotions
* Coupons
* Promotional banners

Business-created ordinary coupons do not require administrative approval.

Business promotional banners require admin approval.

Admins may:

* Approve
* Reject
* Edit
* Disable

business promotional banners.

Admins may also create platform-wide promotions.

---

# 28. Returns

Customers may request returns after delivery.

```text
Order
  ↓
ReturnRequest
  ├── ReturnItem
  ├── ReturnItem
  └── ...
```

A ReturnRequest may contain multiple ReturnItems from the same Order.

Each ReturnItem references a specific purchased OrderItem.

The requested quantity must not exceed the purchased quantity.

---

## 28.1 Return Lifecycle

Conceptually:

```text
Customer submits
      ↓
Pending
      ↓
Business approves / rejects
```

The Business owning the relevant products decides the return request outcome according to the defined workflow.

Actual refund execution is outside the MVP.

---

# 29. Reviews

Reviews are tied to purchased OrderItems.

A Customer may create at most one Review for each purchased OrderItem.

The server must verify:

1. The OrderItem belongs to the authenticated customer.
2. The OrderItem was actually purchased.
3. A Review does not already exist for that OrderItem.

After submission, the Review is read-only.

No MVP support is required for:

* Business replies
* Review reports
* Disputes
* Review hiding/moderation workflows

The product UI displays the resulting rating.

---

# 30. Notifications

The notification system consists of two layers.

## Persistent application notification

A Notification record is stored for the user.

It contains information such as:

* Recipient
* Type
* Title
* Content
* Read status
* Timestamp

## Push notification

FCM is used to deliver an immediate push notification to registered devices.

Conceptual flow:

```text
Domain state changes
        ↓
Create Notification record
        ↓
Send FCM notification
        ↓
Flutter receives push
```

Persistent notifications remain available even if push delivery fails or the user is offline.

A user may have multiple registered device tokens.

---

# 31. Realtime Scope

Realtime is intentionally limited.

Realtime-supported areas are:

* Business incoming orders
* Driver available deliveries
* Customer order status
* Customer delivery status
* Notifications

The system does **not** make every feature realtime.

Normal CRUD/query behavior remains request/response based.

Realtime is used as a synchronization mechanism, not as the authoritative source of truth.

The authoritative state remains the backend/database.

---

# 32. Search, Filtering, and Catalog Access

The catalog exposes:

* Business discovery
* Category discovery
* Product discovery
* Product detail
* Search
* Filtering
* Sorting
* Reviews
* Related products

Catalog queries should support pagination where appropriate.

The client must not assume that data returned previously remains valid during checkout.

---

# 33. API Contract Model

The application uses Supabase rather than a separate traditional REST server.

## Standard data access

Use Supabase Data API / PostgREST for conventional operations such as:

* Reading catalog data
* Reading profile information
* CRUD for suitable records
* Reading notifications
* Reading orders
* Reading reviews

## Complex domain operations

Use server-side operations such as:

* Database functions / RPC
* Edge Functions where application-level logic or external-service interaction is necessary

Examples include:

* Checkout
* Atomic stock reservation
* Atomic delivery assignment
* Complex coupon calculation
* State-transition operations
* Server-side notification dispatch

---

# 34. Authentication

Supabase Auth is responsible for:

* Registration
* Login
* Session management
* Logout
* Authenticated identity

After authentication, the application loads its domain-level User record.

The authentication identity and application User model are conceptually distinct:

```text
Supabase Auth identity
        ↓
Application User
        ↓
Active Role
```

---

# 35. Authorization

Authorization must be enforced server-side.

The core authorization sequence is:

```text
Authenticated?
    ↓
Correct role?
    ↓
Authorized for target resource?
    ↓
Valid current state?
    ↓
Execute
```

UI visibility is not a security boundary.

---

## 35.1 Customer Authorization

Customers can access only their own:

* Profile
* Addresses
* Cart
* Wishlist
* Orders
* Returns
* Reviews
* Notifications
* Role application

---

## 35.2 Business Authorization

Business operations must be scoped to the authenticated user's Business.

A Business cannot manipulate another Business's:

* Products
* Stock
* BusinessOrders
* Promotions
* Returns

---

## 35.3 Driver Authorization

Drivers may operate only on:

* Available eligible deliveries
* Their own assigned Delivery
* PickupStops belonging to their assigned Delivery

---

## 35.4 Admin Authorization

Admin operations are explicitly defined rather than unrestricted database access.

Admin authority covers management functions such as:

* Role applications
* Categories
* Platform promotions
* Business banner approval
* Reports
* Audit logs
* Platform settings

Admin cannot arbitrarily override operational order/delivery state in the MVP.

---

# 36. Data Model

## Identity

### `users`

Stores application-level user information.

Core fields include:

* `id`
* Profile information
* `active_role`
* `account_status`
* Timestamps

### `role_applications`

Stores:

* User
* Requested role
* Status
* Timestamps

Constraint:

> At most one pending application per user.

---

# 37. Business and Catalog Tables

## `businesses`

Contains:

* Business ID
* Owner User ID
* Business information
* Status
* Timestamps

Constraint:

> One User may own at most one Business.

## `categories`

Supports:

* Global categories
* Parent/child hierarchy

## `products`

Contains:

* Product ID
* Business ID
* Category ID
* Product information
* Base price
* Stock information
* Status
* Timestamps

## `product_variants`

Contains:

* Variant ID
* Product ID
* Attributes
* Price
* Stock
* Status

## `product_images`

Stores image references separately from the core Product record.

---

# 38. Shopping Tables

## `carts`

One active cart per Customer.

## `cart_items`

Contains:

* Cart
* ProductVariant
* Quantity

No duplicate selected variant within the same cart.

## `wishlists`

Customer-owned wishlist container.

## `wishlist_items`

Links wishlist entries to products/variants as required by the implementation.

---

# 39. Order Tables

## `orders`

Contains:

* Customer
* Order reference
* Pricing summary
* Delivery/shipping fee
* Discounts
* Platform fees
* Delivery-address snapshot
* Timestamps

## `business_orders`

Contains:

* BusinessOrder ID
* Order ID
* Business ID
* Business-specific subtotal
* Business-specific discount
* BusinessOrder status
* Timestamps

## `order_items`

Contains:

* BusinessOrder ID
* Product reference
* Variant reference
* Historical product snapshot
* Historical variant snapshot
* Purchased unit price
* Discount
* Quantity
* Line total

---

# 40. Payment Tables

## `payments`

Contains:

* Order reference
* Payment method
* Amount
* Status
* Transaction/reference information
* Payment-proof reference
* Verification information
* Timestamps

There is one Payment for each overall Order.

---

# 41. Delivery Tables

## `deliveries`

Contains:

* Delivery ID
* Order ID
* Assigned Driver
* Delivery state
* Delivery fee
* Driver earning
* Timestamps

## `pickup_stops`

Contains:

* Delivery ID
* BusinessOrder ID
* Sequence
* Pickup state
* Pickup timestamps

The sequence field defines the pickup ordering used by the delivery workflow.

---

# 42. Return Tables

## `return_requests`

Contains:

* Order
* Customer
* Status
* Reason
* Timestamps

## `return_items`

Contains:

* ReturnRequest
* OrderItem
* Requested quantity
* Reason
* Status

---

# 43. Review Table

## `reviews`

Contains:

* OrderItem
* Product
* Customer
* Rating
* Text
* Timestamps

Constraint:

> One Review maximum per OrderItem.

---

# 44. Promotion Tables

## `promotions`

Contains:

* Creator
* Scope
* Business reference where applicable
* Discount configuration
* Banner information
* Approval/status information
* Validity period

## `coupons`

Contains:

* Promotion reference
* Coupon code
* Scope
* Active state
* Expiration information

## `order_coupons`

Preserves the actual coupon application to an order.

Contains:

* Order
* Coupon
* Applicable Business where relevant
* Actual discount amount

This historical amount must remain stable even if the underlying promotion is modified later.

---

# 45. Notification Tables

## `notifications`

Contains:

* Recipient
* Notification type
* Title
* Content
* Read status
* Timestamp

## `device_tokens`

Contains:

* User
* Device token
* Device-related metadata as needed
* Registration/update timestamps

A user may have multiple devices.

---

# 46. Audit and State History

## `audit_logs`

Stores:

* Actor
* Action
* Target
* Timestamp
* Metadata

Audit records support administrative accountability and debugging.

Relevant domain state histories should be retained for:

* BusinessOrder
* Payment
* Delivery
* ReturnRequest

This provides an authoritative timeline of important state transitions rather than relying only on the current state.

---

# 47. Platform Settings

## `platform_settings`

Contains administrator-controlled global configuration, including concepts such as:

* Delivery fee
* Platform commission
* Driver commission
* Payment configuration
* Platform payment account
* Other global platform settings

---

# 48. Storage Model

Supabase Storage is the centralized file-storage mechanism.

Typical file categories include:

* Product images
* Business images
* Promotional assets
* Payment proofs

Binary files remain in Storage.

Database/domain records contain references to those files.

This creates a clear ownership rule:

```text
Storage → owns binary file
Domain record → owns reference
```

Payment proof access must be protected by Storage policies.

---

# 49. External Integrations

## Included

### Supabase

* Auth
* Data API/PostgREST
* RPC/database functions
* Edge Functions
* Storage
* Realtime

### Firebase Cloud Messaging

* Push notifications

---

## Excluded from MVP

* Real banking APIs
* Bakong integration
* Automatic bank reconciliation
* Automatic refund execution
* External courier/logistics APIs
* External warehouse/inventory systems
* Real GPS integration
* Real map tracking infrastructure

Mocked location/map behavior is acceptable for the prototype.

---

# 50. Core Transactional Invariants

The following invariants are fundamental implementation rules.

### Identity

* Every User has exactly one active role.
* Every user defaults to Customer.
* A User owns at most one Business.
* Only one pending role application exists per User.

### Shopping

* A Customer has one active cart.
* A Cart cannot contain duplicate instances of the same selected ProductVariant.

### Orders

* An Order may contain multiple Businesses.
* Each participating Business receives exactly one BusinessOrder.
* BusinessOrders operate independently.
* Payment belongs to the overall Order.
* MVP uses one Delivery per Order.

### Delivery

* Each participating BusinessOrder creates one PickupStop.
* Only one active Driver may be assigned to a Delivery.
* Driver assignment must be atomic.

### Reviews

* Maximum one Review per purchased OrderItem.

### Returns

* Return quantity cannot exceed purchased quantity.

### Inventory

* Stock must be available before reservation.
* Successful order placement creates the reservation atomically.
* Rejected/cancelled BusinessOrders release their reservations.

### Security

* Client state is never the authority for permissions.
* Client-calculated prices are never trusted.
* Client-calculated discounts are never trusted.
* Client-selected roles are never trusted.

---

# 51. Checkout Consistency Requirement

Checkout is one of the most critical transactional boundaries.

The implementation must ensure that these operations either all succeed together or are rolled back together:

```text
Stock validation
+
Stock reservation
+
Order creation
+
BusinessOrder creation
+
OrderItem creation
+
Payment creation
+
Delivery creation
```

The system must avoid states such as:

```text
Stock reserved
BUT
Order missing
```

or:

```text
Order created
BUT
Payment missing
```

or:

```text
BusinessOrder created
BUT
its corresponding OrderItem is missing
```

---

# 52. State Ownership Principle

Each domain state belongs to the entity that actually owns the behavior.

Examples:

```text
BusinessOrder → Business processing state
Payment       → Payment state
Delivery      → Delivery state
ReturnRequest → Return workflow state
```

Do not duplicate these states into a giant `Order.status` field and attempt to keep every copy synchronized.

The overall Order is primarily a parent/container from which customer-facing status can be derived.

---

# 53. Server Authority Principle

The Flutter client is responsible for:

* UI
* User interaction
* Local presentation state
* Request initiation
* Displaying server results

The server/database layer is authoritative for:

* Authorization
* Product validity
* Prices
* Stock
* Coupon calculations
* Order creation
* Payment state
* Delivery assignment
* State transition validity
* Historical transaction data

The client may provide previews, but authoritative business decisions happen server-side.

---

# 54. Realtime Authority Principle

Realtime messages are synchronization signals.

They are not commands and they are not permanent truth.

A realtime event such as:

```text
BusinessOrder updated
```

means the Flutter client should synchronize its view.

The database remains authoritative.

---

# 55. Historical Data Integrity

Once a transaction has occurred, mutable current records must not rewrite historical meaning.

Therefore:

* OrderItem snapshots preserve purchased product information.
* Order snapshots preserve checkout address.
* Historical Business information is retained.
* Applied coupon discounts are preserved.
* Purchased prices remain immutable.
* Archived Products remain referenceable.

Historical data should remain understandable even when current catalog/business information changes.

---

# 56. MVP Boundary

The implementation intentionally stops before introducing unnecessary real-world complexity.

The MVP does **not** implement:

* Real payment processor integration
* Automatic refund processing
* Bank reconciliation
* External logistics
* Real courier network integration
* Real GPS tracking
* Warehouse synchronization
* Internal wallet/balance
* Advanced coupon stacking logic
* Complex product-level promotion targeting
* Business review replies
* Review dispute/report systems
* Arbitrary admin order-state editing

These boundaries are intentional and should not be silently reintroduced during implementation.

---

# 57. Conceptual End-to-End Flow

## Registration

```text
Register
  ↓
Supabase Auth
  ↓
Create Application User
  ↓
active_role = Customer
```

## Role upgrade

```text
Customer
  ↓
Submit Role Application
  ↓
Admin Review
  ↓
Approve
  ↓
active_role changes
```

## Shopping

```text
Browse
  ↓
Product
  ↓
Variant
  ↓
Cart
  ↓
Coupon Validation
  ↓
Checkout
```

## Multi-vendor checkout

```text
Cart
 ├── Business A item
 ├── Business B item
 └── Business C item
       ↓
Create Order
       ↓
BusinessOrder A
BusinessOrder B
BusinessOrder C
       ↓
One Payment
       ↓
One Delivery
       ↓
PickupStop A
PickupStop B
PickupStop C
```

## Fulfillment

```text
BusinessOrder
    ↓
Accepted
    ↓
Preparing
    ↓
Ready
    ↓
Driver PickupStop
    ↓
Driver completes delivery
```

## Return

```text
Delivered Order
      ↓
Customer Return Request
      ↓
Return Items
      ↓
Business Approves / Rejects
      ↓
RefundRequired where applicable
```

---

# 58. Required Core Contracts

The implementation must expose or support the following conceptual operations.

## Authentication / Profile

* GetMyProfile
* UpdateMyProfile
* GetMyAddresses
* CreateAddress
* UpdateAddress
* DeleteAddress

## Role

* GetMyRoleApplication
* SubmitRoleApplication
* GetPendingRoleApplications
* ApproveRoleApplication
* RejectRoleApplication

## Business

* GetMyBusiness
* UpdateMyBusiness
* GetMyProducts
* CreateProduct
* UpdateProduct
* ArchiveProduct
* UpdateProductStock
* GetMyBusinessOrders
* AcceptBusinessOrder
* RejectBusinessOrder
* MarkBusinessOrderPreparing
* MarkBusinessOrderReady
* GetBusinessAnalytics
* GetBusinessReturns
* ApproveReturn
* RejectReturn

## Catalog

* GetCategories
* GetBusinesses
* GetProducts
* GetProduct
* SearchProducts
* FilterProducts
* SortProducts
* GetProductReviews
* GetRelatedProducts

## Shopping

* GetMyCart
* AddCartItem
* UpdateCartItem
* RemoveCartItem
* ClearCart
* GetMyWishlist
* AddWishlistItem
* RemoveWishlistItem

## Coupons

* ValidateCoupon

## Checkout

* CreateOrderFromCart

## Payment

* SubmitPaymentProof

## Orders

* GetMyOrders
* GetOrder
* CancelOrder
* RequestReturn
* GetReturn
* SubmitReview

## Delivery

* GetAvailableDeliveries
* AcceptDelivery
* GetMyDelivery
* RejectDelivery
* MarkPickupStopComplete
* StartDelivery
* MarkDelivered
* GetDeliveryHistory
* GetDeliveryPickupStops
* GetPickupStop

## Reviews

* CreateReview
* GetProductReviews

## Promotions

* CreatePromotion
* UpdatePromotion
* SubmitBannerForApproval
* GetMyPromotions
* CreatePlatformPromotion
* ApproveBusinessBanner
* RejectBusinessBanner
* EditBusinessBanner
* DisableBusinessBanner

## Notifications

* GetMyNotifications
* MarkNotificationRead
* MarkAllNotificationsRead

---

# 59. Final Implementation Contract

The implementation should preserve the following architectural facts above all else:

```text
One Flutter app
        ↓
Four roles
        ↓
One active role per user
        ↓
One Business per Business user
        ↓
Multi-vendor cart
        ↓
One Order
        ↓
Multiple BusinessOrders
        ↓
One Payment
        ↓
One Delivery
        ↓
Multiple PickupStops
```

And:

```text
Supabase Auth
        +
Supabase Data API / PostgREST
        +
RPC / Database Functions / Edge Functions
        +
Supabase Storage
        +
Supabase Realtime
        +
FCM
```

The backend remains authoritative for business rules, authorization, stock, pricing, discounts, state transitions, and transactional consistency.

The MVP deliberately uses mocked/externalized behavior for real banking, refunds, logistics, and GPS so that implementation complexity remains bounded while preserving a domain model capable of supporting those capabilities later.
