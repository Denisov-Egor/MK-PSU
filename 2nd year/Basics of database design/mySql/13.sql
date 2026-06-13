-- ======================================================
-- Database: HairSalon
-- Variant 13: Парикмахерская (Hair Salon)
-- Tables: Branches, Clients, Visits, Services
-- All data in English
-- ======================================================

-- Create and use database
CREATE DATABASE IF NOT EXISTS HairSalon;
USE HairSalon;

-- 1. Table: Branches (Филиалы)
CREATE TABLE Branches (
    BranchID INT NOT NULL AUTO_INCREMENT,
    Address VARCHAR(255) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(50) NOT NULL,
    Manager VARCHAR(100) NOT NULL,
    PRIMARY KEY (BranchID)
) ENGINE=InnoDB;

-- 2. Table: Clients (Клиенты)
CREATE TABLE Clients (
    ClientID INT NOT NULL AUTO_INCREMENT,
    FullName VARCHAR(255) NOT NULL,
    Phone VARCHAR(50) NOT NULL,
    DateOfBirth DATE,
    Gender ENUM('Male', 'Female', 'Other') NOT NULL,
    PRIMARY KEY (ClientID)
) ENGINE=InnoDB;

-- 3. Table: Visits (Посещения)
CREATE TABLE Visits (
    VisitID INT NOT NULL AUTO_INCREMENT,
    BranchID INT NOT NULL,
    Date DATE NOT NULL,
    ClientID INT NOT NULL,
    IsRegular BOOLEAN DEFAULT FALSE,
    TotalAmount DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (VisitID),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 4. Table: Services (Услуг)
CREATE TABLE Services (
    ServiceID INT NOT NULL AUTO_INCREMENT,
    VisitID INT NOT NULL,
    ServiceName VARCHAR(100) NOT NULL,
    Gender ENUM('Male', 'Female', 'Other') NOT NULL,
    PRIMARY KEY (ServiceID),
    FOREIGN KEY (VisitID) REFERENCES Visits(VisitID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ======================================================
-- Insert sample data (in English)
-- ======================================================

-- Insert branches
INSERT INTO Branches (Address, Name, Phone, Manager) VALUES
('123 Main Street, New York, NY 10001', 'Downtown Beauty Salon', '+1-212-555-1234', 'Alice Johnson'),
('456 Oak Avenue, Los Angeles, CA 90001', 'Sunset Hair Studio', '+1-310-555-5678', 'Robert Smith'),
('789 Pine Road, Chicago, IL 60601', 'Windy City Cuts', '+1-312-555-9012', 'Maria Garcia');

-- Insert clients
INSERT INTO Clients (FullName, Phone, DateOfBirth, Gender) VALUES
('John Doe', '+1-917-555-1111', '1985-03-15', 'Male'),
('Jane Smith', '+1-718-555-2222', '1990-07-22', 'Female'),
('Michael Brown', '+1-212-555-3333', '1978-11-02', 'Male'),
('Emily Davis', '+1-310-555-4444', '1995-05-10', 'Female'),
('David Wilson', '+1-312-555-5555', '1982-09-30', 'Male');

-- Insert visits
INSERT INTO Visits (BranchID, Date, ClientID, IsRegular, TotalAmount) VALUES
(1, '2025-01-10', 1, TRUE, 75.00),
(1, '2025-01-15', 2, FALSE, 120.00),
(2, '2025-01-18', 3, TRUE, 95.00),
(2, '2025-01-20', 4, TRUE, 60.00),
(3, '2025-01-22', 5, FALSE, 110.00),
(1, '2025-02-01', 1, TRUE, 80.00),
(3, '2025-02-05', 2, FALSE, 130.00);

-- Insert services (each service belongs to a visit)
INSERT INTO Services (VisitID, ServiceName, Gender) VALUES
(1, 'Haircut', 'Male'),
(1, 'Beard Trim', 'Male'),
(2, 'Hair Coloring', 'Female'),
(2, 'Styling', 'Female'),
(3, 'Haircut', 'Male'),
(3, 'Scalp Treatment', 'Male'),
(4, 'Haircut', 'Female'),
(4, 'Blow-dry', 'Female'),
(5, 'Haircut', 'Male'),
(5, 'Shave', 'Male'),
(6, 'Haircut', 'Male'),
(6, 'Beard Trim', 'Male'),
(7, 'Hair Coloring', 'Female'),
(7, 'Hair Treatment', 'Female');

-- ======================================================
-- Verify data (optional queries)
-- ======================================================
-- SELECT * FROM Branches;
-- SELECT * FROM Clients;
-- SELECT * FROM Visits;
-- SELECT * FROM Services;