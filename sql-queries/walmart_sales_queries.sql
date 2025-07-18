USE walmart_db;
SELECT * FROM walmart;
SELECT MAX(quantity) from walmart;

-- BUsiness problems
-- Q1) Find the differet payment method and number of transactions, number of quantity sold
select payment_method, count(*) as no_payments, sum(quantity) as no_qty_sold
from walmart
group by payment_method;

-- Q2) Identify the highest rated ctaegory in each branch, displaying the branch, category avg rating
SELECT branch, category, avg_rating, ranking
FROM (
    SELECT 
        branch, 
        category, 
        avg_rating,
        RANK() OVER (PARTITION BY branch ORDER BY avg_rating DESC) AS ranking
    FROM (
        SELECT 
            branch, 
            category, 
            AVG(rating) AS avg_rating
        FROM walmart
        GROUP BY branch, category
    ) AS agg
) AS ranked
WHERE ranking = 1;

-- Q3) Identify the busiest day for each branch based on the number of transactions
SELECT branch, day_name, no_transactions, branch_rank
FROM (
    SELECT 
        branch, 
        day_name,
        no_transactions,
        RANK() OVER (PARTITION BY branch ORDER BY no_transactions DESC) AS branch_rank
    FROM (
        SELECT 
            branch, 
            DAYNAME(STR_TO_DATE(date,'%d/%m/%y')) AS day_name,
            COUNT(*) AS no_transactions
        FROM walmart
        GROUP BY branch, day_name
    ) AS counted
) AS ranked
WHERE branch_rank = 1;


-- Q4) Calculate the total quantity of items sold per payment method. list payment_method and total_quantity.
select payment_method, sum(quantity) as no_qty_sold
from walmart
group by payment_method;


-- Q5) determine the average, minimum, and maximum rating of category for each city. list the city, average_rating, min_rating, and max_rating
select city, category, MIN(rating) as min_rating, max(rating) as max_rating, avg(rating) as avg_rating
from walmart
group by city, category;


-- Q6) calculate the total profit for each category by considering total_profit as (unit_price*quantity*profit_margin). list category and total_profit, ordered from highest to lowest profit.
select category, sum(total) as total_revenue, sum(total* profit_margin) as profit
from walmart
group by category;


-- Q7) determine the most common payment method for each branch. display branch and prefereed_payment_method
with cte
as
(SELECT branch, payment_method, total_trans, branch_rank
FROM (
    SELECT
        branch,
        payment_method,
        total_trans,
        RANK() OVER (PARTITION BY branch ORDER BY total_trans DESC) AS branch_rank
    FROM (
        SELECT
            branch,
            payment_method,
            COUNT(*) AS total_trans
        FROM walmart
        GROUP BY branch, payment_method
    ) AS agg
) AS ranked
)
select * from cte
WHERE branch_rank = 1;


-- Q8) categorize  sales into 3 groups morning, afternoon, evening. find out each of the shift and number of invoices
SELECT branch,
  CASE
    WHEN HOUR(CAST(`time` AS TIME)) < 12 THEN 'Morning'
    WHEN HOUR(CAST(`time` AS TIME)) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
  END AS day_time,
  COUNT(*) AS num_invoices
FROM walmart
GROUP BY branch, day_time
ORDER BY FIELD(day_time, 'Morning', 'Afternoon', 'Evening');


-- Q9) identify 5 branch with highest decrease ration in revenue compared to last year(2022)
-- rdr==last_rev-cr_rev/ls_rev*100
-- 2022 sales
WITH revenue_2022 AS (
    SELECT branch, SUM(total) AS revenue_2022
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%y')) = 2022
    GROUP BY branch
),
revenue_2023 AS (
    SELECT branch, SUM(total) AS revenue_2023
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%y')) = 2023
    GROUP BY branch
)
SELECT 
    ls.branch, 
    ls.revenue_2022 AS last_year_revenue, 
    cs.revenue_2023 AS current_year_revenue,
    ROUND((ls.revenue_2022 - cs.revenue_2023) / ls.revenue_2022 * 100, 2) AS percent_drop
FROM revenue_2022 AS ls
JOIN revenue_2023 AS cs ON ls.branch = cs.branch
WHERE ls.revenue_2022 > cs.revenue_2023;


