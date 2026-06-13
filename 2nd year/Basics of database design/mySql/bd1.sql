-- ======================================================
-- Variant 4: Graduates Database (Выпускники учебного заведения)
-- All table and column names are in English for clarity.
-- Russian equivalents are shown in comments.
-- ======================================================

DROP DATABASE IF EXISTS GraduatesDB;
CREATE DATABASE GraduatesDB;
USE GraduatesDB;

-- 1. Table: Educational Institution (Учебное заведение)
CREATE TABLE EducationalInstitution (
    institution_id INT PRIMARY KEY AUTO_INCREMENT,  -- Код_учебного_заведения
    name VARCHAR(255) NOT NULL,                     -- Наименование
    direction VARCHAR(255),                         -- Направление учебного заведения
    foundation_date DATE                            -- Дата поступления (foundation date)
);

-- 2. Table: Employment (Трудоустройство)
CREATE TABLE Employment (
    organization_id INT PRIMARY KEY AUTO_INCREMENT, -- Код_организации
    name VARCHAR(255) NOT NULL,                     -- Наименование
    position VARCHAR(255),                          -- Должность
    hire_date DATE,                                 -- Дата (employment date)
    contact_info VARCHAR(255)                       -- Контактная информация
);

-- 3. Table: Graduate (Выпускник)
CREATE TABLE Graduate (
    graduate_id INT PRIMARY KEY AUTO_INCREMENT,     -- Код_выпускника
    full_name VARCHAR(255) NOT NULL,                -- ФИО
    year_of_admission INT,                          -- Год поступления
    year_of_graduation INT,                         -- Год выпуска
    institution_id INT,                             -- Код_учебного_заведения
    organization_id INT,                            -- Код_организации
    address VARCHAR(255),                           -- Адрес
    phone VARCHAR(50),                              -- Телефон
    FOREIGN KEY (institution_id) REFERENCES EducationalInstitution(institution_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (organization_id) REFERENCES Employment(organization_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- 4. Table: Centralized Testing (ЦТ – Централизованное тестирование)
CREATE TABLE CentralizedTest (
    test_id INT PRIMARY KEY AUTO_INCREMENT,         -- surrogate key
    graduate_id INT NOT NULL,                       -- Код_выпускника
    subject_name VARCHAR(255) NOT NULL,             -- Название предмета
    score INT CHECK (score >= 0 AND score <= 100),  -- Количество баллов
    teacher VARCHAR(255),                           -- Преподаватель
    FOREIGN KEY (graduate_id) REFERENCES Graduate(graduate_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ======================================================
-- INSERT SAMPLE DATA (all in English)
-- ======================================================

-- Educational Institutions
INSERT INTO EducationalInstitution (name, direction, foundation_date) VALUES
('University of Computer Science', 'Software Engineering', '1995-09-01'),
('Institute of Engineering', 'Mechanical Engineering', '1980-08-15'),
('College of Arts and Humanities', 'Liberal Arts', '2000-01-10'),
('Business School of Economics', 'Finance and Management', '2005-03-20');

-- Employment (organizations)
INSERT INTO Employment (name, position, hire_date, contact_info) VALUES
('TechCorp Solutions', 'Junior Developer', '2022-06-01', 'hr@techcorp.com'),
('DataWorks Analytics', 'Data Analyst', '2023-01-15', 'contact@dataworks.com'),
('Innovate Ltd', 'Project Manager', '2021-11-10', 'info@innovate.com'),
('Global Finance Group', 'Financial Advisor', '2022-09-20', 'careers@globalfinance.com'),
('Self-employed', 'Freelance Consultant', '2023-03-01', 'freelance@example.com');

-- Graduates
INSERT INTO Graduate (full_name, year_of_admission, year_of_graduation, institution_id, organization_id, address, phone) VALUES
('John Smith', 2018, 2022, 1, 1, '123 Main St, New York, NY', '+1-555-0101'),
('Emily Johnson', 2017, 2021, 1, 2, '456 Oak Ave, Boston, MA', '+1-555-0102'),
('Michael Brown', 2019, 2023, 2, 3, '789 Pine Rd, Chicago, IL', '+1-555-0103'),
('Jessica Davis', 2016, 2020, 2, 1, '101 Maple Dr, Austin, TX', '+1-555-0104'),
('David Wilson', 2018, 2022, 3, 4, '202 Cedar Ln, Seattle, WA', '+1-555-0105'),
('Sarah Miller', 2019, 2023, 3, NULL, '303 Birch Blvd, Denver, CO', '+1-555-0106'),
('Daniel Garcia', 2017, 2021, 4, 5, '404 Spruce Way, Miami, FL', '+1-555-0107'),
('Laura Martinez', 2018, 2022, 4, 2, '505 Elm St, Portland, OR', '+1-555-0108'),
('Robert Anderson', 2016, 2020, 1, 3, '606 Willow Ct, Phoenix, AZ', '+1-555-0109'),
('Maria Thomas', 2019, 2023, 2, 4, '707 Ash Dr, Las Vegas, NV', '+1-555-0110');

-- Centralized Testing (CT) results – several subjects per graduate
INSERT INTO CentralizedTest (graduate_id, subject_name, score, teacher) VALUES
(1, 'Mathematics', 92, 'Dr. Adams'),
(1, 'English', 88, 'Prof. Lee'),
(1, 'Physics', 95, 'Dr. White'),
(2, 'Mathematics', 85, 'Dr. Adams'),
(2, 'Computer Science', 91, 'Prof. Chen'),
(3, 'Physics', 78, 'Dr. White'),
(3, 'Mathematics', 82, 'Dr. Adams'),
(4, 'English', 94, 'Prof. Lee'),
(4, 'Business Studies', 89, 'Prof. Taylor'),
(5, 'History', 76, 'Dr. Brown'),
(5, 'Literature', 84, 'Prof. Lee'),
(6, 'Mathematics', 88, 'Dr. Adams'),
(6, 'Physics', 72, 'Dr. White'),
(7, 'Economics', 96, 'Prof. Taylor'),
(7, 'English', 90, 'Prof. Lee'),
(8, 'Computer Science', 93, 'Prof. Chen'),
(8, 'Mathematics', 87, 'Dr. Adams'),
(9, 'Physics', 81, 'Dr. White'),
(9, 'English', 79, 'Prof. Lee'),
(10, 'Mathematics', 94, 'Dr. Adams'),
(10, 'Business Studies', 88, 'Prof. Taylor');

-- ======================================================
-- EXAMPLE QUERIES (as required by the assignment)
-- ======================================================

-- Query 1: List all graduates with their institution and employment details
SELECT 
    g.full_name AS 'Graduate Name',
    g.year_of_graduation AS 'Graduation Year',
    ei.name AS 'Institution',
    e.name AS 'Employer',
    e.position AS 'Position'
FROM Graduate g
LEFT JOIN EducationalInstitution ei ON g.institution_id = ei.institution_id
LEFT JOIN Employment e ON g.organization_id = e.organization_id
ORDER BY g.year_of_graduation DESC;

-- Query 2: Average CT score per graduate (only those with at least one test)
SELECT 
    g.full_name AS 'Graduate Name',
    ROUND(AVG(ct.score), 2) AS 'Average CT Score'
FROM Graduate g
JOIN CentralizedTest ct ON g.graduate_id = ct.graduate_id
GROUP BY g.graduate_id
ORDER BY AVG(ct.score) DESC;

-- Query 3: Graduates who have an average CT score above 85
SELECT 
    g.full_name AS 'Graduate Name',
    ROUND(AVG(ct.score), 2) AS 'Average Score'
FROM Graduate g
JOIN CentralizedTest ct ON g.graduate_id = ct.graduate_id
GROUP BY g.graduate_id
HAVING AVG(ct.score) > 85
ORDER BY AVG(ct.score) DESC;

-- Query 4: Number of graduates per educational institution
SELECT 
    ei.name AS 'Institution',
    COUNT(g.graduate_id) AS 'Number of Graduates'
FROM EducationalInstitution ei
LEFT JOIN Graduate g ON ei.institution_id = g.institution_id
GROUP BY ei.institution_id
ORDER BY COUNT(g.graduate_id) DESC;

-- Query 5: All CT records with graduate name and subject (detailed view)
SELECT 
    g.full_name AS 'Graduate',
    ct.subject_name AS 'Subject',
    ct.score AS 'Score',
    ct.teacher AS 'Teacher'
FROM CentralizedTest ct
JOIN Graduate g ON ct.graduate_id = g.graduate_id
ORDER BY g.full_name, ct.score DESC;

-- Query 6: Graduates who are currently employed (organization_id not null)
SELECT 
    full_name AS 'Graduate Name',
    phone AS 'Phone',
    address AS 'Address'
FROM Graduate
WHERE organization_id IS NOT NULL;

-- ======================================================
-- End of script
-- ======================================================