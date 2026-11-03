-- Fictional sample records for E-commerce order data.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."customer" ("customer_id", "email", "region", "created_at") VALUES (1, 'alex@example.test', 'north', '2026-01-10T09:00:00Z');
INSERT INTO portfolio."product" ("product_id", "sku", "name", "unit_price", "active") VALUES (2, 'SKU-100', 'Desk lamp', 19.95, TRUE);
INSERT INTO portfolio."product" ("product_id", "sku", "name", "unit_price", "active") VALUES (3, 'SKU-200', 'Notebook', 4.5, TRUE);
INSERT INTO portfolio."sales_order" ("order_id", "customer_id", "placed_at", "status", "total_amount") VALUES (4, 1, '2026-02-01T14:30:00Z', 'completed', 39.9);
INSERT INTO portfolio."order_line" ("line_id", "order_id", "product_id", "quantity", "unit_price") VALUES (5, 4, 2, 2, 19.95);
COMMIT;
