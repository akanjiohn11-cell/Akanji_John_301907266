-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. customer pk reject. Expected: pk_customer, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("customer_id", "email", "region", "created_at")
VALUES (1, 'different@example.test', 'south', '2026-03-01T09:00:00Z');

-- 2. customer email reject. Expected: uq_customer_0, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("customer_id", "email", "region", "created_at")
VALUES (10, 'alex@example.test', 'south', '2026-03-02T09:00:00Z');

-- 3. customer email not null reject. Expected: email, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("customer_id", "email", "region", "created_at")
VALUES (11, NULL, 'south', '2026-03-03T09:00:00Z');

-- 4. product pk reject. Expected: pk_product, SQLSTATE 23505.
INSERT INTO portfolio."product" ("product_id", "sku", "name", "unit_price", "active")
VALUES (2, 'SKU-300', 'Mug', 8.25, TRUE);

-- 5. product sku reject. Expected: uq_product_0, SQLSTATE 23505.
INSERT INTO portfolio."product" ("product_id", "sku", "name", "unit_price", "active")
VALUES (12, 'SKU-100', 'Different lamp', 21, TRUE);

-- 6. sales order pk reject. Expected: pk_sales_order, SQLSTATE 23505.
INSERT INTO portfolio."sales_order" ("order_id", "customer_id", "placed_at", "status", "total_amount")
VALUES (4, 1, '2026-03-04T10:00:00Z', 'completed', 10);

-- 7. sales order customer fk reject. Expected: fk_sales_order_0, SQLSTATE 23503.
INSERT INTO portfolio."sales_order" ("order_id", "customer_id", "placed_at", "status", "total_amount")
VALUES (14, 999, '2026-03-05T10:00:00Z', 'completed', 10);

-- 8. order line pk reject. Expected: pk_order_line, SQLSTATE 23505.
INSERT INTO portfolio."order_line" ("line_id", "order_id", "product_id", "quantity", "unit_price")
VALUES (5, 4, 3, 1, 4.5);

-- 9. order line pair reject. Expected: uq_order_line_0, SQLSTATE 23505.
INSERT INTO portfolio."order_line" ("line_id", "order_id", "product_id", "quantity", "unit_price")
VALUES (15, 4, 2, 1, 19.95);

-- 10. order line order fk reject. Expected: fk_order_line_0, SQLSTATE 23503.
INSERT INTO portfolio."order_line" ("line_id", "order_id", "product_id", "quantity", "unit_price")
VALUES (16, 999, 3, 1, 4.5);

-- 11. order line product fk reject. Expected: fk_order_line_1, SQLSTATE 23503.
INSERT INTO portfolio."order_line" ("line_id", "order_id", "product_id", "quantity", "unit_price")
VALUES (17, 4, 999, 1, 4.5);

-- 12. order line quantity reject. Expected: line_quantity_positive, SQLSTATE 23514.
INSERT INTO portfolio."order_line" ("line_id", "order_id", "product_id", "quantity", "unit_price")
VALUES (18, 4, 3, 0, 4.5);

-- 13. sales order total reject. Expected: order_total_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."sales_order" ("order_id", "customer_id", "placed_at", "status", "total_amount")
VALUES (19, 1, '2026-03-06T10:00:00Z', 'completed', -1);
