-- Hotel System Queries (Part A)

-- Q1: Last booked room per user
SELECT b.user_id, b.room_id
FROM bookings b
JOIN (
    SELECT user_id, MAX(check_out_date) AS last_date
    FROM bookings
    GROUP BY user_id
) t
ON b.user_id = t.user_id 
AND b.check_out_date = t.last_date;

-- Q2: Billing in Nov 2021
SELECT b.booking_id, SUM(bc.quantity * bc.rate) AS total_amount
FROM bookings b
JOIN booking_commercials bc ON b.booking_id = bc.booking_id
WHERE MONTH(b.check_in_date) = 11 AND YEAR(b.check_in_date) = 2021
GROUP BY b.booking_id;

-- Q3: Bills > 1000
SELECT b.booking_id, SUM(bc.quantity * bc.rate) AS total_amount
FROM bookings b
JOIN booking_commercials bc ON b.booking_id = bc.booking_id
GROUP BY b.booking_id
HAVING total_amount > 1000;

-- Q4: Most/Least ordered items per month
-- Assuming we have a date column, say in booking_commercials or bookings
-- This requires window functions
WITH monthly_orders AS (
    SELECT MONTH(b.check_in_date) AS month, i.name, SUM(bc.quantity) AS total_qty
    FROM bookings b
    JOIN booking_commercials bc ON b.booking_id = bc.booking_id
    JOIN items i ON bc.item_id = i.item_id
    GROUP BY month, i.name
),
ranked AS (
    SELECT month, name, total_qty,
           RANK() OVER (PARTITION BY month ORDER BY total_qty DESC) AS rnk_desc,
           RANK() OVER (PARTITION BY month ORDER BY total_qty ASC) AS rnk_asc
    FROM monthly_orders
)
SELECT month, 
       MAX(CASE WHEN rnk_desc = 1 THEN name END) AS most_ordered,
       MAX(CASE WHEN rnk_asc = 1 THEN name END) AS least_ordered
FROM ranked
GROUP BY month;

-- Q5: 2nd highest bill per month
WITH monthly_bills AS (
    SELECT 
        MONTH(b.check_in_date) AS month,
        b.booking_id,
        SUM(bc.quantity * bc.rate) AS total_amount
    FROM bookings b
    JOIN booking_commercials bc 
        ON b.booking_id = bc.booking_id
    GROUP BY month, b.booking_id
),
ranked AS (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY month ORDER BY total_amount DESC) AS rnk
    FROM monthly_bills
)
SELECT month, booking_id, total_amount
FROM ranked
WHERE rnk = 2;