-- Clinic Management System Schema Setup

CREATE TABLE clinic_sales (
    sales_id INT PRIMARY KEY,
    sales_channel VARCHAR(50),
    amount DECIMAL(10,2),
    date DATE
);

CREATE TABLE expenses (
    expense_id INT PRIMARY KEY,
    category VARCHAR(50),
    amount DECIMAL(10,2),
    date DATE
);

-- =========================
-- INSERT SAMPLE DATA
-- =========================

-- Clinic Sales
INSERT INTO clinic_sales VALUES
(1, 'Online', 1000.00, '2021-11-01'),
(2, 'Offline', 1500.00, '2021-11-02'),
(3, 'Online', 2000.00, '2021-11-10'),
(4, 'Offline', 1200.00, '2021-11-15');

-- Expenses
INSERT INTO expenses VALUES
(1, 'Rent', 800.00, '2021-11-01'),
(2, 'Salary', 1200.00, '2021-11-02'),
(3, 'Utilities', 500.00, '2021-11-10'),
(4, 'Maintenance', 300.00, '2021-11-15');