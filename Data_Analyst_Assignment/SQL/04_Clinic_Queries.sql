-- Clinic System Queries (Part B)

-- Q1: Revenue by Channel
SELECT sales_channel, SUM(amount) AS total_revenue
FROM clinic_sales
GROUP BY sales_channel;

-- Q2: Assuming similar to hotel, perhaps top channels or something, but not specified.

-- Q3: Profit/Loss by month
WITH monthly_revenue AS (
    SELECT MONTH(date) AS month, YEAR(date) AS year, SUM(amount) AS revenue
    FROM clinic_sales
    GROUP BY year, month
),
monthly_expenses AS (
    SELECT MONTH(date) AS month, YEAR(date) AS year, SUM(amount) AS expenses
    FROM expenses
    GROUP BY year, month
)
SELECT r.month, r.year, (r.revenue - e.expenses) AS profit_loss
FROM monthly_revenue r
LEFT JOIN monthly_expenses e ON r.month = e.month AND r.year = e.year;

-- Other questions not detailed in reference.