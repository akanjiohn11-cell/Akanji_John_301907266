# E-commerce order data — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| customer_id | sales_order records (list) |
| --- | --- |
| 1 | [4] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| sales_order.order_id | sales_order.customer_id | sales_order.status | customer.customer_id | customer.email |
| --- | --- | --- | --- | --- |
| 4 | 1 | completed | 1 | alex@example.test |

Key: order_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## sales_order_example

| sales_order.order_id | sales_order.customer_id | sales_order.status | customer.customer_id | customer.email |
| --- | --- | --- | --- | --- |
| 4 | 1 | completed | 1 | alex@example.test |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## customer

| customer_id | email | region | created_at |
| --- | --- | --- | --- |
| 1 | alex@example.test | north | 2026-01-10T09:00:00+00:00 |

## product

| product_id | sku | name | unit_price | active |
| --- | --- | --- | --- | --- |
| 2 | SKU-100 | Desk lamp | 19.95 | true |
| 3 | SKU-200 | Notebook | 4.5 | true |

## sales_order

| order_id | customer_id | placed_at | status | total_amount |
| --- | --- | --- | --- | --- |
| 4 | 1 | 2026-02-01T14:30:00+00:00 | completed | 39.9 |

## order_line

| line_id | order_id | product_id | quantity | unit_price |
| --- | --- | --- | --- | --- |
| 5 | 4 | 2 | 2 | 19.95 |

## Dependencies

- customer: (customer_id) → email, region, created_at
- product: (product_id) → sku, name, unit_price, active
- sales_order: (order_id) → customer_id, placed_at, status, total_amount
- order_line: (line_id) → order_id, product_id, quantity, unit_price

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
