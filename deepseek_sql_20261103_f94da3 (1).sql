-- ================================================================
-- RST ELECTRONICS OMAN — ERP DATABASE
-- Version: 5.0.0
-- Currency: OMR (3 decimal places)
-- VAT: Oman 5% Standard
-- Encoding: UTF8MB4 (Arabic/Bangla/Urdu support)
-- ================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+04:00";

-- Create database
CREATE DATABASE IF NOT EXISTS `rst_erp_v5` 
    CHARACTER SET utf8mb4 
    COLLATE utf8mb4_unicode_ci;

USE `rst_erp_v5`;

-- ================================================================
-- DROP TABLES (if re-installing)
-- ================================================================
DROP TABLE IF EXISTS `sale_items`;
DROP TABLE IF EXISTS `sales`;
DROP TABLE IF EXISTS `product_imei`;
DROP TABLE IF EXISTS `stock`;
DROP TABLE IF EXISTS `products`;
DROP TABLE IF EXISTS `brands`;
DROP TABLE IF EXISTS `categories`;
DROP TABLE IF EXISTS `customers`;
DROP TABLE IF EXISTS `bill_transactions`;
DROP TABLE IF EXISTS `bill_providers`;
DROP TABLE IF EXISTS `repair_jobs`;
DROP TABLE IF EXISTS `login_history`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `branches`;
DROP TABLE IF EXISTS `companies`;

-- ================================================================
-- 1. COMPANIES
-- ================================================================
CREATE TABLE `companies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_code` varchar(50) NOT NULL,
  `company_name` varchar(200) NOT NULL,
  `company_name_ar` varchar(200) DEFAULT NULL,
  `legal_name` varchar(250) DEFAULT NULL,
  `cr_number` varchar(50) DEFAULT NULL,
  `vat_number` varchar(50) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `whatsapp` varchar(30) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `website` varchar(150) DEFAULT NULL,
  `address` text,
  `city` varchar(100) DEFAULT 'Muscat',
  `country` varchar(100) DEFAULT 'Oman',
  `currency` varchar(10) DEFAULT 'OMR',
  `vat_rate` decimal(5,2) DEFAULT 5.00,
  `vat_enabled` tinyint(1) DEFAULT 1,
  `invoice_prefix` varchar(20) DEFAULT 'RST-INV',
  `invoice_next_number` int(11) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `company_code` (`company_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 2. BRANCHES
-- ================================================================
CREATE TABLE `branches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `branch_name` varchar(200) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `is_main` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `branches_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 3. USERS
-- ================================================================
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `branch_id` int(11) DEFAULT NULL,
  `role` varchar(30) DEFAULT 'cashier',
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(200) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `last_login` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `company_id` (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 4. LOGIN HISTORY
-- ================================================================
CREATE TABLE `login_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `ip` varchar(45) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 5. CATEGORIES
-- ================================================================
CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `category_name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 6. BRANDS
-- ================================================================
CREATE TABLE `brands` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `brand_name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 7. PRODUCTS (with image support)
-- ================================================================
CREATE TABLE `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `product_code` varchar(50) NOT NULL,
  `barcode` varchar(100) DEFAULT NULL,
  `product_name` varchar(250) NOT NULL,
  `brand_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `model` varchar(150) DEFAULT NULL,
  `variant` varchar(150) DEFAULT NULL,
  `color` varchar(50) DEFAULT NULL,
  `specs` text,
  `condition_type` varchar(20) DEFAULT 'new',
  `product_type` varchar(30) DEFAULT 'mobile',
  `cost_price` decimal(15,3) DEFAULT 0.000,
  `selling_price` decimal(15,3) DEFAULT 0.000,
  `vat_rate` decimal(5,2) DEFAULT 5.00,
  `track_imei` tinyint(1) DEFAULT 0,
  `warranty_months` int(11) DEFAULT 0,
  `reorder_level` int(11) DEFAULT 5,
  `main_image` longtext,
  `image_2` longtext,
  `image_3` longtext,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`),
  KEY `brand_id` (`brand_id`),
  KEY `category_id` (`category_id`),
  KEY `barcode` (`barcode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 8. PRODUCT IMEI
-- ================================================================
CREATE TABLE `product_imei` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `imei_number` varchar(50) DEFAULT NULL,
  `branch_id` int(11) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'in_stock',
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `imei_number` (`imei_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 9. STOCK
-- ================================================================
CREATE TABLE `stock` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `branch_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` decimal(15,3) DEFAULT 0.000,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_stock` (`branch_id`,`product_id`),
  KEY `product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 10. CUSTOMERS
-- ================================================================
CREATE TABLE `customers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `customer_code` varchar(50) DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `company_name` varchar(200) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `credit_limit` decimal(15,3) DEFAULT 0.000,
  `current_balance` decimal(15,3) DEFAULT 0.000,
  `customer_type` varchar(20) DEFAULT 'retail',
  `status` varchar(20) DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`),
  KEY `phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 11. SALES
-- ================================================================
CREATE TABLE `sales` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `invoice_no` varchar(50) DEFAULT NULL,
  `invoice_date` datetime DEFAULT NULL,
  `customer_name` varchar(200) DEFAULT 'Walk-in Customer',
  `subtotal` decimal(15,3) DEFAULT 0.000,
  `vat_amount` decimal(15,3) DEFAULT 0.000,
  `total_amount` decimal(15,3) DEFAULT 0.000,
  `paid_amount` decimal(15,3) DEFAULT 0.000,
  `change_amount` decimal(15,3) DEFAULT 0.000,
  `payment_method` varchar(30) DEFAULT 'cash',
  `sold_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`),
  KEY `branch_id` (`branch_id`),
  KEY `invoice_no` (`invoice_no`),
  KEY `invoice_date` (`invoice_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 12. SALE ITEMS
-- ================================================================
CREATE TABLE `sale_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sale_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_name` varchar(250) DEFAULT NULL,
  `quantity` decimal(15,3) DEFAULT NULL,
  `unit_price` decimal(15,3) DEFAULT NULL,
  `cost_price` decimal(15,3) DEFAULT 0.000,
  `vat_rate` decimal(5,2) DEFAULT 5.00,
  `line_total` decimal(15,3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sale_id` (`sale_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `sale_items_ibfk_1` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 13. BILL PROVIDERS (Oman)
-- ================================================================
CREATE TABLE `bill_providers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `provider_name` varchar(150) DEFAULT NULL,
  `provider_type` varchar(50) DEFAULT NULL,
  `commission_percent` decimal(5,2) DEFAULT 0.00,
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 14. BILL TRANSACTIONS
-- ================================================================
CREATE TABLE `bill_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `provider_id` int(11) NOT NULL,
  `transaction_code` varchar(50) DEFAULT NULL,
  `account_number` varchar(100) DEFAULT NULL,
  `customer_name` varchar(200) DEFAULT NULL,
  `bill_amount` decimal(15,3) DEFAULT NULL,
  `service_fee` decimal(15,3) DEFAULT 0.000,
  `commission` decimal(15,3) DEFAULT 0.000,
  `total_amount` decimal(15,3) DEFAULT NULL,
  `payment_method` varchar(30) DEFAULT 'cash',
  `processed_by` int(11) DEFAULT NULL,
  `transaction_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`),
  KEY `provider_id` (`provider_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- 15. REPAIR JOBS
-- ================================================================
CREATE TABLE `repair_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `branch_id` int(11) NOT NULL,
  `job_no` varchar(50) DEFAULT NULL,
  `customer_name` varchar(200) DEFAULT NULL,
  `customer_phone` varchar(30) DEFAULT NULL,
  `device_type` varchar(100) DEFAULT NULL,
  `device_brand` varchar(100) DEFAULT NULL,
  `device_model` varchar(150) DEFAULT NULL,
  `serial_imei` varchar(100) DEFAULT NULL,
  `problem_description` text,
  `estimated_cost` decimal(15,3) DEFAULT 0.000,
  `advance_paid` decimal(15,3) DEFAULT 0.000,
  `status` varchar(30) DEFAULT 'received',
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`),
  KEY `branch_id` (`branch_id`),
  KEY `job_no` (`job_no`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;

-- ================================================================
-- SEED DATA
-- ================================================================

-- Company
INSERT INTO `companies` (
  `id`, `company_code`, `company_name`, `company_name_ar`, `legal_name`,
  `cr_number`, `vat_number`, `phone`, `email`, `website`, `address`,
  `city`, `country`, `currency`, `vat_rate`, `invoice_prefix`
) VALUES (
  1, 'RST', 'RST Electronics Oman', 'آر إس تي إلكترونيكس عمان', 'RST Trading LLC',
  '1234567', 'OM110009988', '+968 2456 7890', 'info@rst-electronics.om',
  'rst-electronics.om', 'Shop 12, Al Khuwair Commercial Center',
  'Muscat', 'Oman', 'OMR', 5.00, 'RST-INV'
);

-- Branches
INSERT INTO `branches` (`id`, `company_id`, `branch_name`, `phone`, `city`, `is_main`) VALUES
(1, 1, 'Muscat Main Branch', '+968 2456 7890', 'Muscat', 1),
(2, 1, 'Salalah Branch', '+968 2321 4567', 'Salalah', 0);

-- Users — password for ALL is: admin123
-- Bcrypt hash generated with password_hash('admin123', PASSWORD_BCRYPT)
INSERT INTO `users` (`company_id`, `branch_id`, `role`, `username`, `password`, `full_name`, `email`) VALUES
(1, 1, 'master_admin', 'admin',      '$2y$10$YourHashWillBeGeneratedHere0000000000000000000000000000000000', 'Mohammed Al Rashdi', 'admin@rst-electronics.om'),
(1, 1, 'manager',      'manager',    '$2y$10$YourHashWillBeGeneratedHere0000000000000000000000000000000000', 'Ahmed Al Balushi',   'manager@rst-electronics.om'),
(1, 1, 'cashier',      'cashier',    '$2y$10$YourHashWillBeGeneratedHere0000000000000000000000000000000000', 'Salim Al Habsi',     'cashier@rst-electronics.om'),
(1, 1, 'technician',   'technician', '$2y$10$YourHashWillBeGeneratedHere0000000000000000000000000000000000', 'Khalid Al Mahrouqi', 'tech@rst-electronics.om');

-- IMPORTANT: Password hash placeholder উপরেরগুলো কাজ করবে না!
-- index.php auto-generate করে ঠিক পাসওয়ার্ড।
-- কিন্তু এই SQL আলাদা চালালে, নিচের UPDATE রান করুন (আপনার PHP-তে):

-- UPDATE users SET password = password_hash('admin123', PASSWORD_BCRYPT);
-- অথবা index.php দিয়ে login করলে auto-fix হবে।

-- Categories
INSERT INTO `categories` (`company_id`, `category_name`) VALUES
(1, 'Mobile Phones'),
(1, 'Accessories'),
(1, 'Electronics'),
(1, 'CCTV & Smart'),
(1, 'Spare Parts');

-- Brands
INSERT INTO `brands` (`company_id`, `brand_name`) VALUES
(1, 'Samsung'),
(1, 'Apple'),
(1, 'Xiaomi'),
(1, 'Oppo'),
(1, 'Vivo'),
(1, 'Anker'),
(1, 'JBL'),
(1, 'Sony'),
(1, 'Hikvision');

-- Products (Mobile Phones with detailed specs)
INSERT INTO `products` (
  `company_id`, `product_code`, `barcode`, `product_name`, `brand_id`, `category_id`,
  `model`, `variant`, `color`, `specs`, `product_type`,
  `cost_price`, `selling_price`, `warranty_months`, `track_imei`
) VALUES
(1, 'MOB-SAM-S24', '8901234567890', 'Samsung Galaxy S24', 1, 1, 'Galaxy S24', '8GB / 256GB', 'Black',
 '6.2" Dynamic AMOLED 2X, Snapdragon 8 Gen 3, 50MP + 12MP + 10MP Triple Camera, 4000mAh Battery, Android 14, IP68',
 'mobile', 320.000, 449.900, 12, 1),

(1, 'MOB-APP-IP16', '8901234567891', 'Apple iPhone 16', 2, 1, 'iPhone 16', '8GB / 128GB', 'Black',
 '6.1" Super Retina XDR, A18 Bionic Chip, 48MP + 12MP Dual Camera, iOS 18, Face ID, 3561mAh, IP68',
 'mobile', 420.000, 579.900, 12, 1),

(1, 'MOB-XIA-14', '8901234567892', 'Xiaomi 14', 3, 1, 'Xiaomi 14', '12GB / 256GB', 'Black',
 '6.36" LTPO AMOLED 120Hz, Snapdragon 8 Gen 3, 50MP Leica Triple Camera, 4610mAh, 90W Fast Charge',
 'mobile', 280.000, 399.900, 12, 1),

(1, 'MOB-OPP-R12', '8901234567893', 'Oppo Reno 12', 4, 1, 'Reno 12', '8GB / 256GB', 'Green',
 '6.7" AMOLED 120Hz, Dimensity 7300, 50MP Triple Camera, 5000mAh, 80W SuperVOOC',
 'mobile', 180.000, 249.900, 12, 1),

(1, 'MOB-VIV-V40', '8901234567894', 'Vivo V40', 5, 1, 'V40', '8GB / 256GB', 'Blue',
 '6.78" AMOLED 120Hz, Snapdragon 7 Gen 3, 50MP ZEISS Dual Camera, 5500mAh, 80W FlashCharge',
 'mobile', 150.000, 219.900, 12, 1);

-- Accessories
INSERT INTO `products` (
  `company_id`, `product_code`, `barcode`, `product_name`, `brand_id`, `category_id`,
  `model`, `variant`, `color`, `specs`, `product_type`,
  `cost_price`, `selling_price`, `warranty_months`, `track_imei`
) VALUES
(1, 'ACC-ANK-PB20', '8901234567900', 'Anker Power Bank 20000mAh', 6, 2, 'PowerCore 20000', '20000mAh', 'Black',
 '20000mAh, 22.5W Fast Charge, Dual USB-A + USB-C PD, LED Indicator',
 'accessory', 12.500, 18.900, 12, 0),

(1, 'ACC-JBL-GO4', '8901234567901', 'JBL Go 4 Speaker', 7, 2, 'Go 4', 'Portable', 'Blue',
 'Portable Bluetooth Speaker, IP67 Waterproof, 7 Hours Playtime, JBL Pro Sound',
 'accessory', 12.000, 18.500, 12, 0),

(1, 'ACC-SCR-GLASS', '8901234567902', 'Tempered Glass Protector', NULL, 2, '9H', 'Standard', 'Clear',
 '9H Hardness, Anti-Scratch, Bubble-Free, HD Clarity, Easy Install',
 'accessory', 0.500, 2.500, 0, 0);

-- Electronics
INSERT INTO `products` (
  `company_id`, `product_code`, `barcode`, `product_name`, `brand_id`, `category_id`,
  `model`, `variant`, `color`, `specs`, `product_type`,
  `cost_price`, `selling_price`, `warranty_months`, `track_imei`
) VALUES
(1, 'ELE-SON-TV55', '8901234567910', 'Sony Bravia 55" 4K TV', 8, 3, 'Bravia XR', '55"', 'Black',
 '55" 4K UHD, Google TV, Dolby Vision, XR Cognitive Processor, 4x HDMI',
 'electronics', 280.000, 399.000, 24, 0);

-- CCTV
INSERT INTO `products` (
  `company_id`, `product_code`, `barcode`, `product_name`, `brand_id`, `category_id`,
  `model`, `variant`, `color`, `specs`, `product_type`,
  `cost_price`, `selling_price`, `warranty_months`, `track_imei`
) VALUES
(1, 'CCTV-HIK-2MP', '8901234567920', 'Hikvision 2MP Camera', 9, 4, 'DS-2CE5AD0T', '2MP', 'White',
 '2MP Full HD, IR Range 20m, IP67 Waterproof, 4-in-1 (TVI/AHD/CVI/CVBS)',
 'cctv_smart', 15.000, 25.000, 24, 0),

(1, 'CCTV-HIK-4CH', '8901234567921', 'Hikvision 4CH DVR', 9, 4, 'DS-7204HGHI', '4 Channel', 'Black',
 '4CH 1080p Lite, H.265+ Compression, HDMI + VGA Output, Mobile App Support',
 'cctv_smart', 35.000, 55.000, 24, 0);

-- Stock — Muscat branch (id=1)
INSERT INTO `stock` (`branch_id`, `product_id`, `quantity`) VALUES
(1, 1, 3),    -- Samsung S24
(1, 2, 2),    -- iPhone 16
(1, 3, 4),    -- Xiaomi 14
(1, 4, 5),    -- Oppo Reno 12
(1, 5, 3),    -- Vivo V40
(1, 6, 20),   -- Anker Power Bank
(1, 7, 15),   -- JBL Speaker
(1, 8, 100),  -- Tempered Glass
(1, 9, 3),    -- Sony TV
(1, 10, 20),  -- Hikvision Camera
(1, 11, 10);  -- Hikvision DVR

-- Stock — Salalah branch (id=2)
INSERT INTO `stock` (`branch_id`, `product_id`, `quantity`) VALUES
(2, 1, 1),    -- Samsung S24
(2, 2, 1),    -- iPhone 16
(2, 6, 10),   -- Anker Power Bank
(2, 10, 8);   -- Hikvision Camera

-- Customers
INSERT INTO `customers` (
  `company_id`, `customer_code`, `first_name`, `last_name`, `company_name`,
  `phone`, `city`, `credit_limit`, `customer_type`
) VALUES
(1, 'CUST-0001', 'Ahmed',  'Al Balushi', 'Al Balushi Trading', '99887766', 'Muscat', 5000.000, 'wholesale'),
(1, 'CUST-0002', 'Fatma',  'Al Zadjali', NULL,                 '99001122', 'Muscat', 1000.000, 'vip'),
(1, 'CUST-0003', 'Khalid', 'Al Hinai',   NULL,                 '91122334', 'Salalah', 200.000, 'retail');

-- Bill Providers (Oman)
INSERT INTO `bill_providers` (`company_id`, `provider_name`, `provider_type`, `commission_percent`) VALUES
(1, 'Omantel',             'telecom',       1.500),
(1, 'Ooredoo Oman',        'telecom',       1.500),
(1, 'Vodafone Oman',       'telecom',       1.750),
(1, 'Nama Electricity',    'electricity',   0.750),
(1, 'Nama Water',          'water',         0.750),
(1, 'Muscat Municipality', 'municipality',  0.500),
(1, 'ROP Traffic Fines',   'government',    0.000);

-- ================================================================
-- IMPORTANT: Password Hash Fix
-- ================================================================
-- The password hashes above are PLACEHOLDERS and will NOT work!
-- Two ways to fix:
--
-- 1. Use index.php — it auto-generates correct hash on first visit
-- 2. OR run this in phpMyAdmin SQL tab (after importing):
--
--    UPDATE users SET password = '$2y$10$xxxxx...' 
--    WHERE username = 'admin';
--
-- To generate a valid bcrypt hash, create `genhash.php` with:
--
--    <?php echo password_hash('admin123', PASSWORD_BCRYPT);
--
-- Then copy the output and update users table.

-- ================================================================
-- END OF DATABASE.SQL
-- ================================================================