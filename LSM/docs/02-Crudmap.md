# CRUD Map

This CRUD map describes the **proposed website design**: which operations each table is expected to support, which pages will use the table, and which user roles are planned to have access.

| TABLE | C (Create) | R (Read) | U (Update) | D (Delete) | PAGES | WHO |
|---|:---:|:---:|:---:|:---:|---|---|
| `customer` | ✓ | ✓ | ✓ | ✓ | customers-list, customer-form, customer-view | Cashier: all |
| `staff` | ✓ | ✓ | ✓ | ✓ | staff-list, staff-form, staff-view | Manager: all; Cashier: R |
| `service_type` | ✓ | ✓ | ✓ | ✓ | service-types (list + form) | Manager: all; Cashier: R |
| `service` | ✓ | ✓ | ✓ | ✓ | services-list, service-form, service-view | Manager: all; Cashier: C, R |
| `laundry_order` | ✓ | ✓ | ✓ | — | orders-list, order-view, order-form | Cashier: C, R, U; Attendant: R, U status; Manager: R, U |
| `order_item` | ✓ | ✓ | ✓ | ✓ | order-items (inside order form/view) | Cashier: all; Attendant: R |
| `payment` | ✓ | ✓ | ✓ | ✓ | payment-form, payment-history | Cashier: C, R, U; Manager: R, U |

## Notes

- **C** = Create, **R** = Read, **U** = Update, **D** = Delete.
- “All” means all CRUD operations shown for that table.
- For `laundry_order`, Delete is marked as unavailable (`—`).
- Attendants are planned to have permission to read orders and update order status.
- User roles and permissions are part of the proposed system design and are **not yet enforced in the current SQL database**.
