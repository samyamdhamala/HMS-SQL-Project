-------------- CREATE THE DATABASE ---------------------------
CREATE DATABASE IF NOT EXISTS hospital_management;
USE hospital_management;

-- Create the Patient table
CREATE TABLE Patient (
    patient_id INT PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    middle_name VARCHAR(30),
    last_name VARCHAR(30) NOT NULL,
    gender ENUM('M', 'F', 'Other') NOT NULL,
    date_of_birth DATE NOT NULL,
    contact_number VARCHAR(15) NOT NULL,
    address VARCHAR(100) NOT NULL
);

-- Create the Doctor table
CREATE TABLE Doctor (
    doctor_id INT PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    middle_name VARCHAR(30),
    last_name VARCHAR(30) NOT NULL,
    specialization VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) NOT NULL
);

-- Create the Appointment table
CREATE TABLE Appointment (
    appointment_id INT PRIMARY KEY,
    doctor_id INT NOT NULL,
    patient_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    purpose VARCHAR(100) NOT NULL,
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);

-- Create the Bill table
CREATE TABLE Bill (
    bill_id INT PRIMARY KEY,
    appointment_id INT NOT NULL,
    amount DECIMAL(8, 2) NOT NULL,
    billing_date DATE NOT NULL,
    payment_status ENUM('Paid', 'Unpaid', 'Pending') NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
);

-- Create the Insurance table
CREATE TABLE Insurance (
    insurance_id INT PRIMARY KEY,
    patient_id INT UNIQUE NOT NULL,
    provider VARCHAR(50) NOT NULL,
    policy_number VARCHAR(30) NOT NULL,
    expiry_date DATE NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);

-- Create the doctor_patient junction table
CREATE TABLE doctor_patient (
    doctor_id INT NOT NULL,
    patient_id INT NOT NULL,
    PRIMARY KEY (doctor_id, patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);

SHOW TABLES;

-- ----------------------INSERT INTO TABLES ----------------------------------------
-- Insert into Patient
INSERT INTO Patient VALUES
(1, 'Meredith', 'R.', 'Grey', 'F', '1983-09-27', '5551234567', '1515 Seattle Grace Blvd'),
(2, 'Cristina', NULL, 'Yang', 'F', '1981-03-20', '5559876543', '1400 Harper Avery St'),
(3, 'Alex', 'M.', 'Karev', 'M', '1982-02-15', '5553216789', '1001 Joe’s Bar Ln'),
(4, 'Izzie', NULL, 'Stevens', 'F', '1984-07-14', '5554561230', '1620 Emerald City Ave'),
(5, 'George', 'O.', 'O\'Malley', 'M', '1985-02-14', '5555551234', '221B Lee St'),
(6, 'Callie', NULL, 'Torres', 'F', '1980-12-01', '5554441234', '67 Ortho Lane Blvd');

select* from patient;

-- Insert into Doctor
INSERT INTO Doctor VALUES 
(101, 'Derek', 'C.', 'Shepherd', 'Neurosurgery', '5551010101'),
(102, 'Miranda', NULL, 'Bailey', 'General Surgery', '5552020202'),
(103, 'Richard', 'W.', 'Webber', 'Internal Medicine', '5553030303'),
(104, 'Arizona', NULL, 'Robbins', 'Pediatric Surgery', '5554040404'),
(105, 'Owen', NULL, 'Hunt', 'Trauma Surgery', '5555050505'),
(106, 'Teddy', 'A.', 'Altman', 'Cardiothoracic Surgery', '5556060606'),
(107, 'Amelia', 'F.', 'Shepherd', 'Neurosurgery', '5557070707');

select* from doctor;

-- Insert into Appointment
INSERT INTO Appointment VALUES 
(1001, 101, 1, '2024-04-01', 'Neuro Follow-up'),
(1002, 102, 2, '2024-04-03', 'General Consultation'),
(1003, 103, 3, '2024-04-05', 'Routine Checkup'),
(1004, 104, 4, '2024-04-07', 'Pediatric Ortho'),
(1005, 105, 5, '2024-04-10', 'Trauma Evaluation'),
(1006, 106, 6, '2024-04-12', 'Heart Follow-up'),
(1007, 101, 2, '2024-04-15', 'Post-surgery Checkup'),
(1008, 101, 3, '2024-04-18', 'Neuro Follow-up Review'),
(1009, 102, 4, '2024-04-20', 'General Checkup');

-- Insert into bill
INSERT INTO Bill VALUES 
(201, 1001, 1200.00, '2024-04-01', 'Paid', 'Credit Card'),
(202, 1002, 750.00, '2024-04-03', 'Unpaid', 'Cash'),
(203, 1003, 900.00, '2024-04-05', 'Paid', 'Insurance'),
(204, 1004, 1100.00, '2024-04-07', 'Pending', 'Debit Card'),
(205, 1005, 1300.00, '2024-04-10', 'Paid', 'Credit Card'),
(206, 1006, 1400.00, '2024-04-12', 'Unpaid', 'Cash');


-- Insert into Insurance
INSERT INTO Insurance VALUES 
(301, 1, 'Seattle Health', 'SH-99345', '2025-12-31'),
(302, 2, 'Grey Sloan Care', 'GS-23856', '2026-06-30'),
(303, 3, 'Karev Insurance', 'KI-88888', '2024-10-15'),
(304, 4, 'Emerald Shield', 'ES-66442', '2025-08-20'),
(305, 5, 'OrthoCare', 'OC-55231', '2026-11-15'),
(306, 6, 'HeartSecure', 'HS-11221', '2025-07-01');


-- Insert into doctor_patient
INSERT INTO doctor_patient VALUES 
(101, 1), -- Derek treats Meredith
(102, 2), -- Bailey treats Cristina
(103, 3), -- Webber treats Alex
(104, 4), -- Robbins treats Izzie
(102, 1), -- Bailey also treats Meredith
(105, 5), -- Owen treats George
(106, 6); -- Teddy treats Callie

SELECT * FROM Patient;
SELECT * FROM Doctor;
SELECT * FROM Appointment;
SELECT * FROM Bill;
SELECT * FROM Insurance;
SELECT * FROM doctor_patient;


-- -----------------VIEWS-----------------------------

-- View 1: appointment_summary
-- Objective: Displays all appointments along with corresponding doctor and patient names, 
-- including date and purpose to simplify reporting on who met whom and when.

CREATE VIEW appointment_summary AS
SELECT 
    a.appointment_id,
    a.appointment_date,
    a.purpose,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name
FROM Appointment a
JOIN Doctor d ON a.doctor_id = d.doctor_id
JOIN Patient p ON a.patient_id = p.patient_id;

Select * from appointment_summary;

-- -----------------------------------------------------------------------------------------
-- View 2: paid_bills_view
-- Objective: Shows only the paid bills along with patient names and payment methods, for financial reports and verifying completed transactions.

CREATE VIEW paid_bills_view AS
SELECT 
    b.bill_id,
    b.amount,
    b.billing_date,
    b.payment_method,
    CONCAT(p.first_name, ' ', p.middle_name, ' ', p.last_name) AS patient_name
FROM Bill b
JOIN Appointment a ON b.appointment_id = a.appointment_id
JOIN Patient p ON a.patient_id = p.patient_id
WHERE b.payment_status = 'Paid';

Select * from paid_bills_view;

-- -----------------------------------------------------------------------------------------
-- View 3: case_overview
-- Objective: Lists doctor-patient assignments with additional demographic and specialization details to help understand treatment coverage and doctor work-load.

CREATE VIEW case_overview AS
SELECT 
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    d.specialization,
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    p.gender,
    p.date_of_birth
FROM doctor_patient dp
JOIN Doctor d ON dp.doctor_id = d.doctor_id
JOIN Patient p ON dp.patient_id = p.patient_id;


Select * from case_overview;


-- ------------------TRIGGERS ------------------------

-- Trigger 1: Log new bill entries

-- Helper Table to store bill insert logs
CREATE TABLE bill_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    bill_id INT,
    amount DECIMAL(8,2),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trigger to log any newly inserted bill into bill_log
DELIMITER //

CREATE TRIGGER log_bill_after_insert
AFTER INSERT ON Bill
FOR EACH ROW
BEGIN
    -- Insert bill ID and amount into log table after a new bill is added
    INSERT INTO bill_log (bill_id, amount)
    VALUES (NEW.bill_id, NEW.amount);
END;
//

DELIMITER ;

-- Test Example:
-- INSERT INTO Bill VALUES (207, 1001, 999.00, '2024-04-20', 'Paid', 'Credit Card');
-- SELECT * FROM bill_log;


-- -----------------------------------------------------------------------------------------
-- Trigger 2: Trigger to prevent inserting insurance with expiry_date before today's date
DELIMITER //

CREATE TRIGGER check_insurance_expiry
BEFORE INSERT ON Insurance
FOR EACH ROW
BEGIN
    -- If expiry date is in the past, block the insert with an error message
    IF NEW.expiry_date < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot insert expired insurance policy.';
    END IF;
END;
//

DELIMITER ;

-- Test Example:
-- This will throw an error:
-- INSERT INTO Insurance VALUES (307, 1, 'TestCare', 'TC-123', '2020-01-01');

-- -----------------------------------------------------------------------------------------
-- Trigger 3: Track appointment rescheduling

-- Helper Table to track rescheduled appointments
CREATE TABLE appointment_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    old_date DATE,
    new_date DATE,
    change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trigger to log appointment date changes into history table
DELIMITER //

CREATE TRIGGER track_appointment_reschedule
BEFORE UPDATE ON Appointment
FOR EACH ROW
BEGIN
    -- Only log if the date is actually being changed
    IF OLD.appointment_date <> NEW.appointment_date THEN
        INSERT INTO appointment_history (appointment_id, old_date, new_date)
        VALUES (OLD.appointment_id, OLD.appointment_date, NEW.appointment_date);
    END IF;
END;
//

DELIMITER ;

-- Test Example:
-- UPDATE Appointment SET appointment_date = '2024-04-25' WHERE appointment_id = 1001;
-- SELECT * FROM appointment_history;
