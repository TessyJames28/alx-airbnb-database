-- Write both correlated and non-correlated subqueries.

-- Write a query to find all properties where the average
-- rating is greater than 4.0 using a subquery

SELECT name
FROM Property
WHERE property_id IN (
    SELECT property_id FROM Review
    WHERE rating > 4.0
);

-- Write a correlated subquery to find users who have
-- made more than 3 bookings.

SELECT first_name
FROM User
WHERE user_id IN (
    SELECT user_id FROM Booking
    GROUP BY user_id
    HAVING COUNT(*) > 3
);
