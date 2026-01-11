-- Active: 1759497781450@@127.0.0.1@3307@hotel_management
-- =====================================================
-- Hotel Management System Database Schema (MySQL Compatible)
-- =====================================================
-- This SQL file contains all necessary tables and data
-- for running the hotel management website on MySQL XAMPP
-- =====================================================

-- Drop existing database if exists (for fresh installation)
USE master
GO
DROP DATABASE IF EXISTS hotel_management;

CREATE DATABASE hotel_management;

USE hotel_management;

-- =====================================================
-- TABLE CREATION
-- =====================================================

-- 1. Users/Staff Table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    role ENUM (
        'admin',
        'manager',
        'receptionist',
        'housekeeping',
        'maintenance'
    ) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. Room Types Table
CREATE TABLE room_types (
    room_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    base_price DECIMAL(12, 2) NOT NULL,
    max_occupancy INT NOT NULL DEFAULT 2,
    amenities TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Rooms Table
CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    room_type_id INT NOT NULL,
    floor_number INT NOT NULL,
    status ENUM (
        'available',
        'occupied',
        'maintenance',
        'cleaning'
    ) DEFAULT 'available',
    last_cleaned TIMESTAMP NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_type_id) REFERENCES room_types (room_type_id)
);

-- 4. Guests Table
CREATE TABLE guests (
    guest_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20) NOT NULL,
    id_number VARCHAR(20) UNIQUE,
    id_type ENUM (
        'passport',
        'national_id',
        'driver_license'
    ) DEFAULT 'national_id',
    address TEXT,
    date_of_birth DATE,
    nationality VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 5. Bookings Table
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    guest_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    adults INT NOT NULL DEFAULT 1,
    children INT DEFAULT 0,
    total_amount DECIMAL(12, 2) NOT NULL,
    status ENUM (
        'pending',
        'confirmed',
        'checked_in',
        'checked_out',
        'cancelled',
        'no_show'
    ) DEFAULT 'pending',
    special_requests TEXT,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (guest_id) REFERENCES guests (guest_id),
    FOREIGN KEY (room_id) REFERENCES rooms (room_id),
    FOREIGN KEY (created_by) REFERENCES users (user_id)
);

-- 6. Payments Table
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    payment_type ENUM (
        'cash',
        'credit_card',
        'debit_card',
        'bank_transfer',
        'online'
    ) NOT NULL,
    payment_status ENUM (
        'pending',
        'completed',
        'failed',
        'refunded'
    ) DEFAULT 'pending',
    transaction_id VARCHAR(100),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    processed_by INT,
    notes TEXT,
    FOREIGN KEY (booking_id) REFERENCES bookings (booking_id),
    FOREIGN KEY (processed_by) REFERENCES users (user_id)
);

-- 7. Services Table
CREATE TABLE services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(12, 2) NOT NULL,
    category ENUM (
        'food',
        'spa',
        'laundry',
        'transportation',
        'entertainment',
        'other'
    ) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 8. Guest Services Table (Additional services ordered by guests)
CREATE TABLE guest_services (
    guest_service_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    service_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(12, 2) NOT NULL,
    total_price DECIMAL(12, 2) NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM (
        'ordered',
        'delivered',
        'cancelled'
    ) DEFAULT 'ordered',
    FOREIGN KEY (booking_id) REFERENCES bookings (booking_id),
    FOREIGN KEY (service_id) REFERENCES services (service_id)
);

-- 9. Maintenance Records Table
CREATE TABLE maintenance_records (
    maintenance_id INT AUTO_INCREMENT PRIMARY KEY,
    room_id INT NOT NULL,
    issue_description TEXT NOT NULL,
    reported_by INT,
    assigned_to INT,
    priority ENUM (
        'low',
        'medium',
        'high',
        'urgent'
    ) DEFAULT 'medium',
    status ENUM (
        'reported',
        'in_progress',
        'completed',
        'cancelled'
    ) DEFAULT 'reported',
    estimated_cost DECIMAL(12, 2),
    actual_cost DECIMAL(12, 2),
    start_date TIMESTAMP NULL,
    completion_date TIMESTAMP NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES rooms (room_id),
    FOREIGN KEY (reported_by) REFERENCES users (user_id),
    FOREIGN KEY (assigned_to) REFERENCES users (user_id)
);

-- 10. Reviews Table
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    rating INT NOT NULL CHECK (
        rating >= 1
        AND rating <= 5
    ),
    title VARCHAR(100),
    comment TEXT,
    is_public BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings (booking_id)
);

-- 11. Inventory Table
CREATE TABLE inventory (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    current_stock INT NOT NULL DEFAULT 0,
    minimum_stock INT NOT NULL DEFAULT 10,
    unit_price DECIMAL(12, 2),
    supplier VARCHAR(100),
    last_restocked TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 12. Reports Table (for storing generated reports)
CREATE TABLE reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    report_name VARCHAR(100) NOT NULL,
    report_type ENUM (
        'occupancy',
        'revenue',
        'guest_analysis',
        'maintenance',
        'inventory'
    ) NOT NULL,
    generated_by INT NOT NULL,
    parameters TEXT,
    file_path VARCHAR(255),
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (generated_by) REFERENCES users (user_id)
);

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

-- Room indexes
CREATE INDEX idx_rooms_status ON rooms (status);

CREATE INDEX idx_rooms_type ON rooms (room_type_id);

CREATE INDEX idx_rooms_floor ON rooms (floor_number);

-- Booking indexes
CREATE INDEX idx_bookings_guest ON bookings (guest_id);

CREATE INDEX idx_bookings_room ON bookings (room_id);

CREATE
INDEX idx_bookings_dates ON bookings (check_in_date, check_out_date);

CREATE INDEX idx_bookings_status ON bookings (status);

-- Guest indexes
CREATE INDEX idx_guests_phone ON guests (phone);

CREATE INDEX idx_guests_email ON guests (email);

CREATE INDEX idx_guests_id_number ON guests (id_number);

-- Payment indexes
CREATE INDEX idx_payments_booking ON payments (booking_id);

CREATE INDEX idx_payments_date ON payments (payment_date);

CREATE INDEX idx_payments_status ON payments (payment_status);

-- Maintenance indexes
CREATE INDEX idx_maintenance_room ON maintenance_records (room_id);

CREATE INDEX idx_maintenance_status ON maintenance_records (status);

-- =====================================================
-- SAMPLE DATA INSERTION
-- =====================================================

-- Insert Room Types
INSERT INTO
    room_types (
        type_name,
        description,
        base_price,
        max_occupancy,
        amenities
    )
VALUES (
        'Standard',
        'Comfortable room with basic amenities',
        1200000.00,
        2,
        'WiFi, TV, Air conditioning, Mini bar'
    ),
    (
        'Deluxe',
        'Spacious room with premium amenities',
        1800000.00,
        2,
        'WiFi, TV, Air conditioning, Mini bar, Balcony, Ocean view'
    ),
    (
        'Suite',
        'Luxury suite with separate living area',
        2500000.00,
        4,
        'WiFi, TV, Air conditioning, Mini bar, Balcony, Ocean view, Jacuzzi, Kitchenette'
    ),
    (
        'Family',
        'Large room suitable for families',
        2000000.00,
        4,
        'WiFi, TV, Air conditioning, Mini bar, Balcony, Extra bed'
    );

-- Insert Users/Staff 
-- Password is password 
-- all user have role admin
INSERT INTO
    users (
        username,
        password,
        email,
        full_name,
        phone,
        role
    )
VALUES (
        'admin',
        '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'admin@hotel.com',
        'System Administrator',
        '0123456789',
        'admin'
    ),
    (
        'manager',
        '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'manager@hotel.com',
        'Hotel Manager',
        '0123456788',
        'manager'
    ),
    (
        'reception',
        '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'reception@hotel.com',
        'Reception Staff',
        '0123456787',
        'receptionist'
    ),
    (
        'housekeeping',
        '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'housekeeping@hotel.com',
        'Housekeeping Staff',
        '0123456786',
        'housekeeping'
    ),
    (
        'maintenance',
        '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
        'maintenance@hotel.com',
        'Maintenance Staff',
        '0123456785',
        'maintenance'
    );

-- Insert Rooms
INSERT INTO
    rooms (
        room_number,
        room_type_id,
        floor_number,
        status
    )
VALUES
    -- Floor 1
    ('101', 1, 1, 'available'),
    ('102', 1, 1, 'occupied'),
    ('103', 1, 1, 'available'),
    ('104', 1, 1, 'maintenance'),
    ('105', 2, 1, 'occupied'),
    ('106', 2, 1, 'available'),
    -- Floor 2
    ('201', 2, 2, 'occupied'),
    ('202', 2, 2, 'available'),
    ('203', 2, 2, 'occupied'),
    ('204', 3, 2, 'available'),
    ('205', 3, 2, 'occupied'),
    ('206', 3, 2, 'available'),
    -- Floor 3
    ('301', 3, 3, 'available'),
    ('302', 3, 3, 'available'),
    ('303', 4, 3, 'available'),
    ('304', 4, 3, 'available'),
    ('305', 4, 3, 'available'),
    ('306', 4, 3, 'available');
SET NAMES utf8mb4;
ALTER DATABASE hotel_management CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
SELECT CONCAT(
    'ALTER TABLE `', TABLE_NAME,
    '` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;'
)
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'hotel_management';
ALTER TABLE `guests` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `rooms` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `room_types` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `users` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Insert Guests
INSERT INTO
    guests (
        first_name,
        last_name,
        email,
        phone,
        id_number,
        address,
        nationality
    )
VALUES (
        'Nguyễn',
        'Văn A',
        'nguyenvana@email.com',
        '0123456789',
        '123456789',
        '123 Đường ABC, Quận 1, TP.HCM',
        'Việt Nam'
    ),
    (
        'Trần',
        'Thị B',
        'tranthib@email.com',
        '0987654321',
        '987654321',
        '456 Đường XYZ, Quận 3, TP.HCM',
        'Việt Nam'
    ),
    (
        'Lê',
        'Văn C',
        'levanc@email.com',
        '0123987654',
        '456789123',
        '789 Đường DEF, Quận 5, TP.HCM',
        'Việt Nam'
    ),
    (
        'Phạm',
        'Thị D',
        'phamthid@email.com',
        '0987123456',
        '789123456',
        '321 Đường GHI, Quận 7, TP.HCM',
        'Việt Nam'
    ),
    (
        'Hoàng',
        'Văn E',
        'hoangvane@email.com',
        '0123654789',
        '321654987',
        '654 Đường JKL, Quận 10, TP.HCM',
        'Việt Nam'
    ),
    (
        'Võ',
        'Thị F',
        'vothif@email.com',
        '0987456123',
        '654987321',
        '987 Đường MNO, Quận 2, TP.HCM',
        'Việt Nam'
    );

-- Insert Bookings
INSERT INTO
    bookings (
        guest_id,
        room_id,
        check_in_date,
        check_out_date,
        adults,
        children,
        total_amount,
        status,
        created_by
    )
VALUES (
        1,
        2,
        '2024-01-15',
        '2024-01-18',
        2,
        0,
        3600000.00,
        'checked_in',
        3
    ),
    (
        2,
        5,
        '2024-01-14',
        '2024-01-17',
        1,
        1,
        5400000.00,
        'checked_in',
        3
    ),
    (
        3,
        7,
        '2024-01-16',
        '2024-01-20',
        2,
        0,
        7200000.00,
        'confirmed',
        3
    ),
    (
        4,
        9,
        '2024-01-13',
        '2024-01-16',
        2,
        0,
        5400000.00,
        'checked_in',
        3
    ),
    (
        5,
        11,
        '2024-01-17',
        '2024-01-21',
        2,
        2,
        10000000.00,
        'confirmed',
        3
    ),
    (
        6,
        1,
        '2024-01-18',
        '2024-01-22',
        1,
        0,
        4800000.00,
        'pending',
        3
    );

-- Insert Services
INSERT INTO
    services (
        service_name,
        description,
        price,
        category
    )
VALUES (
        'Breakfast Buffet',
        'Continental breakfast buffet with Vietnamese and international options',
        250000.00,
        'food'
    ),
    (
        'Room Service',
        '24/7 room service with local and international cuisine',
        150000.00,
        'food'
    ),
    (
        'Spa Treatment',
        'Relaxing spa treatment with professional therapists',
        800000.00,
        'spa'
    ),
    (
        'Laundry Service',
        'Professional laundry and dry cleaning service',
        100000.00,
        'laundry'
    ),
    (
        'Airport Transfer',
        'Complimentary airport pickup and drop-off',
        300000.00,
        'transportation'
    ),
    (
        'Car Rental',
        'Daily car rental with driver',
        1200000.00,
        'transportation'
    ),
    (
        'Tour Guide',
        'Professional tour guide for city exploration',
        500000.00,
        'entertainment'
    ),
    (
        'Gym Access',
        'Access to fully equipped fitness center',
        200000.00,
        'entertainment'
    );

-- Insert Guest Services
INSERT INTO
    guest_services (
        booking_id,
        service_id,
        quantity,
        unit_price,
        total_price,
        status
    )
VALUES (
        1,
        1,
        2,
        250000.00,
        500000.00,
        'delivered'
    ),
    (
        1,
        3,
        1,
        800000.00,
        800000.00,
        'ordered'
    ),
    (
        2,
        2,
        1,
        150000.00,
        150000.00,
        'delivered'
    ),
    (
        3,
        4,
        2,
        100000.00,
        200000.00,
        'ordered'
    ),
    (
        4,
        5,
        1,
        300000.00,
        300000.00,
        'delivered'
    ),
    (
        5,
        6,
        1,
        1200000.00,
        1200000.00,
        'ordered'
    );

-- Insert Payments
INSERT INTO
    payments (
        booking_id,
        amount,
        payment_type,
        payment_status,
        processed_by
    )
VALUES (
        1,
        1800000.00,
        'credit_card',
        'completed',
        3
    ),
    (
        2,
        2700000.00,
        'bank_transfer',
        'completed',
        3
    ),
    (
        3,
        3600000.00,
        'credit_card',
        'completed',
        3
    ),
    (
        4,
        2700000.00,
        'cash',
        'completed',
        3
    ),
    (
        5,
        5000000.00,
        'credit_card',
        'pending',
        3
    ),
    (
        6,
        2400000.00,
        'online',
        'pending',
        3
    );

-- Insert Maintenance Records
INSERT INTO
    maintenance_records (
        room_id,
        issue_description,
        reported_by,
        assigned_to,
        priority,
        status,
        estimated_cost
    )
VALUES (
        4,
        'Air conditioning not working properly',
        3,
        5,
        'high',
        'in_progress',
        500000.00
    ),
    (
        11,
        'Bathroom faucet leaking',
        4,
        5,
        'medium',
        'reported',
        200000.00
    );

-- Insert Reviews
INSERT INTO
    reviews (
        booking_id,
        rating,
        title,
        comment,
        is_public
    )
VALUES (
        1,
        5,
        'Excellent stay!',
        'Great service and comfortable room. Staff was very helpful.',
        TRUE
    ),
    (
        2,
        4,
        'Good experience',
        'Nice room with good amenities. Breakfast was delicious.',
        TRUE
    ),
    (
        3,
        5,
        'Perfect getaway',
        'Amazing view and excellent service. Will definitely come back.',
        TRUE
    );

-- Insert Inventory
INSERT INTO
    inventory (
        item_name,
        category,
        current_stock,
        minimum_stock,
        unit_price,
        supplier
    )
VALUES (
        'Towels',
        'linen',
        50,
        20,
        50000.00,
        'Textile Supplies Co.'
    ),
    (
        'Soap',
        'amenities',
        200,
        50,
        5000.00,
        'Bath Essentials Ltd.'
    ),
    (
        'Shampoo',
        'amenities',
        150,
        30,
        15000.00,
        'Bath Essentials Ltd.'
    ),
    (
        'Coffee',
        'food',
        30,
        10,
        200000.00,
        'Beverage Distributors'
    ),
    (
        'Tea',
        'food',
        25,
        10,
        150000.00,
        'Beverage Distributors'
    ),
    (
        'Pillows',
        'linen',
        40,
        15,
        100000.00,
        'Textile Supplies Co.'
    ),
    (
        'Blankets',
        'linen',
        35,
        10,
        200000.00,
        'Textile Supplies Co.'
    ),
    (
        'Toilet Paper',
        'amenities',
        100,
        25,
        25000.00,
        'Cleaning Supplies Inc.'
    );

-- =====================================================
-- VIEWS FOR COMMON QUERIES
-- =====================================================

-- View for current room status with guest information
CREATE VIEW current_room_status AS
SELECT 
    r.room_id, 
    r.room_number, 
    rt.type_name, 
    rt.base_price, 
    r.status, 
    g.first_name, 
    g.last_name, 
    g.phone, 
    b.check_in_date, 
    b.check_out_date
FROM rooms r
    JOIN room_types rt ON r.room_type_id = rt.room_type_id
    LEFT JOIN bookings b ON r.room_id = b.room_id
        AND b.status IN ('confirmed', 'checked_in')
        -- AND DATE(NOW()) BETWEEN b.check_in_date AND b.check_out_date
    LEFT JOIN guests g ON b.guest_id = g.guest_id;

-- View for daily occupancy report
CREATE VIEW daily_occupancy AS
SELECT
    DATE(check_in_date) as date,
    COUNT(*) as total_check_ins,
    SUM(adults + children) as total_guests,
    SUM(total_amount) as daily_revenue
FROM bookings
WHERE
    status IN (
        'confirmed',
        'checked_in',
        'checked_out'
    )
GROUP BY
    DATE(check_in_date);

-- View for room revenue summary
CREATE VIEW room_revenue AS
SELECT
    r.room_number,
    rt.type_name,
    COUNT(b.booking_id) as total_bookings,
    SUM(b.total_amount) as total_revenue,
    AVG(b.total_amount) as avg_revenue_per_booking
FROM
    rooms r
    JOIN room_types rt ON r.room_type_id = rt.room_type_id
    LEFT JOIN bookings b ON r.room_id = b.room_id
    AND b.status IN ('checked_out', 'checked_in')
GROUP BY
    r.room_id,
    r.room_number,
    rt.type_name;

-- =====================================================
-- STORED PROCEDURES
-- =====================================================

DELIMITER $$

-- Procedure to check room availability
CREATE PROCEDURE CheckRoomAvailability(
    IN p_room_id INT,
    IN p_check_in DATE,
    IN p_check_out DATE,
    OUT p_available BOOLEAN
)
BEGIN
    DECLARE booking_count INT DEFAULT 0;
    
    SELECT COUNT(*) INTO booking_count
    FROM bookings 
    WHERE room_id = p_room_id 
    AND status IN ('confirmed', 'checked_in')
    AND NOT (p_check_out <= check_in_date OR p_check_in >= check_out_date);
    
    SET p_available = (booking_count = 0);
END$$

-- Procedure to calculate booking total
CREATE PROCEDURE CalculateBookingTotal(
    IN p_room_type_id INT,
    IN p_check_in DATE,
    IN p_check_out DATE,
    IN p_adults INT,
    IN p_children INT,
    OUT p_total DECIMAL(12,2)
)
BEGIN
    DECLARE nights INT;
    DECLARE base_price DECIMAL(12,2);
    DECLARE extra_guest_charge DECIMAL(12,2) DEFAULT 0;
    
    SET nights = DATEDIFF(p_check_out, p_check_in);
    
    SELECT base_price INTO base_price 
    FROM room_types 
    WHERE room_type_id = p_room_type_id;
    
    -- Charge extra for additional guests (after 2 adults)
    IF (p_adults + p_children) > 2 THEN
        SET extra_guest_charge = ((p_adults + p_children) - 2) * 200000.00 * nights;
    END IF;
    SET p_total = (base_price * nights) + extra_guest_charge;
END$$

-- Procedure to process check-in
CREATE PROCEDURE ProcessCheckIn(
    IN p_booking_id INT,
    IN p_user_id INT,
    OUT p_success BOOLEAN
)
BEGIN
    DECLARE room_id INT;
    DECLARE current_status VARCHAR(20);
    
    SELECT b.room_id, b.status INTO room_id, current_status
    FROM bookings b
    WHERE b.booking_id = p_booking_id;
    
    IF current_status = 'confirmed' THEN
        -- Update booking status
        UPDATE bookings 
        SET status = 'checked_in', updated_at = CURRENT_TIMESTAMP
        WHERE booking_id = p_booking_id;
        
        -- Update room status
        UPDATE rooms 
        SET status = 'occupied'
        WHERE room_id = room_id;
        
        SET p_success = TRUE;
    ELSE
        SET p_success = FALSE;
    END IF;
END$$

DELIMITER;

-- =====================================================
-- TRIGGERS
-- =====================================================

-- Trigger to update room status when booking is created
DELIMITER $$

CREATE TRIGGER update_room_status_on_booking
AFTER INSERT ON bookings
FOR EACH ROW
BEGIN
    UPDATE rooms 
    SET status = 'occupied' 
    WHERE room_id = NEW.room_id 
    AND NEW.status = 'checked_in';
END$$

-- Trigger to update room status when booking is updated
CREATE TRIGGER update_room_status_on_booking_update
AFTER UPDATE ON bookings
FOR EACH ROW
BEGIN
    -- If status changed to checked_in
    IF NEW.status = 'checked_in' AND OLD.status != 'checked_in' THEN
        UPDATE rooms SET status = 'occupied' WHERE room_id = NEW.room_id;
    END IF;
    
    -- If status changed to checked_out
    IF NEW.status = 'checked_out' AND OLD.status != 'checked_out' THEN
        UPDATE rooms SET status = 'available' WHERE room_id = NEW.room_id;
    END IF;
END$$
DELIMITER;

-- 1. Permossons 
CREATE TABLE permissions (
    permission_id INT AUTO_INCREMENT PRIMARY KEY,
    permission_name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    module VARCHAR(50) NOT NULL,
    action VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Roles Table - Enhanced with permissions
CREATE TABLE roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 3. Role Permissions Mapping
CREATE TABLE role_permissions (
    role_permission_id INT AUTO_INCREMENT PRIMARY KEY,
    role_id INT NOT NULL,
    permission_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles (role_id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES permissions (permission_id) ON DELETE CASCADE,
    UNIQUE KEY unique_role_permission (role_id, permission_id)
);

-- 4. User Roles Mapping - Support multiple roles per user
CREATE TABLE user_roles (
    user_role_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    role_id INT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    assigned_by INT,
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles (role_id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_by) REFERENCES users (user_id),
    UNIQUE KEY unique_user_role (user_id, role_id)
);

-- 5. Audit Log - Track all permission-related actions
CREATE TABLE audit_logs (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    action VARCHAR(100) NOT NULL,
    module VARCHAR(50) NOT NULL,
    entity_type VARCHAR(50),
    entity_id INT,
    old_value TEXT,
    new_value TEXT,
    ip_address VARCHAR(45),
    status VARCHAR(20),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (user_id),
    INDEX idx_user_timestamp (user_id, timestamp),
    INDEX idx_action_timestamp (action, timestamp)
);

-- 6. Resource Access Control - Fine-grained access
CREATE TABLE resource_access (
    resource_id INT AUTO_INCREMENT PRIMARY KEY,
    resource_type VARCHAR(50) NOT NULL,
    resource_name VARCHAR(100) NOT NULL,
    owner_id INT,
    access_level ENUM('public', 'private', 'restricted') DEFAULT 'private',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users (user_id),
    INDEX idx_resource_type (resource_type)
);

-- 7. Resource Permissions - Who can access what they can do 
CREATE TABLE resource_permissions (
    resource_perm_id INT AUTO_INCREMENT PRIMARY KEY,
    resource_id INT NOT NULL,
    role_id INT,
    user_id INT,
    permission_type ENUM('view', 'edit', 'delete', 'share') NOT NULL,
    granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    granted_by INT,
    FOREIGN KEY (resource_id) REFERENCES resource_access (resource_id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles (role_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
    FOREIGN KEY (granted_by) REFERENCES users (user_id)
);

-- =====================================================
-- INSERT DEFAULT PERMISSIONS
-- =====================================================

-- Dashboard Permissions
INSERT INTO permissions (permission_name, description, module, action) VALUES
('dashboard.view', 'View dashboard', 'dashboard', 'view'),
('dashboard.export', 'Export dashboard data', 'dashboard', 'export');

-- Room Management Permissions
INSERT INTO permissions (permission_name, description, module, action) VALUES
('rooms.view', 'View rooms', 'rooms', 'view'),
('rooms.create', 'Create new room', 'rooms', 'create'),
('rooms.edit', 'Edit room details', 'rooms', 'edit'),
('rooms.delete', 'Delete room', 'rooms', 'delete'),
('rooms.status_change', 'Change room status', 'rooms', 'status_change'),
('rooms.export', 'Export room data', 'rooms', 'export');

-- Booking Management Permissions
INSERT INTO permissions (permission_name, description, module, action) VALUES
('bookings.view', 'View bookings', 'bookings', 'view'),
('bookings.create', 'Create booking', 'bookings', 'create'),
('bookings.edit', 'Edit booking', 'bookings', 'edit'),
('bookings.delete', 'Delete booking', 'bookings', 'delete'),
('bookings.checkin', 'Check-in guest', 'bookings', 'checkin'),
('bookings.checkout', 'Check-out guest', 'bookings', 'checkout'),
('bookings.cancel', 'Cancel booking', 'bookings', 'cancel'),
('bookings.export', 'Export booking data', 'bookings', 'export');

-- Guest Management Permissions
INSERT INTO permissions (permission_name, description, module, action) VALUES
('guests.view', 'View guests', 'guests', 'view'),
('guests.create', 'Create guest', 'guests', 'create'),
('guests.edit', 'Edit guest', 'guests', 'edit'),
('guests.delete', 'Delete guest', 'guests', 'delete'),
('guests.export', 'Export guest data', 'guests', 'export');

-- Payment Management Permissions
INSERT INTO permissions (permission_name, description, module, action) VALUES
('payments.view', 'View payments', 'payments', 'view'),
('payments.create', 'Create payment', 'payments', 'create'),
('payments.edit', 'Edit payment', 'payments', 'edit'),
('payments.delete', 'Delete payment', 'payments', 'delete'),
('payments.refund', 'Process refund', 'payments', 'refund'),
('payments.export', 'Export payment data', 'payments', 'export');

-- Service Management Permissions
INSERT INTO permissions (permission_name, description, module, action) VALUES
('services.view', 'View services', 'services', 'view'),
('services.create', 'Create service', 'services', 'create'),
('services.edit', 'Edit service', 'services', 'edit'),
('services.delete', 'Delete service', 'services', 'delete');

-- Maintenance Permissions
INSERT INTO permissions (permission_name, description, module, action) VALUES
('maintenance.view', 'View maintenance records', 'maintenance', 'view'),
('maintenance.create', 'Create maintenance record', 'maintenance', 'create'),
('maintenance.edit', 'Edit maintenance record', 'maintenance', 'edit'),
('maintenance.delete', 'Delete maintenance record', 'maintenance', 'delete'),
('maintenance.assign', 'Assign maintenance task', 'maintenance', 'assign'),
('maintenance.complete', 'Mark maintenance complete', 'maintenance', 'complete');

-- Inventory Permissions
INSERT INTO permissions (permission_name, description, module, action) VALUES
('inventory.view', 'View inventory', 'inventory', 'view'),
('inventory.create', 'Create inventory item', 'inventory', 'create'),
('inventory.edit', 'Edit inventory item', 'inventory', 'edit'),
('inventory.delete', 'Delete inventory item', 'inventory', 'delete'),
('inventory.adjust', 'Adjust inventory stock', 'inventory', 'adjust');

-- Reports Permissions
INSERT INTO permissions (permission_name, description, module, action) VALUES
('reports.view', 'View reports', 'reports', 'view'),
('reports.create', 'Create report', 'reports', 'create'),
('reports.export', 'Export report', 'reports', 'export'),
('reports.occupancy', 'View occupancy report', 'reports', 'occupancy'),
('reports.revenue', 'View revenue report', 'reports', 'revenue'),
('reports.guest_analysis', 'View guest analysis', 'reports', 'guest_analysis');

-- Reviews Permissions
INSERT INTO permissions (permission_name, description, module, action) VALUES
('reviews.view', 'View reviews', 'reviews', 'view'),
('reviews.create', 'Create review', 'reviews', 'create'),
('reviews.edit', 'Edit review', 'reviews', 'edit'),
('reviews.delete', 'Delete review', 'reviews', 'delete'),
('reviews.publish', 'Publish review', 'reviews', 'publish');

-- User Management Permissions
INSERT INTO permissions (permission_name, description, module, action) VALUES
('users.view', 'View users', 'users', 'view'),
('users.create', 'Create user', 'users', 'create'),
('users.edit', 'Edit user', 'users', 'edit'),
('users.delete', 'Delete user', 'users', 'delete'),
('users.roles', 'Manage user roles', 'users', 'roles'),
('users.permissions', 'Manage user permissions', 'users', 'permissions');

-- Settings Permissions
INSERT INTO permissions (permission_name, description, module, action) VALUES
('settings.view', 'View settings', 'settings', 'view'),
('settings.edit', 'Edit settings', 'settings', 'edit'),
('settings.system', 'System settings', 'settings', 'system'),
('settings.audit', 'View audit logs', 'settings', 'audit');

-- =====================================================
-- INSERT DEFAULT ROLES
-- =====================================================

INSERT INTO roles (role_name, description) VALUES
('admin', 'Administrator - Full system access'),
('manager', 'Manager - Manage operations and staff'),
('receptionist', 'Receptionist - Handle bookings and guests'),
('housekeeping', 'Housekeeping - Room maintenance'),
('maintenance', 'Maintenance - Equipment and repairs'),
('accountant', 'Accountant - Financial management'),
('guest', 'Guest - Limited access');

-- =====================================================
-- ASSIGN PERMISSIONS TO ROLES
-- =====================================================

-- Admin - All permissions
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.role_id, p.permission_id 
FROM roles r, permissions p 
WHERE r.role_name = 'admin';

-- Manager - Most permissions except user management
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.role_id, p.permission_id 
FROM roles r, permissions p 
WHERE r.role_name = 'manager' 
AND p.permission_name NOT IN ('users.delete', 'settings.system');

-- Receptionist - Booking, guest, payment, and review permissions
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.role_id, p.permission_id 
FROM roles r, permissions p 
WHERE r.role_name = 'receptionist' 
AND p.module IN ('bookings', 'guests', 'payments', 'reviews', 'dashboard')
AND p.permission_name NOT IN ('payments.delete', 'payments.refund', 'guests.delete');

-- Housekeeping - Room and maintenance permissions
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.role_id, p.permission_id 
FROM roles r, permissions p 
WHERE r.role_name = 'housekeeping' 
AND p.module IN ('rooms', 'maintenance')
AND p.permission_name NOT IN ('rooms.delete', 'maintenance.delete');

-- Maintenance - Maintenance and inventory permissions
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.role_id, p.permission_id 
FROM roles r, permissions p 
WHERE r.role_name = 'maintenance' 
AND p.module IN ('maintenance', 'inventory')
AND p.permission_name NOT IN ('maintenance.delete', 'inventory.delete');

-- Accountant - Payment and report permissions
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.role_id, p.permission_id 
FROM roles r, permissions p 
WHERE r.role_name = 'accountant' 
AND p.module IN ('payments', 'reports', 'bookings')
AND p.permission_name NOT IN ('payments.delete', 'bookings.delete');

-- Guest - Limited view permissions
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.role_id, p.permission_id 
FROM roles r, permissions p 
WHERE r.role_name = 'guest' 
AND p.permission_name IN ('bookings.view', 'reviews.create', 'reviews.view', 'dashboard.view');

-- Users Roles
INSERT INTO user_roles (user_id, role_id) VALUES
(1, 1), -- Admin
(2, 2), -- Manager
(3, 3), -- Receptionist
(4, 4), -- Housekeeping
(5, 5); -- Maintenance

-- =====================================================
-- CREATE INDEXES FOR PERFORMANCE
-- =====================================================

CREATE INDEX idx_role_permissions_role ON role_permissions (role_id);
CREATE INDEX idx_role_permissions_permission ON role_permissions (permission_id);
CREATE INDEX idx_user_roles_user ON user_roles (user_id);
CREATE INDEX idx_user_roles_role ON user_roles (role_id);
CREATE INDEX idx_resource_access_owner ON resource_access (owner_id);
CREATE INDEX idx_resource_permissions_resource ON resource_permissions (resource_id);
CREATE INDEX idx_resource_permissions_role ON resource_permissions (role_id);
CREATE INDEX idx_resource_permissions_user ON resource_permissions (user_id);


CREATE USER IF NOT EXISTS 'hotel_app'@'localhost' 
IDENTIFIED BY 'hotel_password';

-- add user to hotel_management database
GRANT SELECT, INSERT, UPDATE, DELETE 
ON hotel_management.* TO 'hotel_app'@'localhost';

FLUSH PRIVILEGES;

-- Business logic: update timestamp phòng available
UPDATE hotel_management.rooms
SET last_cleaned = CURRENT_TIMESTAMP
WHERE status = 'available';
