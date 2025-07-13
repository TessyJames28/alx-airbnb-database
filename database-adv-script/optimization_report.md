# Query Optimization Report

-- Initial Query

```sql
SELECT
    b.booking_id,
    u.first_name,
    u.last_name,
    p.name AS property_name,
    pay.amount,
    pay.payment_method
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN Payment pay ON b.booking_id = pay.booking_id
```

-- Results

```
id      select_type     table   partitions      type    possible_keys   key   key_len  ref     rows    filtered        Extra
1       SIMPLE  pay     NULL    ALL     fk_booking      NULL    NULL    NULL  33       100.00  NULL
1       SIMPLE  b       NULL    eq_ref  PRIMARY,fk_property,fk_user     PRIMAR144      airbnb_clone_db.pay.booking_id  1       100.00  NULL
1       SIMPLE  p       NULL    eq_ref  PRIMARY PRIMARY 144     airbnb_clone_db.b.property_id  1       100.00  NULL
1       SIMPLE  u       NULL    eq_ref  PRIMARY PRIMARY 144     airbnb_clone_db.b.user_id      1       100.00  NULL
```

-- Explanation

-> Nested loop inner join  (cost=38.2 rows=33) (actual time=0.311..1.05 rows=33 loops=1)
    -> Nested loop inner join  (cost=26.7 rows=33) (actual time=0.199..0.654 rows=33 loops=1)
        -> Nested loop inner join  (cost=15.1 rows=33) (actual time=0.106..0.401 rows=33 loops=1)
            -> Table scan on pay  
               (cost=3.55 rows=33) 
               (actual time=0.0745..0.133 rows=33 loops=1)
            -> Single-row index lookup on b using PRIMARY (booking_id=pay.booking_id)  
               (cost=0.253 rows=1) 
               (actual time=0.00736..0.00746 rows=1 loops=33)
        -> Single-row index lookup on p using PRIMARY (property_id=b.property_id)  
           (cost=0.253 rows=1) 
           (actual time=0.00701..0.00709 rows=1 loops=33)
    -> Single-row index lookup on u using PRIMARY (user_id=b.user_id)  
       (cost=0.253 rows=1) 
       (actual time=0.0113..0.0114 rows=1 loops=33)


-- Optimized query

```sql
SELECT
    b.booking_id,
    u.first_name,
    u.last_name,
    p.name AS property_name,
    pay.amount,
    pay.payment_method
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
LEFT JOIN Property p ON b.property_id = p.property_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE b.status = 'confirmed'
```

-- Result:
id      select_type     table   partitions      type    possible_keys   key     key_len ref     rows    filtered        Extra
1       SIMPLE  b       NULL    ALL     fk_user NULL    NULL    NULL    103     33.33   Using where
1       SIMPLE  u       NULL    eq_ref  PRIMARY PRIMARY 144     airbnb_clone_db.b.user_id       1       100.00  NULL
1       SIMPLE  p       NULL    eq_ref  PRIMARY PRIMARY 144     airbnb_clone_db.b.property_id   1       100.00  NULL
1       SIMPLE  pay     NULL    ref     fk_booking      fk_booking      144     airbnb_clone_db.b.booking_id    1       100.00  NULL

-- Explanation

-> Nested loop left join  (cost=47 rows=35.4) (actual time=0.517..1.75 rows=31 loops=1)
    -> Nested loop left join  (cost=34.6 rows=34.3) (actual time=0.47..1.1 rows=30 loops=1)
        -> Nested loop inner join  (cost=22.6 rows=34.3) (actual time=0.436..0.885 rows=30 loops=1)
            -> Filter: (b.`status` = 'confirmed')  
               (cost=10.6 rows=34.3) 
               (actual time=0.0611..0.246 rows=30 loops=1)
                -> Table scan on b  
                   (cost=10.6 rows=103) 
                   (actual time=0.0559..0.202 rows=103 loops=1)
            -> Single-row index lookup on u using PRIMARY (user_id=b.user_id)  
               (cost=0.253 rows=1) 
               (actual time=0.0101..0.0102 rows=1 loops=30)
        -> Single-row index lookup on p using PRIMARY (property_id=b.property_id)  
           (cost=0.253 rows=1) 
           (actual time=0.00642..0.00649 rows=1 loops=30)
    -> Index lookup on pay using fk_booking (booking_id=b.booking_id)  
       (cost=0.261 rows=1.03) 
       (actual time=0.0187..0.0209 rows=1.03 loops=30)
