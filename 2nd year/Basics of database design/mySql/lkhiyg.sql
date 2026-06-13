-- =====================================================
-- Лабораторная работа №1, Вариант 13
-- База данных «Парикмахерская» (Hair Salon)
-- Все названия таблиц и полей даны на английском,
-- данные также на английском языке.
-- =====================================================

-- 1. Удаляем старую базу, если существует, и создаём новую
DROP DATABASE IF EXISTS hair_salon;
CREATE DATABASE hair_salon;
USE hair_salon;

-- 2. Создание таблиц

-- Таблица "Филиалы" (Branches)
CREATE TABLE branches (
    branch_id INT PRIMARY KEY AUTO_INCREMENT,
    address VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    manager VARCHAR(100) NOT NULL
);

-- Таблица "Клиенты" (Clients)
CREATE TABLE clients (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    birth_date DATE NOT NULL,
    gender ENUM('Male', 'Female') NOT NULL
);

-- Таблица "Посещения" (Visits)
CREATE TABLE visits (
    visit_id INT PRIMARY KEY AUTO_INCREMENT,
    branch_id INT NOT NULL,
    visit_date DATE NOT NULL,
    client_id INT NOT NULL,
    is_regular BOOLEAN DEFAULT FALSE,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE RESTRICT,
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE
);

-- Таблица "Услуги" (Services)
CREATE TABLE services (
    service_id INT PRIMARY KEY AUTO_INCREMENT,
    visit_id INT NOT NULL,
    service_name VARCHAR(255) NOT NULL,
    gender_specific ENUM('Male', 'Female', 'Unisex') NOT NULL,
    FOREIGN KEY (visit_id) REFERENCES visits(visit_id) ON DELETE CASCADE
);

-- 3. Заполнение таблиц тестовыми данными (на английском языке)

-- Филиалы
INSERT INTO branches (address, name, phone, manager) VALUES
('123 Main Street, Downtown', 'Downtown Branch', '+1 555-0101', 'Alice Johnson'),
('456 Oak Avenue, Uptown', 'Uptown Branch', '+1 555-0102', 'Bob Williams'),
('789 Pine Road, Westside', 'Westside Branch', '+1 555-0103', 'Carol Davis');

-- Клиенты
INSERT INTO clients (full_name, phone, birth_date, gender) VALUES
('John Smith', '+1 555-1001', '1985-03-12', 'Male'),
('Emma Johnson', '+1 555-1002', '1990-07-24', 'Female'),
('Michael Brown', '+1 555-1003', '1978-11-05', 'Male'),
('Sophia Davis', '+1 555-1004', '1995-01-30', 'Female'),
('William Wilson', '+1 555-1005', '1982-09-17', 'Male'),
('Olivia Martinez', '+1 555-1006', '1992-12-10', 'Female');

-- Посещения
INSERT INTO visits (branch_id, visit_date, client_id, is_regular, total_amount) VALUES
(1, '2025-05-10', 1, TRUE, 45.00),
(1, '2025-05-12', 2, FALSE, 60.00),
(2, '2025-05-15', 3, TRUE, 35.00),
(2, '2025-05-16', 4, TRUE, 80.00),
(3, '2025-05-18', 5, FALSE, 50.00),
(1, '2025-05-20', 6, TRUE, 70.00),
(2, '2025-05-22', 1, TRUE, 40.00),
(3, '2025-05-25', 2, FALSE, 55.00);

-- Услуги, оказанные в каждом посещении
INSERT INTO services (visit_id, service_name, gender_specific) VALUES
(1, 'Haircut', 'Male'),
(1, 'Beard Trim', 'Male'),
(2, 'Hair Coloring', 'Female'),
(2, 'Styling', 'Female'),
(3, 'Haircut', 'Male'),
(3, 'Shampoo', 'Unisex'),
(4, 'Full Makeup', 'Female'),
(4, 'Hair Styling', 'Female'),
(5, 'Haircut', 'Male'),
(5, 'Facial', 'Unisex'),
(6, 'Hair Coloring', 'Female'),
(6, 'Manicure', 'Female'),
(7, 'Haircut', 'Male'),
(8, 'Haircut', 'Female'),
(8, 'Styling', 'Female');

-- 4. Примеры запросов для вывода информации (по усмотрению преподавателя)

-- 4.1. Список всех посещений с именем клиента, филиалом, датой и суммой
SELECT 
    v.visit_id AS 'Visit ID',
    c.full_name AS 'Client',
    b.name AS 'Branch',
    v.visit_date AS 'Date',
    v.total_amount AS 'Total Amount ($)',
    IF(v.is_regular, 'Yes', 'No') AS 'Regular Client'
FROM visits v
JOIN clients c ON v.client_id = c.client_id
JOIN branches b ON v.branch_id = b.branch_id
ORDER BY v.visit_date;

-- 4.2. Все услуги с привязкой к посещению и клиенту
SELECT 
    s.service_id AS 'Service ID',
    c.full_name AS 'Client',
    v.visit_date AS 'Visit Date',
    s.service_name AS 'Service',
    s.gender_specific AS 'For Gender'
FROM services s
JOIN visits v ON s.visit_id = v.visit_id
JOIN clients c ON v.client_id = c.client_id
ORDER BY v.visit_date, s.service_id;

-- 4.3. Постоянные клиенты (is_regular = TRUE) и общая сумма их трат
SELECT 
    c.full_name AS 'Client',
    COUNT(v.visit_id) AS 'Total Visits',
    SUM(v.total_amount) AS 'Total Spent ($)',
    c.phone AS 'Phone'
FROM clients c
JOIN visits v ON c.client_id = v.client_id
WHERE v.is_regular = TRUE
GROUP BY c.client_id
ORDER BY SUM(v.total_amount) DESC;

-- 4.4. Выручка по каждому филиалу
SELECT 
    b.name AS 'Branch',
    COUNT(v.visit_id) AS 'Number of Visits',
    SUM(v.total_amount) AS 'Revenue ($)'
FROM branches b
LEFT JOIN visits v ON b.branch_id = v.branch_id
GROUP BY b.branch_id
ORDER BY Revenue DESC;

-- 4.5. Самая популярная услуга (количество раз, когда она была оказана)
SELECT 
    service_name AS 'Service',
    COUNT(*) AS 'Times Provided'
FROM services
GROUP BY service_name
ORDER BY COUNT(*) DESC
LIMIT 5;

-- 4.6. Клиенты, которые посещали салон более одного раза
SELECT 
    c.full_name AS 'Client',
    COUNT(v.visit_id) AS 'Visit Count',
    GROUP_CONCAT(DATE(v.visit_date) ORDER BY v.visit_date SEPARATOR ', ') AS 'Visit Dates'
FROM clients c
JOIN visits v ON c.client_id = v.client_id
GROUP BY c.client_id
HAVING COUNT(v.visit_id) > 1;