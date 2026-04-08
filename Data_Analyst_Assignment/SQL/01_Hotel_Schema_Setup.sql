-- Hotel Management System Schema Setup
-- Create tables for users, bookings, booking_commercials, items

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE bookings (
    booking_id INT PRIMARY KEY,
    user_id INT,
    room_id INT,
    check_in_date DATE,
    check_out_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE items (
    item_id INT PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50)
);

CREATE TABLE booking_commercials (
    id INT PRIMARY KEY,
    booking_id INT,
    item_id INT,
    quantity INT,
    rate DECIMAL(10,2),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);

-- =========================
-- INSERT SAMPLE DATA
-- =========================

-- Users
INSERT INTO users VALUES
(1, 'John Doe', 'john@example.com'),
(2, 'Jane Smith', 'jane@example.com'),
(3, 'Ram Kumar', 'ram@example.com');

-- Bookings
INSERT INTO bookings VALUES
(1, 1, 101, '2021-11-01', '2021-11-03'),
(2, 2, 102, '2021-11-05', '2021-11-07'),
(3, 3, 103, '2021-11-10', '2021-11-12');

-- Items
INSERT INTO items VALUES
(1, 'Room Charge', 'Stay'),
(2, 'Food Service', 'Food'),
(3, 'Laundry', 'Service');

-- Booking Commercials
INSERT INTO booking_commercials VALUES
(1, 1, 1, 2, 1000.00),   -- Room charge for booking 1
(2, 1, 2, 3, 200.00),    -- Food for booking 1
(3, 2, 1, 2, 1200.00),   -- Room charge for booking 2
(4, 2, 3, 1, 300.00),    -- Laundry for booking 2
(5, 3, 1, 3, 900.00),    -- Room charge for booking 3
(6, 3, 2, 2, 250.00);    -- Food for booking 3