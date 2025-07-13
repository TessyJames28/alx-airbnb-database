-- Step 1: Rename the existing Booking table
-- RENAME TABLE Booking TO Booking_old;

-- Step 2: Recreate the Booking table with partitioning by YEAR(start_date)
CREATE TABLE Booking (
    booking_id CHAR(36) NOT NULL,
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- PRIMARY KEY must include start_date (partition key)
    PRIMARY KEY (booking_id, start_date),
    
    -- Remove FK constraints as they are not supported in partitioned tables
    KEY idx_property (property_id),
    KEY idx_user (user_id),
    KEY idx_start_date (start_date)
)
PARTITION BY RANGE (YEAR(start_date)) (
    PARTITION p2022 VALUES LESS THAN (2023),
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION pFuture VALUES LESS THAN MAXVALUE
);

-- Step 3: Copy data from the old table into the new partitioned table
INSERT INTO Booking (
    booking_id, property_id, user_id, start_date,
    end_date, total_price, status, created_at
)
SELECT
    booking_id, property_id, user_id, start_date,
    end_date, total_price, status, created_at
FROM Booking_old;

-- Optional: Drop the old table after verifying
-- DROP TABLE Booking_old;
