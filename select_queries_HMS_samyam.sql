Use hospital_management;


-- -----------------------a. SELECT Queries ------------------------
-- i. Simple SELECT: Retrieve all records from the Patient table
SELECT * FROM Patient;

-- ii. ORDER BY: List all doctors sorted alphabetically by specialization
SELECT * FROM Doctor ORDER BY specialization;

-- iii. DISTINCT: Get unique payment methods from all bills
SELECT DISTINCT payment_method FROM Bill;

-- iv. AND/OR: Demonstrates use of AND and OR clause in filtering multiple conditions
-- Patients who are female OR whose address contains "St"
SELECT * FROM Patient 
WHERE gender = 'F' OR address LIKE '%St%';

-- Patients who are female AND whose address contains "vd"
SELECT * FROM Patient 
WHERE gender = 'F' AND address LIKE '%vd%';


-- v. IN: Find appointments with doctors having ID 101 or 102
SELECT * FROM Appointment 
WHERE doctor_id IN (101, 102);

-- vi. LIKE: Find patients whose last names start with the letter 'G'
SELECT * FROM Patient 
WHERE last_name LIKE 'K%';



-- -------------b. Aggregate Functions-------------------------------
-- i. Aggregates: Count total bills, calculate average and max billing amount. (3 aggregate in 1 query)
SELECT 
    COUNT(*) AS total_bills, 
    AVG(amount) AS avg_amount, 
    MAX(amount) AS max_amount 
FROM Bill;


-- -------------------------------c. Joins----------------------------
-- i. INNER JOIN BETWEEN 2 tables: Display appointment info along with doctor and patient names
SELECT 
    a.appointment_id, 
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name, 
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    a.appointment_date
FROM Appointment a
INNER JOIN Doctor d ON a.doctor_id = d.doctor_id
INNER JOIN Patient p ON a.patient_id = p.patient_id;

-- ii. LEFT OUTER JOIN: Show all patients and their insurance provider (if any)
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name, 
    i.provider
FROM Patient p
LEFT JOIN Insurance i ON p.patient_id = i.patient_id;

-- iii. SELF JOIN: Pair up doctors with the same specialization
SELECT 
    CONCAT(d1.first_name, ' ', d1.last_name) AS doctor1_name, 
    CONCAT(d2.first_name, ' ', d2.last_name) AS doctor2_name, 
    d1.specialization
FROM Doctor d1
JOIN Doctor d2 ON d1.specialization = d2.specialization 
    AND d1.doctor_id < d2.doctor_id;


-- -----------------------d. GROUP BY-----------------------------------
-- i. GROUP BY without HAVING: Count of appointments per doctor (with doctor name)
SELECT 
    d.doctor_id, 
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    COUNT(a.appointment_id) AS total_appointments
FROM Doctor d
JOIN Appointment a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id;

-- 12. GROUP BY with HAVING: Doctors with more than 1 appointment (with name)
SELECT 
    d.doctor_id, 
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    COUNT(a.appointment_id) AS total_appointments
FROM Doctor d
JOIN Appointment a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id
HAVING COUNT(a.appointment_id) > 1;