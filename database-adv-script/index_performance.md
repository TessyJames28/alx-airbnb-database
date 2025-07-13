# 📊 MySQL Query Performance Analysis (`Review` Table)

This document presents the full analysis of a query executed on the `Review` table using `EXPLAIN`, index creation, and `EXPLAIN ANALYZE`. All content below includes raw SQL commands, MySQL output, and explanations written inline.

---

```sql
-- Initial EXPLAIN without index
mysql> EXPLAIN SELECT * FROM Review WHERE rating >= 4;
+----+-------------+--------+------------+------+---------------+------+---------+------+------+----------+-------------+
| id | select_type | table  | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra       |
+----+-------------+--------+------------+------+---------------+------+---------+------+------+----------+-------------+
|  1 | SIMPLE      | Review | NULL       | ALL  | NULL          | NULL | NULL    | NULL |   31 |    33.33 | Using where |
+----+-------------+--------+------------+------+---------------+------+---------+------+------+----------+-------------+
1 row in set, 1 warning (0.02 sec)
```

-- Explanation:
-- MySQL performs a full table scan (type = ALL), examining all 31 rows.
-- No index is used (key = NULL), making this query inefficient on large datasets.


-- Create index on rating column
```sql
mysql> CREATE INDEX idx_review_rating ON Review(rating);
Query OK, 0 rows affected (0.63 sec)
Records: 0  Duplicates: 0  Warnings: 0
```

-- Explanation:
-- An index named `idx_review_rating` is created on the `rating` column to improve performance
-- for queries filtering by rating.


-- Re-run EXPLAIN after index creation

---
```sql

mysql> EXPLAIN SELECT * FROM Review WHERE rating >= 4;
+----+-------------+--------+------------+-------+-------------------+-------------------+---------+------+------+----------+-----------------------+
| id | select_type | table  | partitions | type  | possible_keys     | key               | key_len | ref  | rows | filtered | Extra                 |
+----+-------------+--------+------------+-------+-------------------+-------------------+---------+------+------+----------+-----------------------+
|  1 | SIMPLE      | Review | NULL       | range | idx_review_rating | idx_review_rating | 4       | NULL |   13 |   100.00 | Using index condition |
+----+-------------+--------+------------+-------+-------------------+-------------------+---------+------+------+----------+-----------------------+
1 row in set, 1 warning (0.00 sec)
```

-- Explanation:
-- MySQL now uses the index (`key = idx_review_rating`) and performs a range scan (type = range),
-- only examining rows where `rating >= 4`. This improves performance significantly.

-- Run EXPLAIN ANALYZE

```sql
mysql> EXPLAIN ANALYZE SELECT * FROM Review WHERE rating >= 4;
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| EXPLAIN                                                                            
                                                                                      
              |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| -> Index range scan on Review using idx_review_rating over (4 <= rating), with index condition: (review.rating >= 4)  (cost=6.11 rows=13) (actual time=0.114..0.338 rows=13 loops=1)
 |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.01 sec)
```

-- Explanation:
-- This confirms the query is using the index efficiently.
-- It scanned only 13 rows (not the full table) and returned matching rows in ~0.11–0.33 ms.
-- Index condition was applied directly during scan, ensuring fast performance.
