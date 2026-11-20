# Republic of the Philippines
## PARTIDO STATE UNIVERSITY
Goa, Camarines Sur

# Laundry Shop Management System (LSMS)

## 1. The Problem

Laundry shops need an organized way to manage customers, staff, services, orders, and payments. Manual recordkeeping can cause errors, misplaced records, and delays in tracking laundry orders. This system will help make daily laundry shop operations easier and more organized.

## 2. Users and What They Need to Do

| User Role | What They Need to Do |
|---|---|
| Customer | View available services, check laundry order status, and view payment information. |
| Cashier | Register customers, create laundry orders, and record payments. |
| Laundry attendant | View assigned orders and update laundry status. |
| Manager/Admin | Manage staff, services, service types, and monitor orders and payments. |

## 3. The Database Behind It

**Database Name:** `laundry_shop_db`

**Number of Tables:** 7

1. **customer** – Stores customer names, phone numbers, addresses, and registration dates.
2. **staff** – Stores staff information, roles, contact numbers, and active status.
3. **service_type** – Stores service categories such as Laundry, Specialty, Bedding, and Finishing.
4. **service** – Stores laundry service names, prices, pricing units, and turnaround hours.
5. **laundry_order** – Stores customer orders, assigned staff, order dates, due dates, and order statuses.
6. **order_item** – Stores the services included in each order, quantities, prices, weights, and subtotals.
7. **payment** – Stores payment dates, amounts, payment methods, and reference numbers.

## 4. Must-Have Features

1. **Customer Management** – Stores customer names, phone numbers, addresses, and registration dates.
2. **Staff Management** – Stores staff names, roles, phone numbers, and active status.
3. **Service Management** – Stores laundry services, categories, prices, pricing units, and turnaround hours.
4. **Laundry Order Management** – Records customer orders, assigned staff, order dates, due dates, and order statuses.
5. **Order Item Management** – Records services per order, quantities, weights, unit prices, and subtotals.
6. **Payment Management** – Records payment amounts, dates, methods, and reference numbers.
7. **Order and Payment Reports** – Uses SQL queries to calculate order totals, paid amounts, balances, service revenue, customer spending, and daily revenue.
8. **Order Tracking** – Retrieves orders currently being processed, including their status and due dates.

## 5. Similar Apps I Looked At

1. **CleanCloud** – We borrow its organized order management and laundry tracking features.
2. **Laundryheap** – We borrow its simple service browsing and customer-friendly interface.
