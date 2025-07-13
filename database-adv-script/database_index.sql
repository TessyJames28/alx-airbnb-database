-- Create an index on Review Table for rating field
-- To enhance performance of queries filtering by rating

CREATE INDEX idx_review_rating ON Review(rating);

--- Meansure the query performance before and after adding indexes using explain

-- Before adding index
EXPLAIN SELECT * FROM Review WHERE rating >= 4;

+----+-------------+--------+------------+------+---------------+------+---------+------+------+----------+-------------+
| id | select_type | table  | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra       |
+----+-------------+--------+------------+------+---------------+------+---------+------+------+----------+-------------+
|  1 | SIMPLE      | Review | NULL       | ALL  | NULL          | NULL | NULL    | NULL |   31 |    33.33 | Using where |
+----+-------------+--------+------------+------+---------------+------+---------+------+------+----------+-------------+
1 row in set, 1 warning (0.02 sec)

-- After adding index
EXPLAIN SELECT * FROM Review WHERE rating >= 4;

+----+-------------+--------+------------+-------+-------------------+-------------------+---------+------+------+----------+-----------------------+
| id | select_type | table  | partitions | type  | possible_keys     | key           
    | key_len | ref  | rows | filtered | Extra                 |
+----+-------------+--------+------------+-------+-------------------+-------------------+---------+------+------+----------+-----------------------+
|  1 | SIMPLE      | Review | NULL       | range | idx_review_rating | idx_review_rating | 4       | NULL |   13 |   100.00 | Using index condition |
+----+-------------+--------+------------+-------+-------------------+-------------------+---------+------+------+----------+-----------------------+
1 row in set, 1 warning (0.00 sec)


--- Analyze the query performance

EXPLAIN ANALYZE SELECT * FROM Review WHERE rating >= 4;

+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| EXPLAIN                                                                            
                                                                                     
              |
---------------------------------------------------------------------------------------------------+
| -> Index range scan on Review using idx_review_rating over (4 <= rating), with index condition: (review.rating >= 4)  (cost=6.11 rows=13) (actual time=0.114ndex condition: (review.rating >= 4)  (cost=6.11 rows=13) (actual time=0.114..0ndex condition: (review.rating >= 4)  (cost=6.11 rows=13) (actual time=0.114..0.338 rows=13 loops=1)
 |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.01 sec)
