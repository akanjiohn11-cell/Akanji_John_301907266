# E-commerce order data — database design

My case study records customer, product, sales_order, order_line.

## Users

- Shoppers placing and reviewing orders
- Catalog managers maintaining product information
- Order support analysts reviewing order activity

## Main operations

- Record an order and its product lines
- Find a customer's orders within a date range
- Summarize units sold and revenue by product

## Entities

| Entity | Information stored |
| --- | --- |
| customer | Stores synthetic customer contact and registration details. |
| product | Stores synthetic catalog items and their current prices. |
| sales_order | Records order-level details and references the customer who placed the order. |
| order_line | Records each product and captured price in an order. |

## customer

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| customer_id | BIGINT | PK | Yes |
| email | TEXT | Unique | Yes |
| region | TEXT |  | Yes |
| created_at | TIMESTAMPTZ |  | Yes |
- Unique key: (email).

## product

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| product_id | BIGINT | PK | Yes |
| sku | TEXT | Unique | Yes |
| name | TEXT |  | Yes |
| unit_price | NUMERIC(18,2) |  | Yes |
| active | BOOLEAN |  | Yes |
- Unique key: (sku).

## sales_order

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| order_id | BIGINT | PK | Yes |
| customer_id | BIGINT | FK | Yes |
| placed_at | TIMESTAMPTZ |  | Yes |
| status | TEXT |  | Yes |
| total_amount | NUMERIC(18,2) |  | Yes |
- customer_id → customer.customer_id

## order_line

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| line_id | BIGINT | PK | Yes |
| order_id | BIGINT | FK | Yes |
| product_id | BIGINT | FK | Yes |
| quantity | INTEGER |  | Yes |
| unit_price | NUMERIC(18,2) |  | Yes |
- order_id → sales_order.order_id
- product_id → product.product_id
- Unique key: (order_id, product_id).

## Relationships and business rules

- Each customer email address must be unique.
- Every order must reference an existing customer.
- Every order line must have a quantity greater than zero.
- A product may appear at most once in an order; enforce uniqueness of the order_id and product_id pair.
- An order total must be greater than or equal to zero.

## Assumptions

- Identifiers are synthetic UUIDs and globally unique across all entity types.
- A product's current catalog price may change; each order line stores the unit price captured when the order was placed.
- The worked normalization example starts with sales_order, which references customer through customer_id. Split customer email and region into customer, and keep only customer_id and order-specific attributes in sales_order; do not repeat customer attributes in the order relation.

