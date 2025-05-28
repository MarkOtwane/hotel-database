CREATE DATABASE hotel_db;

-- guests (id, name, email, phone, check_in_date, check_out_date)

CREATE TABLE guests(
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone INT NOT NULL,
    check_in_date DATE NOT NULL DEFAULT CURRENT_DATE
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