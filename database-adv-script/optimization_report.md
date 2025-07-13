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

id      select_type     table   partitions      type    possible_keys   key   key_len  ref     rows    filtered        Extra
1       SIMPLE  pay     NULL    ALL     fk_booking      NULL    NULL    NULL  33       100.00  NULL
1       SIMPLE  b       NULL    eq_ref  PRIMARY,fk_property,fk_user     PRIMAR144      airbnb_clone_db.pay.booking_id  1       100.00  NULL
1       SIMPLE  p       NULL    eq_ref  PRIMARY PRIMARY 144     airbnb_clone_db.b.property_id  1       100.00  NULL
1       SIMPLE  u       NULL    eq_ref  PRIMARY PRIMARY 144     airbnb_clone_db.b.user_id      1       100.00  NULL



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
