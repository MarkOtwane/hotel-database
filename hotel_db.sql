CREATE DATABASE hotel_db;

-- guests (id, name, email, phone, check_in_date, check_out_date)

CREATE TABLE guests(
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone INT NOT NULL,
    check_in_date DATE NOT NULL DEFAULT CURRENT_DATE,
    check_out_date DATE  NOT NULL
)

-- rooms (id, number, type, price_per_night, is_available)
CREATE TABLE rooms(
    id SERIAL PRIMARY KEY,
    room_number INT NOT NULL,
    room_type VARCHAR(10) NOT NULL,
    price_per_night NUMERIC(10, 2) NOT NULL,
    is_available BOOLEAN NOT NULL

)

-- bookings (id, guest_id, room_id, booking_date, nights, total_price
CREATE TABLE bookings(
    id SERIAL PRIMARY KEY,
    guest_id INT NOT NULL REFERENCES guests(id),
    room_id INT NOT NULL REFERENCES rooms(id),
    booking_date DATE NOT NULL,
    night INT NOT NULL,
    --number of night * price per night = total_price we'll use the ideas of trigger
    total_price NUMERIC(10, 2) NOT NULL
)

-- services (id, name, price)
CREATE TABLE services(
    id SERIAL PRIMARY KEY,
    name VARCHAR(25) NOT NULL,
    price DECIMAL NOT NULL
)

-- guest_services (id, guest_id, service_id, date_used)
CREATE TABLE guest_services(
    id SERIAL PRIMARY KEY,
    guest_id INT NOT NULL REFERENCES guests(id),
    service_id INT NOT NULL REFERENCES services(id),
    date_used DATE NOT NULL 
)

-- insertion
INSERT INTO guests (name, phone, check_in_date, check_out_date) VALUES
('John Doe', 1112223330, '2024-06-01', '2024-06-05'),
('Jane Smith', 1112223331, '2024-06-02', '2024-06-07'),
('Peter Jones', 1112223332, '2024-06-03', '2024-06-06'),
('Emily White', 1112223333, '2024-06-04', '2024-06-08'),
('David Green', 1112223334, '2024-06-05', '2024-06-09'),
('Sarah Black', 1112223335, '2024-06-06', '2024-06-10'),
('Michael Blue', 1112223336, '2024-06-07', '2024-06-11'),
('Olivia Grey', 1112223337, '2024-06-08', '2024-06-12'),
('William Red', 1112223338, '2024-06-09', '2024-06-13');
-- Data for rooms table (20 entries)
INSERT INTO rooms (room_number, room_type, price_per_night, is_available) VALUES
(101, 'Standard', 100.00, TRUE),
(102, 'Standard', 100.00, TRUE),
(103, 'Standard', 100.00, FALSE),
(104, 'Standard', 100.00, TRUE),
(105, 'Deluxe', 150.00, TRUE),
(106, 'Deluxe', 150.00, TRUE),
(107, 'Deluxe', 150.00, FALSE),
(108, 'Deluxe', 150.00, TRUE),
(201, 'Suite', 250.00, TRUE),
(202, 'Suite', 250.00, TRUE),
(203, 'Suite', 250.00, FALSE),
(204, 'Suite', 250.00, TRUE),
(205, 'Standard', 110.00, TRUE),
(206, 'Standard', 110.00, TRUE),
(207, 'Deluxe', 160.00, FALSE),
(208, 'Deluxe', 160.00, TRUE),
(301, 'Suite', 275.00, TRUE),
(302, 'Suite', 275.00, TRUE),
(303, 'Standard', 105.00, TRUE),
(304, 'Deluxe', 155.00, TRUE);

INSERT INTO services (name, price) VALUES
('Breakfast Buffet', 25.00),
('Room Service', 15.00),
('Laundry Service', 10.50),
('Spa Access', 50.00),
('Gym Access', 0.00), -- Often complimentary
('Airport Shuttle', 30.00),
('Extra Bed', 20.00),
('Minibar Restock', 35.00),
('Valet Parking', 18.00),
('Concierge Service', 0.00), -- Often complimentary
('Guided City Tour', 75.00),
('Babysitting Service', 40.00),
('Business Center Use', 5.00),
('Conference Room Rental', 200.00),
('High-Speed Wi-Fi', 12.00),
('Pet Sitting', 30.00),
('Late Check-out', 40.00),
('Early Check-in', 30.00),
('Dry Cleaning', 12.50),
('Wake-up Call', 0.00); 

-- selest guest by name and phone 
select name, phone from guests;

Insert a new guest and a new booking.
INSERT INTO guests (name, phone, check_in_date ) VALUES
('Mark', 123456543,'2025-05-21' '2025-05-27');

-- Update a guest’s check-out date.

INSERT INTO bookings(guest_id, room_id, booking_date, night, total_price) 
VALUES(1, (SELECT id FROM rooms WHERE room_number = 103 LIMIT 1), '2025-04-28', 5, 12000);

-- Update a guest’s check-out date.
UPDATE guests
SET check_out_date = '2025-05-30'
WHERE name = 'Mark';

-- Delete a guest who checked out more than 1 month ago.
DELETE FROM guests WHERE (check_in_date - check_out_date) > 30


-- 3️⃣ Filtering & Grouping
--Find guests who booked after a specific date.
select * from bookings where booking_date > '2024-04-2025' 


-- 3️⃣ Filtering & Grouping

-- Group bookings by room_id and show average nights stayed.
SELECT room_id, AVG(night) AS average_nights
FROM bookings
GROUP BY room_id;

-- 4️⃣ Joins & Subqueries

-- List guests and the rooms they’re staying in (JOIN).
SELECT g.name AS guest_name, r.room_number
FROM guests g
JOIN bookings b ON g.id = b.guest_id
JOIN rooms r ON b.room_id = r.id;

-- Subquery to find guests who have used more than 2 services.
SELECT g.name
FROM guests g
WHERE (SELECT COUNT(*) FROM guest_services gs WHERE gs.guest_id = g.id) > 2;

-- Let's insert some data into guest_services to make the above query useful
INSERT INTO guest_services (guest_id, service_id, date_used) VALUES
(1, 1, '2025-05-28'),
(1, 2, '2025-05-28'),
(1, 3, '2025-05-29'),
(2, 1, '2025-05-28'),
(2, 2, '2025-05-29'),
(3, 1, '2025-05-28');

-- Now let's run the subquery again
SELECT g.name
FROM guests g
WHERE (SELECT COUNT(*) FROM guest_services gs WHERE gs.guest_id = g.id) > 2;

-- 5️⃣ Views & Pagination

-- Create a view showing guest name, room number, total price.
CREATE VIEW guest_booking_price AS
SELECT
    g.name AS guest_name,
    r.room_number,
    b.total_price
FROM
    guests g
JOIN
    bookings b ON g.id = b.guest_id
JOIN
    rooms r ON b.room_id = r.id;

-- Paginate the view to show 3 bookings at a time (using LIMIT and OFFSET).
SELECT * FROM guest_booking_price LIMIT 3 OFFSET 0; -- First page
SELECT * FROM guest_booking_price LIMIT 3 OFFSET 3; -- Second page
SELECT * FROM guest_booking_price LIMIT 3 OFFSET 6; -- Third page

-- 6️⃣ Sorting & Limiting

-- Sort guests by check-in date (descending).
SELECT * FROM guests ORDER BY check_in_date DESC;

-- Limit results to the 5 most recent guests.
SELECT * FROM guests ORDER BY check_in_date DESC LIMIT 5;

-- 7️⃣ Constraints & Expressions, SET Operators, CTEs

-- Add a UNIQUE constraint on email in guests.
ALTER TABLE guests ADD COLUMN email VARCHAR(100) UNIQUE;

-- Let's add some emails to our existing guests
UPDATE guests SET email = 'john.doe@example.com' WHERE id = 1;
UPDATE guests SET email = 'jane.smith@example.com' WHERE id = 2;
UPDATE guests SET email = 'peter.jones@example.com' WHERE id = 3;
UPDATE guests SET email = 'emily.white@example.com' WHERE id = 4;
UPDATE guests SET email = 'david.green@example.com' WHERE id = 5;
UPDATE guests SET email = 'sarah.black@example.com' WHERE id = 6;
UPDATE guests SET email = 'michael.blue@example.com' WHERE id = 7;
UPDATE guests SET email = 'olivia.grey@example.com' WHERE id = 8;
UPDATE guests SET email = 'william.red@example.com' WHERE id = 9;
UPDATE guests SET email = 'mark@example.com' WHERE name = 'Mark';

-- Use CASE to categorize rooms (Economy, Business, Luxury) based on price_per_night.
SELECT
    room_number,
    price_per_night,
    CASE
        WHEN price_per_night < 120 THEN 'Economy'
        WHEN price_per_night >= 120 AND price_per_night < 200 THEN 'Business'
        ELSE 'Luxury'
    END AS room_category
FROM rooms;

-- Use a CTE to find rooms booked more than 3 times.
WITH RoomBookingCount AS (
    SELECT room_id, COUNT(*) AS booking_count
    FROM bookings
    GROUP BY room_id
)
SELECT r.room_number
FROM rooms r
JOIN RoomBookingCount rbc ON r.id = rbc.room_id
WHERE rbc.booking_count > 3;

-- Let's insert more bookings to make the CTE useful
INSERT INTO bookings (guest_id, room_id, booking_date, night, total_price) VALUES
(1, 1, '2025-05-10', 2, 200.00),
(2, 1, '2025-05-15', 3, 300.00),
(3, 1, '2025-05-20', 4, 400.00),
(4, 1, '2025-05-25', 1, 100.00),
(5, 2, '2025-05-01', 2, 300.00),
(6, 2, '2025-05-05', 3, 450.00),
(7, 2, '2025-05-10', 2, 300.00),
(8, 3, '2025-05-01', 5, 500.00);

-- Run the CTE again
WITH RoomBookingCount AS (
    SELECT room_id, COUNT(*) AS booking_count
    FROM bookings
    GROUP BY room_id
)
SELECT r.room_number
FROM rooms r
JOIN RoomBookingCount rbc ON r.id = rbc.room_id
WHERE rbc.booking_count > 3;

-- Use UNION to combine guests who booked a room or used a spa service.
SELECT g.name AS customer
FROM guests g
WHERE EXISTS (SELECT 1 FROM bookings b WHERE b.guest_id = g.id)
UNION
SELECT g.name
FROM guests g
WHERE EXISTS (SELECT 1 FROM guest_services gs JOIN services s ON gs.service_id = s.id WHERE gs.guest_id = g.id AND s.name = 'Spa Access');

-- Let's ensure some guests have used the spa service
INSERT INTO guest_services (guest_id, service_id, date_used)
SELECT (SELECT id FROM guests WHERE name = 'Jane Smith'), (SELECT id FROM services WHERE name = 'Spa Access'), '2025-05-29';

-- Run the UNION query again
SELECT g.name AS customer
FROM guests g
WHERE EXISTS (SELECT 1 FROM bookings b WHERE b.guest_id = g.id)
UNION
SELECT g.name
FROM guests g
WHERE EXISTS (SELECT 1 FROM guest_services gs JOIN services s ON gs.service_id = s.id WHERE gs.guest_id = g.id AND s.name = 'Spa Access');

-- 8️⃣ Triggers & Indexes

-- Create a trigger to log updates to rooms availability.
CREATE OR REPLACE FUNCTION log_room_availability_change()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.is_available <> OLD.is_available THEN
        INSERT INTO room_availability_logs (room_id, availability_status, changed_at)
        VALUES (OLD.id, NEW.is_available, NOW());
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE room_availability_logs (
    id SERIAL PRIMARY KEY,
    room_id INT NOT NULL REFERENCES rooms(id),
    availability_status BOOLEAN NOT NULL,
    changed_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE TRIGGER room_availability_change_trigger
AFTER UPDATE ON rooms
FOR EACH ROW
EXECUTE FUNCTION log_room_availability_change();

-- Example of updating room availability to see the trigger in action
UPDATE rooms SET is_available = FALSE WHERE room_number = 101;
SELECT * FROM room_availability_logs;
UPDATE rooms SET is_available = TRUE WHERE room_number = 101;
SELECT * FROM room_availability_logs;

-- Create an index on bookings.booking_date for faster lookups.
CREATE INDEX idx_booking_date ON bookings (booking_date);

-- 9️⃣ User Defined Functions & Stored Procedures

-- Create a function to calculate total spend for a guest.
CREATE OR REPLACE FUNCTION calculate_guest_total_spend(guest_id_input INT)
RETURNS NUMERIC AS $$
DECLARE
    booking_spend NUMERIC;
    service_spend NUMERIC;
    total_spend NUMERIC;
BEGIN
    SELECT COALESCE(SUM(total_price), 0) INTO booking_spend
    FROM bookings
    WHERE guest_id = guest_id_input;

    SELECT COALESCE(SUM(s.price), 0) INTO service_spend
    FROM guest_services gs
    JOIN services s ON gs.service_id = s.id
    WHERE gs.guest_id = guest_id_input;

    total_spend := booking_spend + service_spend;
    RETURN total_spend;
END;
$$ LANGUAGE plpgsql;

-- Example of using the function
SELECT name, calculate_guest_total_spend(guests.id) AS total_spend
FROM guests;

-- Create a stored procedure to add a booking
CREATE OR REPLACE PROCEDURE add_new_booking(
    p_guest_id INT,
    p_room_id INT,
    p_booking_date DATE,
    p_nights INT
)
AS $$
DECLARE
    room_price NUMERIC;
    v_total_price NUMERIC;
BEGIN
    SELECT price_per_night INTO room_price
    FROM rooms
    WHERE id = p_room_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Room with ID % not found', p_room_id;
    END IF;

    v_total_price := room_price * p_nights;

    INSERT INTO bookings (guest_id, room_id, booking_date, night, total_price)
    VALUES (p_guest_id, p_room_id, p_booking_date, p_nights, v_total_price);
END;
$$ LANGUAGE plpgsql;

-- Example of calling the stored procedure
CALL add_new_booking(1, 101, '2025-06-15', 3);
SELECT * FROM bookings WHERE guest_id = 1 AND room_id = 101;

-- Create a procedure to check in a new guest and book them into a room.
CREATE OR REPLACE PROCEDURE check_in_and_book(
    p_guest_name VARCHAR(100),
    p_guest_phone INT,
    p_check_in_date DATE,
    p_check_out_date DATE,
    p_room_number INT,
    p_booking_date DATE,
    p_nights INT
)
AS $$
DECLARE
    v_guest_id INT;
    v_room_id INT;
    room_price NUMERIC;
    v_total_price NUMERIC;
BEGIN
    -- Insert the new guest
    INSERT INTO guests (name, phone, check_in_date, check_out_date)
    VALUES (p_guest_name, p_guest_phone, p_check_in_date, p_check_out_date)
    RETURNING id INTO v_guest_id;

    -- Find the room ID
    SELECT id, price_per_night INTO v_room_id, room_price
    FROM rooms
    WHERE room_number = p_room_number AND is_available = TRUE
    LIMIT 1;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Room number % is not available', p_room_number;
    END IF;

    -- Calculate total price
    v_total_price := room_price * p_nights;

    -- Create the booking
    INSERT INTO bookings (guest_id, room_id, booking_date, night, total_price)
    VALUES (v_guest_id, v_room_id, p_booking_date, p_nights, v_total_price);

    -- Update room availability
    UPDATE rooms SET is_available = FALSE WHERE id = v_room_id;

    RAISE NOTICE 'Guest % checked in and booked room %', p_guest_name, p_room_number;

EXCEPTION
    WHEN others THEN
        RAISE EXCEPTION 'Error during check-in and booking: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- Example of calling the check-in and book procedure
CALL check_in_and_book('Alice Wonderland', 987654321, CURRENT_DATE, CURRENT_DATE + 5, 205, CURRENT_DATE, 5);
SELECT * FROM guests WHERE name = 'Alice Wonderland';
SELECT * FROM bookings WHERE guest_id = (SELECT id FROM guests WHERE name = 'Alice Wonderland');
SELECT * FROM rooms WHERE room_number = 205;

-- Final check of all tables and logs
SELECT * FROM guests;
SELECT * FROM rooms;
SELECT * FROM bookings;
SELECT * FROM services;
SELECT * FROM guest_services;
SELECT * FROM room_availability_logs;