-- Write a query using an INNER JOIN to retrieve all bookings
-- and the respective users who made those bookings.

SELECT User.first_name, Book.status, Book.start_date, Book.end_date
FROM Booking AS Book
INNER JOIN User ON Book.user_id = User.user_id;


-- Write a query using a LEFT JOIN to retrieve all properties and
-- their reviews, including properties that have no reviews.

SELECT Property.name, Review.rating, Review.comment
FROM Property
LEFT JOIN Review ON Property.property_id = Review.property_id;

-- Write a query using a FULL OUTER JOIN to retrieve all users
-- and all bookings, even if the user has no booking or a
-- booking is not linked to a user.

SELECT User.first_name, User.last_name, Booking.booking_id
FROM User
FULL OUTER JOIN Booking ON User.user_id = Booking.user_id;