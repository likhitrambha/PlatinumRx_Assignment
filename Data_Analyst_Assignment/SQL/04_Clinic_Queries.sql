-- Clinic System Queries (Part B)

-- Q1: Revenue by Channel (for a given year)
SELECT 
    sales_channel, 
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE YEAR(date) = 2021
GROUP BY sales_channel;


-- Q2: Top 10 most valuable customers
-- (No customer table → treating each sale as customer placeholder)
SELECT 
    sales_id AS customer_id,
    amount AS total_spent
FROM clinic_sales
WHERE YEAR(date) = 2021
ORDER BY total_spent DESC
LIMIT 10;


-- Q3: Month-wise revenue, expense, profit, status

SELECT 
    r.month,
    r.revenue,
    IFNULL(e.expenses, 0) AS expenses,
    (r.revenue - IFNULL(e.expenses, 0)) AS profit,
    CASE 
        WHEN (r.revenue - IFNULL(e.expenses, 0)) > 0 THEN 'Profitable'
        ELSE 'Not Profitable'
    END AS status
FROM 
(
    SELECT 
        MONTH(date) AS month,
        SUM(amount) AS revenue
    FROM clinic_sales
    WHERE YEAR(date) = 2021
    GROUP BY MONTH(date)
) r
LEFT JOIN 
(
    SELECT 
        MONTH(date) AS month,
        SUM(amount) AS expenses
    FROM expenses
    WHERE YEAR(date) = 2021
    GROUP BY MONTH(date)
) e
ON r.month = e.month;


-- Q4: Most profitable clinic (simulated since no clinic table)
-- Using total profit per day as "clinic"

SELECT 
    t1.month,
    t1.day,
    t1.profit
FROM 
(
    SELECT 
        MONTH(cs.date) AS month,
        DAY(cs.date) AS day,
        SUM(cs.amount) - IFNULL(SUM(e.amount), 0) AS profit
    FROM clinic_sales cs
    LEFT JOIN expenses e 
        ON cs.date = e.date
    GROUP BY MONTH(cs.date), DAY(cs.date)
) t1
WHERE t1.profit = (
    SELECT MAX(t2.profit)
    FROM (
        SELECT 
            MONTH(cs.date) AS month,
            DAY(cs.date) AS day,
            SUM(cs.amount) - IFNULL(SUM(e.amount), 0) AS profit
        FROM clinic_sales cs
        LEFT JOIN expenses e 
            ON cs.date = e.date
        GROUP BY MONTH(cs.date), DAY(cs.date)
    ) t2
    WHERE t2.month = t1.month
);


-- Q5: Second least profitable (simulated)

SELECT 
    t1.month,
    t1.day,
    t1.profit
FROM 
(
    SELECT 
        MONTH(cs.date) AS month,
        DAY(cs.date) AS day,
        SUM(cs.amount) - IFNULL(SUM(e.amount), 0) AS profit
    FROM clinic_sales cs
    LEFT JOIN expenses e 
        ON cs.date = e.date
    GROUP BY MONTH(cs.date), DAY(cs.date)
) t1
WHERE 1 = (
    SELECT COUNT(DISTINCT t2.profit)
    FROM (
        SELECT 
            MONTH(cs.date) AS month,
            DAY(cs.date) AS day,
            SUM(cs.amount) - IFNULL(SUM(e.amount), 0) AS profit
        FROM clinic_sales cs
        LEFT JOIN expenses e 
            ON cs.date = e.date
        GROUP BY MONTH(cs.date), DAY(cs.date)
    ) t2
    WHERE t2.month = t1.month
    AND t2.profit < t1.profit
);