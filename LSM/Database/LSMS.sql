-- ============================================================
-- LAUNDRY SHOP MANAGEMENT SYSTEM
-- MySQL 8.x / InnoDB
-- 7 TABLES
-- ============================================================

DROP DATABASE IF EXISTS laundry_shop_db;

CREATE DATABASE laundry_shop_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE laundry_shop_db;


-- 1. CUSTOMER
CREATE TABLE customer (
    customer_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(120) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    address VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;


-- 2. STAFF
CREATE TABLE staff (
    staff_id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(120) NOT NULL,
    role VARCHAR(40) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    CHECK (role IN ('Cashier','Laundry Attendant','Manager'))
) ENGINE=InnoDB;


-- 3. SERVICE TYPE
CREATE TABLE service_type (
    service_type_id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;


-- 4. SERVICE
CREATE TABLE service (
    service_id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL UNIQUE,
    service_type_id TINYINT UNSIGNED NOT NULL,
    current_price DECIMAL(10,2) NOT NULL,
    pricing_unit VARCHAR(20) NOT NULL,
    turnaround_hours INT UNSIGNED NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_service_type
        FOREIGN KEY (service_type_id)
        REFERENCES service_type(service_type_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CHECK (current_price >= 0),
    CHECK (turnaround_hours > 0),
    CHECK (pricing_unit IN ('KG','LOAD','PIECE','SET'))
) ENGINE=InnoDB;


-- 5. LAUNDRY ORDER
CREATE TABLE laundry_order (
    order_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT UNSIGNED NOT NULL,
    staff_id TINYINT UNSIGNED NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    due_date DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Received',
    notes VARCHAR(255),

    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_order_staff
        FOREIGN KEY (staff_id)
        REFERENCES staff(staff_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CHECK (due_date >= order_date),
    CHECK (status IN (
        'Received','Washing','Drying',
        'Ready','Released','Cancelled'
    ))
) ENGINE=InnoDB;


-- 6. ORDER ITEM
CREATE TABLE order_item (
    order_id BIGINT UNSIGNED NOT NULL,
    item_no INT UNSIGNED NOT NULL,
    service_id TINYINT UNSIGNED NOT NULL,
    quantity DECIMAL(10,2) NOT NULL,
    weight_kg DECIMAL(10,2),
    unit_price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(12,2) NOT NULL,

    PRIMARY KEY (order_id, item_no),

    CONSTRAINT fk_item_order
        FOREIGN KEY (order_id)
        REFERENCES laundry_order(order_id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_item_service
        FOREIGN KEY (service_id)
        REFERENCES service(service_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CHECK (quantity > 0),
    CHECK (weight_kg IS NULL OR weight_kg > 0),
    CHECK (unit_price >= 0),
    CHECK (subtotal >= 0),
    CHECK (subtotal = ROUND(quantity * unit_price, 2))
) ENGINE=InnoDB;


-- 7. PAYMENT
CREATE TABLE payment (
    payment_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT UNSIGNED NOT NULL,
    payment_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(12,2) NOT NULL,
    payment_method VARCHAR(20) NOT NULL,
    reference_no VARCHAR(80) UNIQUE,

    CONSTRAINT fk_payment_order
        FOREIGN KEY (order_id)
        REFERENCES laundry_order(order_id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CHECK (amount > 0),
    CHECK (payment_method IN ('Cash','GCash','Maya'))
) ENGINE=InnoDB;


-- ============================================================
-- SAMPLE DATA
-- ============================================================

-- CUSTOMER
INSERT INTO customer (full_name, phone, address) VALUES
('Kyla Perillo','09171234567','Goa, Camarines Sur'),
('Angela Reyes','09181234567','Goa, Camarines Sur'),
('Jessica Cruz','09191234567','Goa, Camarines Sur'),
('Jhoy Garcia','09201234567','Goa, Camarines Sur'),
('Angie Lopez','09211234567','Goa, Camarines Sur');


-- STAFF
INSERT INTO staff (full_name, role, phone) VALUES
('Liza Mendoza','Cashier','09301234567'),
('Carlo Ramos','Laundry Attendant','09311234567'),
('Nina Flores','Manager','09321234567');


-- SERVICE TYPE
INSERT INTO service_type (type_name) VALUES
('Laundry'),
('Specialty'),
('Bedding'),
('Finishing');


-- SERVICE
-- 1 = Laundry
-- 2 = Specialty
-- 3 = Bedding
-- 4 = Finishing

INSERT INTO service
(service_name, service_type_id, current_price,
 pricing_unit, turnaround_hours)
VALUES
('Wash and Fold',1,150.00,'KG',24),
('Wash Dry Fold',1,250.00,'KG',24),
('Dry Cleaning',2,180.00,'PIECE',48),
('Comforter Cleaning',3,350.00,'PIECE',48),
('Ironing',4,100.00,'PIECE',12);


-- LAUNDRY ORDER
INSERT INTO laundry_order
(customer_id, staff_id, order_date, due_date, status, notes)
VALUES
(1,1,'2026-09-25 09:00:00','2026-09-26 09:00:00','Ready','Regular laundry'),
(2,1,'2026-09-25 10:30:00','2026-09-27 10:30:00','Washing','Rush not requested'),
(3,1,'2026-09-26 08:15:00','2026-09-28 08:15:00','Received','Separate whites'),
(4,3,'2026-09-26 13:00:00','2026-09-28 13:00:00','Drying','Handle carefully'),
(5,1,'2026-09-27 09:20:00','2026-09-28 09:20:00','Released','Paid in full');


-- ORDER ITEM
INSERT INTO order_item
(order_id,item_no,service_id,quantity,weight_kg,unit_price,subtotal)
VALUES
(1,1,1,5.00,5.00,150.00,750.00),
(1,2,5,2.00,NULL,100.00,200.00),
(2,1,2,7.00,7.00,250.00,1750.00),
(3,1,1,4.00,4.00,150.00,600.00),
(3,2,4,1.00,NULL,350.00,350.00),
(4,1,3,2.00,NULL,180.00,360.00),
(5,1,2,6.00,6.00,250.00,1500.00);


-- PAYMENT
INSERT INTO payment
(order_id,payment_date,amount,payment_method,reference_no)
VALUES
(1,'2026-09-26 08:30:00',950.00,'Cash',NULL),
(2,'2026-09-25 10:35:00',1750.00,'GCash','GC-10001'),
(3,'2026-09-26 08:20:00',950.00,'Cash',NULL),
(4,'2026-09-26 13:05:00',360.00,'Maya','MY-10001'),
(5,'2026-09-28 09:15:00',1500.00,'Cash',NULL);


-- ============================================================
-- ANALYTICAL QUERIES
-- ============================================================

-- Q1. Order total, paid amount, and balance
SELECT
    o.order_id,
    c.full_name AS customer_name,
    o.order_date,
    o.due_date,
    o.status,
    COALESCE(SUM(oi.subtotal), 0) AS order_total,
    COALESCE(p.paid_amount, 0) AS paid_amount,
    COALESCE(SUM(oi.subtotal), 0)
        - COALESCE(p.paid_amount, 0) AS balance
FROM laundry_order o
JOIN customer c
    ON c.customer_id = o.customer_id
LEFT JOIN order_item oi
    ON oi.order_id = o.order_id
LEFT JOIN (
    SELECT
        order_id,
        SUM(amount) AS paid_amount
    FROM payment
    GROUP BY order_id
) p
    ON p.order_id = o.order_id
GROUP BY
    o.order_id,
    c.full_name,
    o.order_date,
    o.due_date,
    o.status,
    p.paid_amount;


-- Q2. Revenue by service
SELECT
    s.service_name,
    SUM(oi.quantity) AS quantity_sold,
    SUM(oi.subtotal) AS revenue
FROM order_item oi
JOIN service s
    ON s.service_id = oi.service_id
JOIN laundry_order o
    ON o.order_id = oi.order_id
WHERE o.status <> 'Cancelled'
GROUP BY s.service_id, s.service_name
ORDER BY revenue DESC;


-- Q3. Orders currently being processed
SELECT
    o.order_id,
    c.full_name AS customer,
    o.status,
    o.due_date
FROM laundry_order o
JOIN customer c
    ON c.customer_id = o.customer_id
WHERE o.status IN ('Received','Washing','Drying')
ORDER BY o.due_date;


-- Q4. Customers with total spending above 500
SELECT
    c.customer_id,
    c.full_name,
    SUM(oi.subtotal) AS total_spending
FROM customer c
JOIN laundry_order o
    ON o.customer_id = c.customer_id
JOIN order_item oi
    ON oi.order_id = o.order_id
WHERE o.status <> 'Cancelled'
GROUP BY c.customer_id, c.full_name
HAVING SUM(oi.subtotal) > 500
ORDER BY total_spending DESC;


-- Q5. Daily revenue
SELECT
    DATE(o.order_date) AS order_day,
    SUM(oi.subtotal) AS daily_revenue
FROM laundry_order o
JOIN order_item oi
    ON oi.order_id = o.order_id
WHERE o.status <> 'Cancelled'
GROUP BY DATE(o.order_date)
ORDER BY order_day;


-- ============================================================
-- INDEXING EXPERIMENT
-- ============================================================

-- BEFORE INDEX
EXPLAIN
SELECT o.order_id, o.status, o.due_date, c.full_name
FROM laundry_order o
JOIN customer c
    ON c.customer_id = o.customer_id
WHERE o.status = 'Ready'
  AND o.due_date >= '2026-09-26 00:00:00'
ORDER BY o.due_date;


-- CREATE INDEXES
CREATE INDEX idx_order_status_due
    ON laundry_order(status, due_date);

CREATE INDEX idx_order_customer
    ON laundry_order(customer_id);

CREATE INDEX idx_order_item_service
    ON order_item(service_id);

CREATE INDEX idx_payment_order_date
    ON payment(order_id, payment_date);


-- AFTER INDEX
EXPLAIN
SELECT o.order_id, o.status, o.due_date, c.full_name
FROM laundry_order o
JOIN customer c
    ON c.customer_id = o.customer_id
WHERE o.status = 'Ready'
  AND o.due_date >= '2026-09-26 00:00:00'
ORDER BY o.due_date;


-- VIEW INDEXES
SHOW INDEX FROM laundry_order;
SHOW INDEX FROM order_item;
SHOW INDEX FROM payment;