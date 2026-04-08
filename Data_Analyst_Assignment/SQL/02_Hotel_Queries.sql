-- Hotel System Queries (Part A)

-- Q1: Last booked room
SELECT room_id, check_out_date
FROM bookings
ORDER BY check_out_date DESC
LIMIT 1;

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

-- Q5: 2nd Highest Bill
WITH bill_totals AS (
    SELECT b.booking_id, SUM(bc.quantity * bc.rate) AS total_amount
    FROM bookings b
    JOIN booking_commercials bc ON b.booking_id = bc.booking_id
    GROUP BY b.booking_id
)
SELECT booking_id, total_amount
FROM bill_totals
ORDER BY total_amount DESC
LIMIT 1 OFFSET 1;