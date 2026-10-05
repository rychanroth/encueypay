# Assignment: E-Commerce Mobile Application

The E-Commerce App assignment is designed for mobile application development practice, covering Product Management, Category Management, Product Discovery, Search, Filter, Wishlist, Shopping Cart, Checkout, Shipping Address, Payment Method, Order Management, and Order Tracking. The core objective is to understand key mobile commerce workflows and correctly implement business logic, data modeling, state management, navigation, validation, and user experience within a mobile app.

---

## 1. Core Workflows & User Profiles

* **End-to-End User Flow:** Supports registration, login, authentication, product search, category selection, product lists, product details, wishlist management, cart operations, quantity management, checkout, shipping address selection, payment method selection, order confirmation, order history, and order tracking.


* **User Information Management:** Manages User ID, Full Name, Gender, Date of Birth, Phone Number, Email, Profile Photo, Address, and Account Status.


* **User Capabilities:** Allows users to edit profiles, change passwords, manage shipping addresses, and review order history based on assigned permissions.



---

## 2. Product Discovery & Navigation

* **Home Screen:** Displays Featured Products, New Arrivals, Best Sellers, Popular Categories, Flash Sales, Special Offers, Recommended Products, and Recently Viewed Products. Includes an intuitive Search Bar and navigation for rapid discovery.


* **Categories & Subcategories:** Supports Category ID, Category Name, Description, Image, Icon, and Status. Products link to categories or subcategories for organized browsing.


* **Search, Filtering & Sorting:**
* **Search:** Enables discovery by product name, category, brand, price range, rating, availability, or keyword.


* **Filters:** Supports category, brand, price, rating, and stock status filters.


* **Sorting:** Provides sorting by Latest, Popular, Price (Low to High), Price (High to Low), and Highest Rating.





---

## 3. Product Catalog & Details

* **Product Attributes:** Manages Product ID, Product Name, Product Code, Category, Brand, Image, Description, Price, Discount Price, Stock Quantity, Rating, and Product Status.


* **Media & Variants:** Supports multiple product images and variants (e.g., Size, Color, Model).


* **Product Detail Screen:** Displays product image galleries, name, price, discount, description, rating, stock availability, variant selector, and related products. Users can select variants, adjust quantities, add items to the wishlist, or add items directly to the cart.



---

## 4. Wishlist & Shopping Cart

* **Wishlist:** Enables users to save products for later, remove items, or transfer saved items directly to the shopping cart.


* **Shopping Cart:** Allows users to add items, remove items, update quantities, and select product variants.


* **Cart Calculations:** Dynamically displays Unit Price, Quantity, Subtotal, Discount, Shipping Fee, and Grand Total.


* **Validation:** Enforces quantity and stock availability validations prior to checkout.



---

## 5. Pricing, Coupons & Promotions

* **Calculation Engine:** Accurately computes Product Price, Quantity, Subtotal, Item Discounts, Coupon Discounts, Shipping Fees, Mock Tax, and Grand Total with instant updates upon cart mutation.


* **Coupons & Promotions:** Supports coupon application at checkout. Coupon attributes include Coupon ID, Coupon Code, Discount Type, Discount Value, Minimum Order Amount, Start Date, End Date, and Status. Validates coupons prior to applying discounts.



---

## 6. Checkout, Shipping & Payments

* **Shipping Address Management:** Allows users to add, edit, delete, set default addresses, and select delivery locations. Fields include Full Name, Phone Number, Province/City, District, Commune, Street, House Number, Postal Code, and Mock Geolocation.


* **Checkout Workflow:** Enforces a multi-step sequence containing Cart Review, Shipping Address, Shipping Method, Payment Method, Coupon, Order Note, and Order Summary. Validates cart items, stock levels, addresses, and required fields before placing orders.


* **Payment Simulations:** Supports mock payment methods including Cash on Delivery, Card Payment Prototype, and QR Payment Prototype. Payment statuses include Pending, Paid, Failed, Refunded, and Cancelled.



---

## 7. Order Lifecycle, Tracking & Returns

* **Order Creation:** Generates a unique Order ID and records user info, order items, quantities, unit prices, subtotal, discount, shipping fee, total amount, shipping address, payment method, order date, and order status.


* **Order Statuses:** Includes Pending, Confirmed, Processing, Packed, Shipped, Out for Delivery, Delivered, Cancelled, and Returned. Displays a visual status timeline for tracking progress.


* **Order Confirmation:** Displays an Order Confirmation Screen containing Order ID, Order Date, Total Amount, Shipping Address, Payment Method, and Mock Estimated Delivery Date.


* **Order History:** Provides filtered views for Active, Completed, Cancelled, and Returned orders with detail view access.


* **Order Tracking:** Displays real-time progress, estimated delivery dates, courier details, and mock tracking numbers via step-progress indicators.


* **Order Cancellation:** Allows users to cancel eligible orders with recorded reasons, cancellation dates, and status updates.


* **Return & Refund Prototype:** Enables users to select delivered items, submit return reasons, and track requests through statuses (Requested, Under Review, Approved, Rejected, Completed).


* **Ratings & Reviews:** Allows post-delivery product rating and review submission with aggregate product rating calculations.



---

## 8. Security, Roles & Administrative Features

* **Security & Auth:** Incorporates authentication, authorization, session management, data validation, and secure storage. Restricts customers to their own data.


* **Role Prototypes:**
* **Customer:** Accesses personalized Wishlist, Cart, Address Book, and Order History.


* **Admin Role Prototype:** Manages Products, Categories, Orders, and System Reports based on assigned permissions.




* **Dashboards:**
* **Customer Dashboard:** Displays recent orders, active orders, wishlist count, cart items, and total spending.


* **Admin Dashboard Prototype:** Displays Total Products, Total Orders, Total Customers, Total Sales, Low-Stock Products, Best-Selling Products, and Sales Trends.




* **Notifications:** Supports local or in-app notifications for order updates, payment statuses, delivery stages, promotions, and coupons.


* **Audit Trails & Activity Logs:** Tracks key actions (e.g., Cart Additions, Wishlist Updates, Order Creation, Payment Changes, Order Status Updates, Cancellations) for educational audit trail concepts.


* **Reporting & Analytics:** Generates daily, weekly, or monthly KPI summaries covering Total Orders, Completed Orders, Cancelled Orders, Total Sales, Average Order Value, Best-Selling Products, Low-Stock Products, Top Categories, and Customer Purchase Frequency.


* **Error Handling & UI States:** Handles authentication failures, missing products, out-of-stock events, invalid inputs, empty carts, bad coupons, payment/order failures, and network errors. Mandates loading indicators, success messages, error banners, empty states, and retry actions across all screens.