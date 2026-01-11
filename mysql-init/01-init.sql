SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

CREATE DATABASE IF NOT EXISTS `hotel_management` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `hotel_management`;


CREATE TABLE IF NOT EXISTS `audit_logs` (
  `audit_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `action` varchar(100) NOT NULL,
  `module` varchar(50) NOT NULL,
  `entity_type` varchar(50) DEFAULT NULL,
  `entity_id` int(11) DEFAULT NULL,
  `old_value` text DEFAULT NULL,
  `new_value` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`audit_id`),
  KEY `idx_user_timestamp` (`user_id`,`timestamp`),
  KEY `idx_action_timestamp` (`action`,`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `bookings` (
  `booking_id` int(11) NOT NULL AUTO_INCREMENT,
  `guest_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `check_in_date` date NOT NULL,
  `check_out_date` date NOT NULL,
  `adults` int(11) NOT NULL DEFAULT 1,
  `children` int(11) DEFAULT 0,
  `total_amount` decimal(12,2) NOT NULL,
  `status` enum('pending','confirmed','checked_in','checked_out','cancelled','no_show') DEFAULT 'pending',
  `special_requests` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`booking_id`),
  KEY `created_by` (`created_by`),
  KEY `idx_bookings_guest` (`guest_id`),
  KEY `idx_bookings_room` (`room_id`),
  KEY `idx_bookings_dates` (`check_in_date`,`check_out_date`),
  KEY `idx_bookings_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

INSERT INTO `bookings` (`booking_id`, `guest_id`, `room_id`, `check_in_date`, `check_out_date`, `adults`, `children`, `total_amount`, `status`, `special_requests`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 1, 2, '2024-01-15', '2024-01-18', 2, 0, 3600000.00, 'checked_out', NULL, 3, '2025-11-16 09:03:38', '2025-12-12 01:06:31'),
(2, 2, 5, '2024-01-14', '2024-01-17', 1, 1, 5400000.00, 'checked_in', NULL, 3, '2025-11-16 09:03:38', '2025-11-16 09:03:38'),
(3, 3, 7, '2024-01-16', '2024-01-20', 2, 0, 7200000.00, 'checked_in', NULL, 3, '2025-11-16 09:03:38', '2025-12-06 14:09:08'),
(4, 4, 9, '2024-01-13', '2024-01-16', 2, 0, 5400000.00, 'checked_in', NULL, 3, '2025-11-16 09:03:38', '2025-11-16 09:03:38'),
(5, 5, 11, '2024-01-17', '2024-01-21', 2, 2, 10000000.00, 'checked_in', NULL, 3, '2025-11-16 09:03:38', '2025-12-10 03:22:54'),
(6, 6, 1, '2024-01-18', '2024-01-22', 1, 0, 4800000.00, 'pending', NULL, 3, '2025-11-16 09:03:38', '2025-11-16 09:03:38');
DELIMITER $$
CREATE TRIGGER `update_room_status_on_booking` AFTER INSERT ON `bookings` FOR EACH ROW BEGIN
    UPDATE rooms 
    SET status = 'occupied' 
    WHERE room_id = NEW.room_id 
    AND NEW.status = 'checked_in';
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_room_status_on_booking_update` AFTER UPDATE ON `bookings` FOR EACH ROW BEGIN
    -- If status changed to checked_in
    IF NEW.status = 'checked_in' AND OLD.status != 'checked_in' THEN
        UPDATE rooms SET status = 'occupied' WHERE room_id = NEW.room_id;
    END IF;
    
    -- If status changed to checked_out
    IF NEW.status = 'checked_out' AND OLD.status != 'checked_out' THEN
        UPDATE rooms SET status = 'available' WHERE room_id = NEW.room_id;
    END IF;
END
$$
DELIMITER ;
CREATE TABLE IF NOT EXISTS `current_room_status` (
`room_id` int(11)
,`room_number` varchar(10)
,`type_name` varchar(50)
,`base_price` decimal(12,2)
,`status` enum('available','occupied','maintenance','cleaning')
,`first_name` varchar(50)
,`last_name` varchar(50)
,`phone` varchar(20)
,`check_in_date` date
,`check_out_date` date
);
CREATE TABLE IF NOT EXISTS `daily_occupancy` (
`date` date
,`total_check_ins` bigint(21)
,`total_guests` decimal(33,0)
,`daily_revenue` decimal(34,2)
);

CREATE TABLE IF NOT EXISTS `guests` (
  `guest_id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `id_number` varchar(20) DEFAULT NULL,
  `id_type` enum('passport','national_id','driver_license') DEFAULT 'national_id',
  `address` mediumtext DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `nationality` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`guest_id`),
  UNIQUE KEY `id_number` (`id_number`),
  KEY `idx_guests_phone` (`phone`),
  KEY `idx_guests_email` (`email`),
  KEY `idx_guests_id_number` (`id_number`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `guests` (`guest_id`, `first_name`, `last_name`, `email`, `phone`, `id_number`, `id_type`, `address`, `date_of_birth`, `nationality`, `created_at`, `updated_at`) VALUES
(1, 'Nguyễn', 'Văn A', 'nguyenvana@email.com', '0123456789', '123456789', 'national_id', '123 Đường ABC, Quận 1, TP.HCM', NULL, 'Việt Nam', '2025-11-16 09:03:38', '2025-11-16 09:03:38'),
(2, 'Trần', 'Thị B', 'tranthib@email.com', '0987654321', '987654321', 'national_id', '456 Đường XYZ, Quận 3, TP.HCM', NULL, 'Việt Nam', '2025-11-16 09:03:38', '2025-11-16 09:03:38'),
(3, 'Lê', 'Văn C', 'levanc@email.com', '0123987654', '456789123', 'national_id', '789 Đường DEF, Quận 5, TP.HCM', NULL, 'Việt Nam', '2025-11-16 09:03:38', '2025-11-16 09:03:38'),
(4, 'Phạm', 'Thị D', 'phamthid@email.com', '0987123456', '789123456', 'national_id', '321 Đường GHI, Quận 7, TP.HCM', NULL, 'Việt Nam', '2025-11-16 09:03:38', '2025-11-16 09:03:38'),
(5, 'Hoàng', 'Văn E', 'hoangvane@email.com', '0123654789', '321654987', 'national_id', '654 Đường JKL, Quận 10, TP.HCM', NULL, 'Việt Nam', '2025-11-16 09:03:38', '2025-11-16 09:03:38'),
(6, 'Võ', 'Thị F', 'vothif@email.com', '0987456123', '654987321', 'national_id', '987 Đường MNO, Quận 2, TP.HCM', NULL, 'Việt Nam', '2025-11-16 09:03:38', '2025-11-16 09:03:38');

CREATE TABLE IF NOT EXISTS `guest_services` (
  `guest_service_id` int(11) NOT NULL AUTO_INCREMENT,
  `booking_id` int(11) NOT NULL,
  `service_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `unit_price` decimal(12,2) NOT NULL,
  `total_price` decimal(12,2) NOT NULL,
  `order_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('ordered','delivered','cancelled') DEFAULT 'ordered',
  PRIMARY KEY (`guest_service_id`),
  KEY `booking_id` (`booking_id`),
  KEY `service_id` (`service_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

INSERT INTO `guest_services` (`guest_service_id`, `booking_id`, `service_id`, `quantity`, `unit_price`, `total_price`, `order_date`, `status`) VALUES
(1, 1, 1, 2, 250000.00, 500000.00, '2025-11-16 09:03:38', 'delivered'),
(2, 1, 3, 1, 800000.00, 800000.00, '2025-11-16 09:03:38', 'ordered'),
(3, 2, 2, 1, 150000.00, 150000.00, '2025-11-16 09:03:38', 'delivered'),
(4, 3, 4, 2, 100000.00, 200000.00, '2025-11-16 09:03:38', 'ordered'),
(5, 4, 5, 1, 300000.00, 300000.00, '2025-11-16 09:03:38', 'delivered'),
(6, 5, 6, 1, 1200000.00, 1200000.00, '2025-11-16 09:03:38', 'ordered');

CREATE TABLE IF NOT EXISTS `inventory` (
  `item_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_name` varchar(100) NOT NULL,
  `category` varchar(50) NOT NULL,
  `current_stock` int(11) NOT NULL DEFAULT 0,
  `minimum_stock` int(11) NOT NULL DEFAULT 10,
  `unit_price` decimal(12,2) DEFAULT NULL,
  `supplier` varchar(100) DEFAULT NULL,
  `last_restocked` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

INSERT INTO `inventory` (`item_id`, `item_name`, `category`, `current_stock`, `minimum_stock`, `unit_price`, `supplier`, `last_restocked`, `created_at`) VALUES
(1, 'Towels', 'linen', 50, 20, 50000.00, 'Textile Supplies Co.', NULL, '2025-11-16 09:03:38'),
(2, 'Soap', 'amenities', 200, 50, 5000.00, 'Bath Essentials Ltd.', NULL, '2025-11-16 09:03:38'),
(3, 'Shampoo', 'amenities', 150, 30, 15000.00, 'Bath Essentials Ltd.', NULL, '2025-11-16 09:03:38'),
(4, 'Coffee', 'food', 30, 10, 200000.00, 'Beverage Distributors', NULL, '2025-11-16 09:03:38'),
(5, 'Tea', 'food', 25, 10, 150000.00, 'Beverage Distributors', NULL, '2025-11-16 09:03:38'),
(6, 'Pillows', 'linen', 40, 15, 100000.00, 'Textile Supplies Co.', NULL, '2025-11-16 09:03:38'),
(7, 'Blankets', 'linen', 35, 10, 200000.00, 'Textile Supplies Co.', NULL, '2025-11-16 09:03:38'),
(8, 'Toilet Paper', 'amenities', 100, 25, 25000.00, 'Cleaning Supplies Inc.', NULL, '2025-11-16 09:03:38');

CREATE TABLE IF NOT EXISTS `maintenance_records` (
  `maintenance_id` int(11) NOT NULL AUTO_INCREMENT,
  `room_id` int(11) NOT NULL,
  `issue_description` text NOT NULL,
  `reported_by` int(11) DEFAULT NULL,
  `assigned_to` int(11) DEFAULT NULL,
  `priority` enum('low','medium','high','urgent') DEFAULT 'medium',
  `status` enum('reported','in_progress','completed','cancelled') DEFAULT 'reported',
  `estimated_cost` decimal(12,2) DEFAULT NULL,
  `actual_cost` decimal(12,2) DEFAULT NULL,
  `start_date` timestamp NULL DEFAULT NULL,
  `completion_date` timestamp NULL DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`maintenance_id`),
  KEY `reported_by` (`reported_by`),
  KEY `assigned_to` (`assigned_to`),
  KEY `idx_maintenance_room` (`room_id`),
  KEY `idx_maintenance_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

INSERT INTO `maintenance_records` (`maintenance_id`, `room_id`, `issue_description`, `reported_by`, `assigned_to`, `priority`, `status`, `estimated_cost`, `actual_cost`, `start_date`, `completion_date`, `notes`, `created_at`) VALUES
(1, 4, 'Air conditioning not working properly', 3, 5, 'high', 'in_progress', 500000.00, NULL, NULL, NULL, NULL, '2025-11-16 09:03:38'),
(2, 11, 'Bathroom faucet leaking', 4, 5, 'medium', 'reported', 200000.00, NULL, NULL, NULL, NULL, '2025-11-16 09:03:38');

CREATE TABLE IF NOT EXISTS `payments` (
  `payment_id` int(11) NOT NULL AUTO_INCREMENT,
  `booking_id` int(11) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `payment_type` enum('cash','credit_card','debit_card','bank_transfer','online') NOT NULL,
  `payment_status` enum('pending','completed','failed','refunded') DEFAULT 'pending',
  `transaction_id` varchar(100) DEFAULT NULL,
  `payment_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `processed_by` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  PRIMARY KEY (`payment_id`),
  KEY `processed_by` (`processed_by`),
  KEY `idx_payments_booking` (`booking_id`),
  KEY `idx_payments_date` (`payment_date`),
  KEY `idx_payments_status` (`payment_status`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

INSERT INTO `payments` (`payment_id`, `booking_id`, `amount`, `payment_type`, `payment_status`, `transaction_id`, `payment_date`, `processed_by`, `notes`) VALUES
(1, 1, 1800000.00, 'credit_card', 'completed', NULL, '2025-11-16 09:03:38', 3, NULL),
(2, 2, 2700000.00, 'bank_transfer', 'completed', NULL, '2025-11-16 09:03:38', 3, NULL),
(3, 3, 3600000.00, 'credit_card', 'completed', NULL, '2025-11-16 09:03:38', 3, NULL),
(4, 4, 2700000.00, 'cash', 'completed', NULL, '2025-11-16 09:03:38', 3, NULL),
(5, 5, 5000000.00, 'credit_card', 'completed', NULL, '2025-11-16 09:03:38', 3, NULL),
(6, 6, 2400000.00, 'online', 'pending', NULL, '2025-11-16 09:03:38', 3, NULL);

CREATE TABLE IF NOT EXISTS `permissions` (
  `permission_id` int(11) NOT NULL AUTO_INCREMENT,
  `permission_name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `module` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`permission_id`),
  UNIQUE KEY `permission_name` (`permission_name`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `permissions` (`permission_id`, `permission_name`, `description`, `module`, `action`, `is_active`, `created_at`) VALUES
(1, 'dashboard.view', 'View dashboard', 'dashboard', 'view', 1, '2025-12-07 03:05:41'),
(2, 'dashboard.export', 'Export dashboard data', 'dashboard', 'export', 1, '2025-12-07 03:05:41'),
(3, 'rooms.view', 'View rooms', 'rooms', 'view', 1, '2025-12-07 03:05:41'),
(4, 'rooms.create', 'Create new room', 'rooms', 'create', 1, '2025-12-07 03:05:41'),
(5, 'rooms.edit', 'Edit room details', 'rooms', 'edit', 1, '2025-12-07 03:05:41'),
(6, 'rooms.delete', 'Delete room', 'rooms', 'delete', 1, '2025-12-07 03:05:41'),
(7, 'rooms.status_change', 'Change room status', 'rooms', 'status_change', 1, '2025-12-07 03:05:41'),
(8, 'rooms.export', 'Export room data', 'rooms', 'export', 1, '2025-12-07 03:05:41'),
(9, 'bookings.view', 'View bookings', 'bookings', 'view', 1, '2025-12-07 03:05:41'),
(10, 'bookings.create', 'Create booking', 'bookings', 'create', 1, '2025-12-07 03:05:41'),
(11, 'bookings.edit', 'Edit booking', 'bookings', 'edit', 1, '2025-12-07 03:05:41'),
(12, 'bookings.delete', 'Delete booking', 'bookings', 'delete', 1, '2025-12-07 03:05:41'),
(13, 'bookings.checkin', 'Check-in guest', 'bookings', 'checkin', 1, '2025-12-07 03:05:41'),
(14, 'bookings.checkout', 'Check-out guest', 'bookings', 'checkout', 1, '2025-12-07 03:05:41'),
(15, 'bookings.cancel', 'Cancel booking', 'bookings', 'cancel', 1, '2025-12-07 03:05:41'),
(16, 'bookings.export', 'Export booking data', 'bookings', 'export', 1, '2025-12-07 03:05:41'),
(17, 'guests.view', 'View guests', 'guests', 'view', 1, '2025-12-07 03:05:41'),
(18, 'guests.create', 'Create guest', 'guests', 'create', 1, '2025-12-07 03:05:41'),
(19, 'guests.edit', 'Edit guest', 'guests', 'edit', 1, '2025-12-07 03:05:41'),
(20, 'guests.delete', 'Delete guest', 'guests', 'delete', 1, '2025-12-07 03:05:41'),
(21, 'guests.export', 'Export guest data', 'guests', 'export', 1, '2025-12-07 03:05:41'),
(22, 'payments.view', 'View payments', 'payments', 'view', 1, '2025-12-07 03:05:41'),
(23, 'payments.create', 'Create payment', 'payments', 'create', 1, '2025-12-07 03:05:41'),
(24, 'payments.edit', 'Edit payment', 'payments', 'edit', 1, '2025-12-07 03:05:41'),
(25, 'payments.delete', 'Delete payment', 'payments', 'delete', 1, '2025-12-07 03:05:41'),
(26, 'payments.refund', 'Process refund', 'payments', 'refund', 1, '2025-12-07 03:05:41'),
(27, 'payments.export', 'Export payment data', 'payments', 'export', 1, '2025-12-07 03:05:41'),
(28, 'services.view', 'View services', 'services', 'view', 1, '2025-12-07 03:05:41'),
(29, 'services.create', 'Create service', 'services', 'create', 1, '2025-12-07 03:05:41'),
(30, 'services.edit', 'Edit service', 'services', 'edit', 1, '2025-12-07 03:05:41'),
(31, 'services.delete', 'Delete service', 'services', 'delete', 1, '2025-12-07 03:05:41'),
(32, 'maintenance.view', 'View maintenance records', 'maintenance', 'view', 1, '2025-12-07 03:05:41'),
(33, 'maintenance.create', 'Create maintenance record', 'maintenance', 'create', 1, '2025-12-07 03:05:41'),
(34, 'maintenance.edit', 'Edit maintenance record', 'maintenance', 'edit', 1, '2025-12-07 03:05:41'),
(35, 'maintenance.delete', 'Delete maintenance record', 'maintenance', 'delete', 1, '2025-12-07 03:05:41'),
(36, 'maintenance.assign', 'Assign maintenance task', 'maintenance', 'assign', 1, '2025-12-07 03:05:41'),
(37, 'maintenance.complete', 'Mark maintenance complete', 'maintenance', 'complete', 1, '2025-12-07 03:05:41'),
(38, 'inventory.view', 'View inventory', 'inventory', 'view', 1, '2025-12-07 03:05:41'),
(39, 'inventory.create', 'Create inventory item', 'inventory', 'create', 1, '2025-12-07 03:05:41'),
(40, 'inventory.edit', 'Edit inventory item', 'inventory', 'edit', 1, '2025-12-07 03:05:41'),
(41, 'inventory.delete', 'Delete inventory item', 'inventory', 'delete', 1, '2025-12-07 03:05:41'),
(42, 'inventory.adjust', 'Adjust inventory stock', 'inventory', 'adjust', 1, '2025-12-07 03:05:41'),
(43, 'reports.view', 'View reports', 'reports', 'view', 1, '2025-12-07 03:05:41'),
(44, 'reports.create', 'Create report', 'reports', 'create', 1, '2025-12-07 03:05:41'),
(45, 'reports.export', 'Export report', 'reports', 'export', 1, '2025-12-07 03:05:41'),
(46, 'reports.occupancy', 'View occupancy report', 'reports', 'occupancy', 1, '2025-12-07 03:05:41'),
(47, 'reports.revenue', 'View revenue report', 'reports', 'revenue', 1, '2025-12-07 03:05:41'),
(48, 'reports.guest_analysis', 'View guest analysis', 'reports', 'guest_analysis', 1, '2025-12-07 03:05:41'),
(49, 'reviews.view', 'View reviews', 'reviews', 'view', 1, '2025-12-07 03:05:41'),
(50, 'reviews.create', 'Create review', 'reviews', 'create', 1, '2025-12-07 03:05:41'),
(51, 'reviews.edit', 'Edit review', 'reviews', 'edit', 1, '2025-12-07 03:05:41'),
(52, 'reviews.delete', 'Delete review', 'reviews', 'delete', 1, '2025-12-07 03:05:41'),
(53, 'reviews.publish', 'Publish review', 'reviews', 'publish', 1, '2025-12-07 03:05:41'),
(54, 'users.view', 'View users', 'users', 'view', 1, '2025-12-07 03:05:41'),
(55, 'users.create', 'Create user', 'users', 'create', 1, '2025-12-07 03:05:41'),
(56, 'users.edit', 'Edit user', 'users', 'edit', 1, '2025-12-07 03:05:41'),
(57, 'users.delete', 'Delete user', 'users', 'delete', 1, '2025-12-07 03:05:41'),
(58, 'users.roles', 'Manage user roles', 'users', 'roles', 1, '2025-12-07 03:05:41'),
(59, 'users.permissions', 'Manage user permissions', 'users', 'permissions', 1, '2025-12-07 03:05:41'),
(60, 'settings.view', 'View settings', 'settings', 'view', 1, '2025-12-07 03:05:41'),
(61, 'settings.edit', 'Edit settings', 'settings', 'edit', 1, '2025-12-07 03:05:41'),
(62, 'settings.system', 'System settings', 'settings', 'system', 1, '2025-12-07 03:05:41'),
(63, 'settings.audit', 'View audit logs', 'settings', 'audit', 1, '2025-12-07 03:05:41');

CREATE TABLE IF NOT EXISTS `reports` (
  `report_id` int(11) NOT NULL AUTO_INCREMENT,
  `report_name` varchar(100) NOT NULL,
  `report_type` enum('occupancy','revenue','guest_analysis','maintenance','inventory') NOT NULL,
  `generated_by` int(11) NOT NULL,
  `parameters` text DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `generated_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`report_id`),
  KEY `generated_by` (`generated_by`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE IF NOT EXISTS `resource_access` (
  `resource_id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_type` varchar(50) NOT NULL,
  `resource_name` varchar(100) NOT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `access_level` enum('public','private','restricted') DEFAULT 'private',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`resource_id`),
  KEY `idx_resource_type` (`resource_type`),
  KEY `idx_resource_access_owner` (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `resource_permissions` (
  `resource_perm_id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_id` int(11) NOT NULL,
  `role_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `permission_type` enum('view','edit','delete','share') NOT NULL,
  `granted_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `granted_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`resource_perm_id`),
  KEY `granted_by` (`granted_by`),
  KEY `idx_resource_permissions_resource` (`resource_id`),
  KEY `idx_resource_permissions_role` (`role_id`),
  KEY `idx_resource_permissions_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `reviews` (
  `review_id` int(11) NOT NULL AUTO_INCREMENT,
  `booking_id` int(11) NOT NULL,
  `rating` int(11) NOT NULL CHECK (`rating` >= 1 and `rating` <= 5),
  `title` varchar(100) DEFAULT NULL,
  `comment` text DEFAULT NULL,
  `is_public` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`review_id`),
  KEY `booking_id` (`booking_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

INSERT INTO `reviews` (`review_id`, `booking_id`, `rating`, `title`, `comment`, `is_public`, `created_at`) VALUES
(1, 1, 5, 'Excellent stay!', 'Great service and comfortable room. Staff was very helpful.', 1, '2025-11-16 09:03:38'),
(2, 2, 4, 'Good experience', 'Nice room with good amenities. Breakfast was delicious.', 1, '2025-11-16 09:03:38'),
(3, 3, 5, 'Perfect getaway', 'Amazing view and excellent service. Will definitely come back.', 1, '2025-11-16 09:03:38');

CREATE TABLE IF NOT EXISTS `roles` (
  `role_id` int(11) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `roles` (`role_id`, `role_name`, `description`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'Administrator - Full system access', 1, '2025-12-07 03:05:41', '2025-12-07 03:05:41'),
(2, 'manager', 'Manager - Manage operations and staff', 1, '2025-12-07 03:05:41', '2025-12-07 03:05:41'),
(3, 'receptionist', 'Receptionist - Handle bookings and guests', 1, '2025-12-07 03:05:41', '2025-12-07 03:05:41'),
(4, 'housekeeping', 'Housekeeping - Room maintenance', 1, '2025-12-07 03:05:41', '2025-12-07 03:05:41'),
(5, 'maintenance', 'Maintenance - Equipment and repairs', 1, '2025-12-07 03:05:41', '2025-12-07 03:05:41'),
(6, 'accountant', 'Accountant - Financial management', 1, '2025-12-07 03:05:41', '2025-12-07 03:05:41'),
(7, 'guest', 'Guest - Limited access', 1, '2025-12-07 03:05:41', '2025-12-07 03:05:41');

CREATE TABLE IF NOT EXISTS `role_permissions` (
  `role_permission_id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`role_permission_id`),
  UNIQUE KEY `unique_role_permission` (`role_id`,`permission_id`),
  KEY `idx_role_permissions_role` (`role_id`),
  KEY `idx_role_permissions_permission` (`permission_id`)
) ENGINE=InnoDB AUTO_INCREMENT=223 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `role_permissions` (`role_permission_id`, `role_id`, `permission_id`, `created_at`) VALUES
(1, 1, 15, '2025-12-07 03:05:41'),
(2, 1, 13, '2025-12-07 03:05:41'),
(3, 1, 14, '2025-12-07 03:05:41'),
(4, 1, 10, '2025-12-07 03:05:41'),
(5, 1, 12, '2025-12-07 03:05:41'),
(6, 1, 11, '2025-12-07 03:05:41'),
(7, 1, 16, '2025-12-07 03:05:41'),
(8, 1, 9, '2025-12-07 03:05:41'),
(9, 1, 2, '2025-12-07 03:05:41'),
(10, 1, 1, '2025-12-07 03:05:41'),
(11, 1, 18, '2025-12-07 03:05:41'),
(12, 1, 20, '2025-12-07 03:05:41'),
(13, 1, 19, '2025-12-07 03:05:41'),
(14, 1, 21, '2025-12-07 03:05:41'),
(15, 1, 17, '2025-12-07 03:05:41'),
(16, 1, 42, '2025-12-07 03:05:41'),
(17, 1, 39, '2025-12-07 03:05:41'),
(18, 1, 41, '2025-12-07 03:05:41'),
(19, 1, 40, '2025-12-07 03:05:41'),
(20, 1, 38, '2025-12-07 03:05:41'),
(21, 1, 36, '2025-12-07 03:05:41'),
(22, 1, 37, '2025-12-07 03:05:41'),
(23, 1, 33, '2025-12-07 03:05:41'),
(24, 1, 35, '2025-12-07 03:05:41'),
(25, 1, 34, '2025-12-07 03:05:41'),
(26, 1, 32, '2025-12-07 03:05:41'),
(27, 1, 23, '2025-12-07 03:05:41'),
(28, 1, 25, '2025-12-07 03:05:41'),
(29, 1, 24, '2025-12-07 03:05:41'),
(30, 1, 27, '2025-12-07 03:05:41'),
(31, 1, 26, '2025-12-07 03:05:41'),
(32, 1, 22, '2025-12-07 03:05:41'),
(33, 1, 44, '2025-12-07 03:05:41'),
(34, 1, 45, '2025-12-07 03:05:41'),
(35, 1, 48, '2025-12-07 03:05:41'),
(36, 1, 46, '2025-12-07 03:05:41'),
(37, 1, 47, '2025-12-07 03:05:41'),
(38, 1, 43, '2025-12-07 03:05:41'),
(39, 1, 50, '2025-12-07 03:05:41'),
(40, 1, 52, '2025-12-07 03:05:41'),
(41, 1, 51, '2025-12-07 03:05:41'),
(42, 1, 53, '2025-12-07 03:05:41'),
(43, 1, 49, '2025-12-07 03:05:41'),
(44, 1, 4, '2025-12-07 03:05:41'),
(45, 1, 6, '2025-12-07 03:05:41'),
(46, 1, 5, '2025-12-07 03:05:41'),
(47, 1, 8, '2025-12-07 03:05:41'),
(48, 1, 7, '2025-12-07 03:05:41'),
(49, 1, 3, '2025-12-07 03:05:41'),
(50, 1, 29, '2025-12-07 03:05:41'),
(51, 1, 31, '2025-12-07 03:05:41'),
(52, 1, 30, '2025-12-07 03:05:41'),
(53, 1, 28, '2025-12-07 03:05:41'),
(54, 1, 63, '2025-12-07 03:05:41'),
(55, 1, 61, '2025-12-07 03:05:41'),
(56, 1, 62, '2025-12-07 03:05:41'),
(57, 1, 60, '2025-12-07 03:05:41'),
(58, 1, 55, '2025-12-07 03:05:41'),
(59, 1, 57, '2025-12-07 03:05:41'),
(60, 1, 56, '2025-12-07 03:05:41'),
(61, 1, 59, '2025-12-07 03:05:41'),
(62, 1, 58, '2025-12-07 03:05:41'),
(63, 1, 54, '2025-12-07 03:05:41'),
(64, 2, 15, '2025-12-07 03:05:41'),
(65, 2, 13, '2025-12-07 03:05:41'),
(66, 2, 14, '2025-12-07 03:05:41'),
(67, 2, 10, '2025-12-07 03:05:41'),
(68, 2, 12, '2025-12-07 03:05:41'),
(69, 2, 11, '2025-12-07 03:05:41'),
(70, 2, 16, '2025-12-07 03:05:41'),
(71, 2, 9, '2025-12-07 03:05:41'),
(72, 2, 2, '2025-12-07 03:05:41'),
(73, 2, 1, '2025-12-07 03:05:41'),
(74, 2, 18, '2025-12-07 03:05:41'),
(75, 2, 20, '2025-12-07 03:05:41'),
(76, 2, 19, '2025-12-07 03:05:41'),
(77, 2, 21, '2025-12-07 03:05:41'),
(78, 2, 17, '2025-12-07 03:05:41'),
(79, 2, 42, '2025-12-07 03:05:41'),
(80, 2, 39, '2025-12-07 03:05:41'),
(81, 2, 41, '2025-12-07 03:05:41'),
(82, 2, 40, '2025-12-07 03:05:41'),
(83, 2, 38, '2025-12-07 03:05:41'),
(84, 2, 36, '2025-12-07 03:05:41'),
(85, 2, 37, '2025-12-07 03:05:41'),
(86, 2, 33, '2025-12-07 03:05:41'),
(87, 2, 35, '2025-12-07 03:05:41'),
(88, 2, 34, '2025-12-07 03:05:41'),
(89, 2, 32, '2025-12-07 03:05:41'),
(90, 2, 23, '2025-12-07 03:05:41'),
(91, 2, 25, '2025-12-07 03:05:41'),
(92, 2, 24, '2025-12-07 03:05:41'),
(93, 2, 27, '2025-12-07 03:05:41'),
(94, 2, 26, '2025-12-07 03:05:41'),
(95, 2, 22, '2025-12-07 03:05:41'),
(96, 2, 44, '2025-12-07 03:05:41'),
(97, 2, 45, '2025-12-07 03:05:41'),
(98, 2, 48, '2025-12-07 03:05:41'),
(99, 2, 46, '2025-12-07 03:05:41'),
(100, 2, 47, '2025-12-07 03:05:41'),
(101, 2, 43, '2025-12-07 03:05:41'),
(102, 2, 50, '2025-12-07 03:05:41'),
(103, 2, 52, '2025-12-07 03:05:41'),
(104, 2, 51, '2025-12-07 03:05:41'),
(105, 2, 53, '2025-12-07 03:05:41'),
(106, 2, 49, '2025-12-07 03:05:41'),
(107, 2, 4, '2025-12-07 03:05:41'),
(108, 2, 6, '2025-12-07 03:05:41'),
(109, 2, 5, '2025-12-07 03:05:41'),
(110, 2, 8, '2025-12-07 03:05:41'),
(111, 2, 7, '2025-12-07 03:05:41'),
(112, 2, 3, '2025-12-07 03:05:41'),
(113, 2, 29, '2025-12-07 03:05:41'),
(114, 2, 31, '2025-12-07 03:05:41'),
(115, 2, 30, '2025-12-07 03:05:41'),
(116, 2, 28, '2025-12-07 03:05:41'),
(117, 2, 63, '2025-12-07 03:05:41'),
(118, 2, 61, '2025-12-07 03:05:41'),
(119, 2, 60, '2025-12-07 03:05:41'),
(120, 2, 55, '2025-12-07 03:05:41'),
(121, 2, 56, '2025-12-07 03:05:41'),
(122, 2, 59, '2025-12-07 03:05:41'),
(123, 2, 58, '2025-12-07 03:05:41'),
(124, 2, 54, '2025-12-07 03:05:41'),
(127, 3, 1, '2025-12-07 03:05:41'),
(128, 3, 2, '2025-12-07 03:05:41'),
(129, 3, 9, '2025-12-07 03:05:41'),
(130, 3, 10, '2025-12-07 03:05:41'),
(131, 3, 11, '2025-12-07 03:05:41'),
(132, 3, 12, '2025-12-07 03:05:41'),
(133, 3, 13, '2025-12-07 03:05:41'),
(134, 3, 14, '2025-12-07 03:05:41'),
(135, 3, 15, '2025-12-07 03:05:41'),
(136, 3, 16, '2025-12-07 03:05:41'),
(137, 3, 17, '2025-12-07 03:05:41'),
(138, 3, 18, '2025-12-07 03:05:41'),
(139, 3, 19, '2025-12-07 03:05:41'),
(140, 3, 21, '2025-12-07 03:05:41'),
(141, 3, 22, '2025-12-07 03:05:41'),
(142, 3, 23, '2025-12-07 03:05:41'),
(143, 3, 24, '2025-12-07 03:05:41'),
(144, 3, 27, '2025-12-07 03:05:41'),
(145, 3, 49, '2025-12-07 03:05:41'),
(146, 3, 50, '2025-12-07 03:05:41'),
(147, 3, 51, '2025-12-07 03:05:41'),
(148, 3, 52, '2025-12-07 03:05:41'),
(149, 3, 53, '2025-12-07 03:05:41'),
(158, 4, 3, '2025-12-07 03:05:41'),
(159, 4, 4, '2025-12-07 03:05:41'),
(160, 4, 5, '2025-12-07 03:05:41'),
(161, 4, 7, '2025-12-07 03:05:41'),
(162, 4, 8, '2025-12-07 03:05:41'),
(163, 4, 32, '2025-12-07 03:05:41'),
(164, 4, 33, '2025-12-07 03:05:41'),
(165, 4, 34, '2025-12-07 03:05:41'),
(166, 4, 36, '2025-12-07 03:05:41'),
(167, 4, 37, '2025-12-07 03:05:41'),
(173, 5, 32, '2025-12-07 03:05:41'),
(174, 5, 33, '2025-12-07 03:05:41'),
(175, 5, 34, '2025-12-07 03:05:41'),
(176, 5, 36, '2025-12-07 03:05:41'),
(177, 5, 37, '2025-12-07 03:05:41'),
(178, 5, 38, '2025-12-07 03:05:41'),
(179, 5, 39, '2025-12-07 03:05:41'),
(180, 5, 40, '2025-12-07 03:05:41'),
(181, 5, 42, '2025-12-07 03:05:41'),
(188, 6, 9, '2025-12-07 03:05:41'),
(189, 6, 10, '2025-12-07 03:05:41'),
(190, 6, 11, '2025-12-07 03:05:41'),
(191, 6, 13, '2025-12-07 03:05:41'),
(192, 6, 14, '2025-12-07 03:05:41'),
(193, 6, 15, '2025-12-07 03:05:41'),
(194, 6, 16, '2025-12-07 03:05:41'),
(195, 6, 22, '2025-12-07 03:05:41'),
(196, 6, 23, '2025-12-07 03:05:41'),
(197, 6, 24, '2025-12-07 03:05:41'),
(198, 6, 26, '2025-12-07 03:05:41'),
(199, 6, 27, '2025-12-07 03:05:41'),
(200, 6, 43, '2025-12-07 03:05:41'),
(201, 6, 44, '2025-12-07 03:05:41'),
(202, 6, 45, '2025-12-07 03:05:41'),
(203, 6, 46, '2025-12-07 03:05:41'),
(204, 6, 47, '2025-12-07 03:05:41'),
(205, 6, 48, '2025-12-07 03:05:41'),
(219, 7, 9, '2025-12-07 03:05:41'),
(220, 7, 1, '2025-12-07 03:05:41'),
(221, 7, 50, '2025-12-07 03:05:41'),
(222, 7, 49, '2025-12-07 03:05:41');

CREATE TABLE IF NOT EXISTS `rooms` (
  `room_id` int(11) NOT NULL AUTO_INCREMENT,
  `room_number` varchar(10) NOT NULL,
  `room_type_id` int(11) NOT NULL,
  `floor_number` int(11) NOT NULL,
  `status` enum('available','occupied','maintenance','cleaning') DEFAULT 'available',
  `last_cleaned` timestamp NULL DEFAULT NULL,
  `notes` mediumtext DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`room_id`),
  UNIQUE KEY `room_number` (`room_number`),
  KEY `idx_rooms_status` (`status`),
  KEY `idx_rooms_type` (`room_type_id`),
  KEY `idx_rooms_floor` (`floor_number`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `rooms` (`room_id`, `room_number`, `room_type_id`, `floor_number`, `status`, `last_cleaned`, `notes`, `created_at`) VALUES
(1, '101', 1, 1, 'available', '2025-11-16 09:41:02', NULL, '2025-11-16 09:03:38'),
(2, '102', 1, 1, 'available', NULL, NULL, '2025-11-16 09:03:38'),
(3, '103', 1, 1, 'available', '2025-11-16 09:41:02', NULL, '2025-11-16 09:03:38'),
(4, '104', 1, 1, 'maintenance', NULL, NULL, '2025-11-16 09:03:38'),
(5, '105', 2, 1, 'occupied', NULL, NULL, '2025-11-16 09:03:38'),
(6, '106', 2, 1, 'available', '2025-11-16 09:41:02', NULL, '2025-11-16 09:03:38'),
(7, '201', 2, 2, 'occupied', NULL, NULL, '2025-11-16 09:03:38'),
(8, '202', 2, 2, 'available', '2025-11-16 09:41:02', NULL, '2025-11-16 09:03:38'),
(9, '203', 2, 2, 'occupied', NULL, NULL, '2025-11-16 09:03:38'),
(10, '204', 3, 2, 'available', '2025-11-16 09:41:02', NULL, '2025-11-16 09:03:38'),
(11, '205', 3, 2, 'occupied', NULL, NULL, '2025-11-16 09:03:38'),
(12, '206', 3, 2, 'available', '2025-11-16 09:41:02', NULL, '2025-11-16 09:03:38'),
(13, '301', 3, 3, 'available', '2025-11-16 09:41:02', NULL, '2025-11-16 09:03:38'),
(14, '302', 3, 3, 'available', '2025-11-16 09:41:02', NULL, '2025-11-16 09:03:38'),
(15, '303', 4, 3, 'available', '2025-11-16 09:41:02', NULL, '2025-11-16 09:03:38'),
(16, '304', 4, 3, 'available', '2025-11-16 09:41:02', NULL, '2025-11-16 09:03:38'),
(17, '305', 4, 3, 'available', '2025-11-16 09:41:02', NULL, '2025-11-16 09:03:38'),
(18, '306', 4, 3, 'available', '2025-11-16 09:41:02', NULL, '2025-11-16 09:03:38');
CREATE TABLE IF NOT EXISTS `room_revenue` (
`room_number` varchar(10)
,`type_name` varchar(50)
,`total_bookings` bigint(21)
,`total_revenue` decimal(34,2)
,`avg_revenue_per_booking` decimal(16,6)
);

CREATE TABLE IF NOT EXISTS `room_types` (
  `room_type_id` int(11) NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) NOT NULL,
  `description` mediumtext DEFAULT NULL,
  `base_price` decimal(12,2) NOT NULL,
  `max_occupancy` int(11) NOT NULL DEFAULT 2,
  `amenities` mediumtext DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`room_type_id`),
  UNIQUE KEY `type_name` (`type_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `room_types` (`room_type_id`, `type_name`, `description`, `base_price`, `max_occupancy`, `amenities`, `is_active`, `created_at`) VALUES
(1, 'Standard', 'Comfortable room with basic amenities', 1200000.00, 2, 'WiFi, TV, Air conditioning, Mini bar', 1, '2025-11-16 09:03:38'),
(2, 'Deluxe', 'Spacious room with premium amenities', 1800000.00, 2, 'WiFi, TV, Air conditioning, Mini bar, Balcony, Ocean view', 1, '2025-11-16 09:03:38'),
(3, 'Suite', 'Luxury suite with separate living area', 2500000.00, 4, 'WiFi, TV, Air conditioning, Mini bar, Balcony, Ocean view, Jacuzzi, Kitchenette', 1, '2025-11-16 09:03:38'),
(4, 'Family', 'Large room suitable for families', 2000000.00, 4, 'WiFi, TV, Air conditioning, Mini bar, Balcony, Extra bed', 1, '2025-11-16 09:03:38');

CREATE TABLE IF NOT EXISTS `services` (
  `service_id` int(11) NOT NULL AUTO_INCREMENT,
  `service_name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(12,2) NOT NULL,
  `category` enum('food','spa','laundry','transportation','entertainment','other') NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`service_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

INSERT INTO `services` (`service_id`, `service_name`, `description`, `price`, `category`, `is_active`, `created_at`) VALUES
(1, 'Breakfast Buffet', 'Continental breakfast buffet with Vietnamese and international options', 250000.00, 'food', 1, '2025-11-16 09:03:38'),
(2, 'Room Service', '24/7 room service with local and international cuisine', 150000.00, 'food', 1, '2025-11-16 09:03:38'),
(3, 'Spa Treatment', 'Relaxing spa treatment with professional therapists', 800000.00, 'spa', 1, '2025-11-16 09:03:38'),
(4, 'Laundry Service', 'Professional laundry and dry cleaning service', 100000.00, 'laundry', 1, '2025-11-16 09:03:38'),
(5, 'Airport Transfer', 'Complimentary airport pickup and drop-off', 300000.00, 'transportation', 1, '2025-11-16 09:03:38'),
(6, 'Car Rental', 'Daily car rental with driver', 1200000.00, 'transportation', 1, '2025-11-16 09:03:38'),
(7, 'Tour Guide', 'Professional tour guide for city exploration', 500000.00, 'entertainment', 1, '2025-11-16 09:03:38'),
(8, 'Gym Access', 'Access to fully equipped fitness center', 200000.00, 'entertainment', 1, '2025-11-16 09:03:38');

CREATE TABLE IF NOT EXISTS `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `role` enum('admin','manager','receptionist','housekeeping','maintenance') NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `users` (`user_id`, `username`, `password`, `email`, `full_name`, `phone`, `role`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'admin', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin@hotel.com', 'System Administrator', '0123456789', 'admin', 1, '2025-11-16 09:03:38', '2025-11-16 09:03:38'),
(2, 'manager', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'manager@hotel.com', 'Hotel Manager', '0123456788', 'manager', 1, '2025-11-16 09:03:38', '2025-11-16 09:03:38'),
(3, 'reception', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'reception@hotel.com', 'Reception Staff', '0123456787', 'receptionist', 1, '2025-11-16 09:03:38', '2025-11-16 09:03:38'),
(4, 'housekeeping', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'housekeeping@hotel.com', 'Housekeeping Staff', '0123456786', 'housekeeping', 1, '2025-11-16 09:03:38', '2025-11-16 09:03:38'),
(5, 'maintenance', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'maintenance@hotel.com', 'Maintenance Staff', '0123456785', 'maintenance', 1, '2025-11-16 09:03:38', '2025-11-16 09:03:38');

CREATE TABLE IF NOT EXISTS `user_roles` (
  `user_role_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `assigned_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `assigned_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`user_role_id`),
  UNIQUE KEY `unique_user_role` (`user_id`,`role_id`),
  KEY `assigned_by` (`assigned_by`),
  KEY `idx_user_roles_user` (`user_id`),
  KEY `idx_user_roles_role` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `user_roles` (`user_role_id`, `user_id`, `role_id`, `assigned_at`, `assigned_by`) VALUES
(36, 1, 1, '2025-12-20 02:30:36', NULL),
(37, 2, 2, '2025-12-20 02:30:36', NULL),
(38, 3, 3, '2025-12-20 02:30:36', NULL),
(39, 4, 4, '2025-12-20 02:30:36', NULL),
(40, 5, 5, '2025-12-20 02:30:36', NULL);
DROP TABLE IF EXISTS `current_room_status`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `current_room_status`  AS SELECT `r`.`room_id` AS `room_id`, `r`.`room_number` AS `room_number`, `rt`.`type_name` AS `type_name`, `rt`.`base_price` AS `base_price`, `r`.`status` AS `status`, `g`.`first_name` AS `first_name`, `g`.`last_name` AS `last_name`, `g`.`phone` AS `phone`, `b`.`check_in_date` AS `check_in_date`, `b`.`check_out_date` AS `check_out_date` FROM (((`rooms` `r` join `room_types` `rt` on(`r`.`room_type_id` = `rt`.`room_type_id`)) left join `bookings` `b` on(`r`.`room_id` = `b`.`room_id` and `b`.`status` in ('confirmed','checked_in'))) left join `guests` `g` on(`b`.`guest_id` = `g`.`guest_id`)) ;
DROP TABLE IF EXISTS `daily_occupancy`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `daily_occupancy`  AS SELECT cast(`bookings`.`check_in_date` as date) AS `date`, count(0) AS `total_check_ins`, sum(`bookings`.`adults` + `bookings`.`children`) AS `total_guests`, sum(`bookings`.`total_amount`) AS `daily_revenue` FROM `bookings` WHERE `bookings`.`status` in ('confirmed','checked_in','checked_out') GROUP BY cast(`bookings`.`check_in_date` as date) ;
DROP TABLE IF EXISTS `room_revenue`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `room_revenue`  AS SELECT `r`.`room_number` AS `room_number`, `rt`.`type_name` AS `type_name`, count(`b`.`booking_id`) AS `total_bookings`, sum(`b`.`total_amount`) AS `total_revenue`, avg(`b`.`total_amount`) AS `avg_revenue_per_booking` FROM ((`rooms` `r` join `room_types` `rt` on(`r`.`room_type_id` = `rt`.`room_type_id`)) left join `bookings` `b` on(`r`.`room_id` = `b`.`room_id` and `b`.`status` in ('checked_out','checked_in'))) GROUP BY `r`.`room_id`, `r`.`room_number`, `rt`.`type_name` ;


ALTER TABLE `audit_logs`
  ADD CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`guest_id`) REFERENCES `guests` (`guest_id`),
  ADD CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`),
  ADD CONSTRAINT `bookings_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`);

ALTER TABLE `guest_services`
  ADD CONSTRAINT `guest_services_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`),
  ADD CONSTRAINT `guest_services_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`);

ALTER TABLE `maintenance_records`
  ADD CONSTRAINT `maintenance_records_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`),
  ADD CONSTRAINT `maintenance_records_ibfk_2` FOREIGN KEY (`reported_by`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `maintenance_records_ibfk_3` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`user_id`);

ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`),
  ADD CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`processed_by`) REFERENCES `users` (`user_id`);

ALTER TABLE `reports`
  ADD CONSTRAINT `reports_ibfk_1` FOREIGN KEY (`generated_by`) REFERENCES `users` (`user_id`);

ALTER TABLE `resource_access`
  ADD CONSTRAINT `resource_access_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `resource_permissions`
  ADD CONSTRAINT `resource_permissions_ibfk_1` FOREIGN KEY (`resource_id`) REFERENCES `resource_access` (`resource_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `resource_permissions_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `resource_permissions_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `resource_permissions_ibfk_4` FOREIGN KEY (`granted_by`) REFERENCES `users` (`user_id`);

ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`);

ALTER TABLE `role_permissions`
  ADD CONSTRAINT `role_permissions_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_permissions_ibfk_2` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`permission_id`) ON DELETE CASCADE;

ALTER TABLE `rooms`
  ADD CONSTRAINT `rooms_ibfk_1` FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`room_type_id`);

ALTER TABLE `user_roles`
  ADD CONSTRAINT `user_roles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_roles_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_roles_ibfk_3` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`user_id`);



DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CalculateBookingTotal` (IN `p_room_type_id` INT, IN `p_check_in` DATE, IN `p_check_out` DATE, IN `p_adults` INT, IN `p_children` INT, OUT `p_total` DECIMAL(12,2))   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `CheckRoomAvailability` (IN `p_room_id` INT, IN `p_check_in` DATE, IN `p_check_out` DATE, OUT `p_available` BOOLEAN)   BEGIN
    DECLARE booking_count INT DEFAULT 0;
    
    SELECT COUNT(*) INTO booking_count
    FROM bookings 
    WHERE room_id = p_room_id 
    AND status IN ('confirmed', 'checked_in')
    AND NOT (p_check_out <= check_in_date OR p_check_in >= check_out_date);
    
    SET p_available = (booking_count = 0);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ProcessCheckIn` (IN `p_booking_id` INT, IN `p_user_id` INT, OUT `p_success` BOOLEAN)   BEGIN
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

DELIMITER ;

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

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
