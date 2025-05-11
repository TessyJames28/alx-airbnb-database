-- Clear tables before inserting data
-- SET FOREIGN_KEY_CHECKS = 0;

-- DELETE FROM Review;
-- DELETE FROM Payment;
-- DELETE FROM Booking;
-- DELETE FROM Message;
-- DELETE FROM Property;
-- DELETE FROM User;

-- SET FOREIGN_KEY_CHECKS = 1;

-- Generate UUIDs for users and store them in variables
SET @user_id1 = UUID();
SET @user_id2 = UUID();
SET @user_id3 = UUID();
SET @user_id4 = UUID();
SET @user_id5 = UUID();
SET @user_id6 = UUID();
SET @user_id7 = UUID();

-- Insert Users with generated UUIDs
INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at)
VALUES 
    (@user_id1, 'Alice', 'Smith', 'alice@example.com', 'Alice123', '3094689033', 'host', '2025-02-25'),
    (@user_id2, 'Bob', 'Johnson', 'bob@example.com', 'Bob1234', '3085234561', 'host', '2025-03-25'),
    (@user_id3, 'Carol', 'Lee', 'carol@example.com', 'Carol1234', '3067339870', 'host', '2025-04-05'),
    (@user_id4, 'Jane', 'Doe', 'jane@example.com', 'Jane123', '3094643533', 'guest', '2025-04-15'),
    (@user_id6, 'Jane', 'Smith', 'janes@example.com', 'Janes123', '3095793533', 'guest', '2025-04-16'),
    (@user_id5, 'Jake', 'Doe', 'jake@example.com', 'Jake123', '3094734033', 'guest', '2025-04-15'),
    (@user_id7, 'Adam', 'Mark', 'adam@example.com', 'Adam123', '309479363', 'admin', '2025-01-15');

-- Generate UUIDs for properties and store them in variables
SET @property_id1 = UUID();
SET @property_id2 = UUID();
SET @property_id3 = UUID();

-- Insert Properties with generated UUIDs and reference users
INSERT INTO Property (property_id, host_id, name, description, location, pricepernight, created_at)
VALUES 
    (@property_id1, @user_id1, 'Oceanview Apartment', 'An excellent ocean view', 'Miami', 550.00, '2025-02-26'),
    (@property_id2, @user_id2, 'Mountain Cabin','a mountain view cabin', 'Denver', 950.00, '2025-03-26'),
    (@property_id3, @user_id3, 'City Loft', 'a city loft', 'New York', 1500.00, '2025-04-06');

-- Generate UUIDs for bookings and store them in variables
SET @booking_id1 = UUID();
SET @booking_id2 = UUID();
SET @booking_id3 = UUID();

-- Insert Bookings with generated UUIDs and reference properties and users
INSERT INTO Booking (booking_id, user_id, property_id, start_date, end_date, total_price, status)
VALUES 
    (@booking_id1, @user_id4, @property_id1, '2025-05-01', '2025-05-05', 2750.00, 'confirmed'),
    (@booking_id2, @user_id5, @property_id3, '2025-05-03', '2025-05-08', 7500.00, 'canceled'),
    (@booking_id3, @user_id6, @property_id2, '2025-05-15', '2025-05-20', 4750.00, 'pending');

-- Generate UUIDs for payments and store them in variables
SET @payment_id1 = UUID();
SET @payment_id2 = UUID();
SET @payment_id3 = UUID();

-- Insert Payments with generated UUIDs and reference bookings
INSERT INTO Payment (payment_id, booking_id, amount, payment_date, payment_method)
VALUES 
    (@payment_id1, @booking_id1, 2750.00, '2025-03-21', 'stripe'),
    (@payment_id2, @booking_id2, 7500.00, '2025-04-01', 'paypal'),
    (@payment_id3, @booking_id3, 4750.00, '2025-05-01', 'credit_card');

-- Generate UUIDs for reviews and store them in variables
SET @review_id1 = UUID();

-- Insert Reviews with genrated UUIDs and reference user and property
INSERT INTO REVIEW (review_id, property_id, user_id, rating, comment)
VALUES
    (@review_id1, @property_id1, @user_id4, 5, 'a great experience');

-- Generate UUIDs for messages and store them in variables
SET @message_id1 = UUID();
SET @message_id2 = UUID();
SET @message_id3 = UUID();

-- Insert Message between host and guest with generated UUIDs
INSERT INTO Message (message_id, sender_id, recipient_id, message_body)
VALUES
    (@message_id1, @user_id4, @user_id1, 'I am interested in the ocenview house, looking forward to a great holiday'),
    (@message_id2, @user_id5, @user_id2, 'I am interested in the mountain view house'),
    (@message_id3, @user_id6, @user_id3, 'I am interested in the apartment loft, ready to experience New York');
