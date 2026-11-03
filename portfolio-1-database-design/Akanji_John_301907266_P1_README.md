# Portfolio 1 — Database Design and Modelling

I organised the data into customer, product, sales_order, order_line. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| customer | 1 |
| product | 2 |
| sales_order | 1 |
| order_line | 1 |

The 13 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](Akanji_John_301907266_P1_Design.md)
- [ER diagram](Akanji_John_301907266_P1_ERDiagram.md)
- [Normalisation](Akanji_John_301907266_P1_Normalisation.md)
- [Schema](Akanji_John_301907266_P1_Schema.sql)
- [Sample data](Akanji_John_301907266_P1_SampleData.sql)
- [Constraint tests](Akanji_John_301907266_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/Akanji_John_301907266_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)

