# E-commerce order data — SQL queries

## 1. Show related sales_order, customer, order_line, product records (up to 20).

```sql
SELECT t0."order_id" AS "sales_order_order_id",
       t0."placed_at" AS "sales_order_placed_at",
       t3."customer_id" AS "customer_customer_id",
       t3."email" AS "customer_email",
       t1."line_id" AS "order_line_line_id",
       t1."quantity" AS "order_line_quantity",
       t2."product_id" AS "product_product_id",
       t2."sku" AS "product_sku"
FROM portfolio."sales_order" t0
JOIN portfolio."order_line" t1 ON t1."order_id" = t0."order_id"
JOIN portfolio."product" t2 ON t1."product_id" = t2."product_id"
JOIN portfolio."customer" t3 ON t0."customer_id" = t3."customer_id"
ORDER BY t0."order_id", t3."customer_id", t1."line_id", t2."product_id"
LIMIT 20;
```

| sales_order_order_id | sales_order_placed_at | customer_customer_id | customer_email | order_line_line_id | order_line_quantity | product_product_id | product_sku |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 4 | 2026-02-01T14:30:00+00:00 | 1 | alex@example.test | 5 | 2 | 2 | SKU-100 |

## 2. Find customer records where email matches "alex@example.test" (up to 20).

```sql
SELECT * FROM portfolio."customer"
WHERE "email" IS NOT DISTINCT FROM 'alex@example.test'
ORDER BY "customer_id"
LIMIT 20;
```

| customer_id | email | region | created_at |
| --- | --- | --- | --- |
| 1 | alex@example.test | north | 2026-01-10T09:00:00+00:00 |

## 3. Count sales_order records for each customer_id (up to 20 groups).

```sql
SELECT "customer_id", count(*) AS record_count
FROM portfolio."sales_order"
GROUP BY "customer_id"
ORDER BY record_count DESC, "customer_id" NULLS LAST
LIMIT 20;
```

| customer_id | record_count |
| --- | --- |
| 1 | 1 |

## 4. Find sales_order records where placed_at matches "2026-02-01T14:30:00Z" (up to 20).

```sql
SELECT * FROM portfolio."sales_order"
WHERE "placed_at" IS NOT DISTINCT FROM '2026-02-01T14:30:00Z'
ORDER BY "order_id"
LIMIT 20;
```

| order_id | customer_id | placed_at | status | total_amount |
| --- | --- | --- | --- | --- |
| 4 | 1 | 2026-02-01T14:30:00+00:00 | completed | 39.9 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 2.605 | 2.605, 5.857, 2.499 | Sort → Seq Scan | 274 |
| After index | 0.272 | 0.272, 0.275, 0.272 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 55 |

The median execution time changed from 2.605 ms to 0.272 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=2.572..2.575 rows=50 loops=1)
  Seq Scan on sales_order (actual time=0.015..2.532 rows=50 loops=1)
Planning Time: 0.399 ms
Execution Time: 2.605 ms
```

### Before index, run 2

```text
Sort (actual time=5.771..5.775 rows=50 loops=1)
  Seq Scan on sales_order (actual time=0.419..5.699 rows=50 loops=1)
Planning Time: 0.671 ms
Execution Time: 5.857 ms
```

### Before index, run 3

```text
Sort (actual time=2.466..2.468 rows=50 loops=1)
  Seq Scan on sales_order (actual time=0.015..2.423 rows=50 loops=1)
Planning Time: 0.379 ms
Execution Time: 2.499 ms
```

### After index, run 1

```text
Sort (actual time=0.21..0.212 rows=50 loops=1)
  Bitmap Heap Scan on sales_order (actual time=0.031..0.171 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.015..0.015 rows=50 loops=1)
Planning Time: 0.628 ms
Execution Time: 0.272 ms
```

### After index, run 2

```text
Sort (actual time=0.21..0.213 rows=50 loops=1)
  Bitmap Heap Scan on sales_order (actual time=0.031..0.17 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.015..0.016 rows=50 loops=1)
Planning Time: 0.607 ms
Execution Time: 0.275 ms
```

### After index, run 3

```text
Sort (actual time=0.213..0.215 rows=50 loops=1)
  Bitmap Heap Scan on sales_order (actual time=0.03..0.173 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.015..0.015 rows=50 loops=1)
Planning Time: 0.633 ms
Execution Time: 0.272 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Akanji_John_301907266_P2_Queries.sql, then Akanji_John_301907266_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Akanji_John_301907266_P2_QueryResults.png) · [Index comparison](screenshots/Akanji_John_301907266_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

