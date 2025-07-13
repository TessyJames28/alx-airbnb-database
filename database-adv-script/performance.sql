-- Refactor complex queries to improve performance.

--  initial query that retrieves all bookings along with the
-- user details, property details, and payment details

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

-- Optimized Query

-- SELECT
--     b.booking_id,
--     u.first_name,
--     u.last_name,
--     p.name AS property_name,
--     pay.amount,
--     pay.payment_method
-- FROM Booking b
-- INNER JOIN User u ON b.user_id = u.user_id
-- LEFT JOIN Property p ON b.property_id = p.property_id
-- LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
-- WHERE b.status = 'confirmed'
