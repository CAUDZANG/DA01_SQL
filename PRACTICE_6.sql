--ex 1
SELECT 
COUNT(*) AS duplicate_companies 
FROM (SELECT company_id,title,description FROM job_listings
GROUP BY  company_id,title,description 
HAVING COUNT(job_id)>1) as A
--ex 2
SELECT category, product, total_spend 
FROM (SELECT category, product, 
SUM(spend) AS total_spend,
RANK() OVER (PARTITION BY category 
ORDER BY SUM(spend) DESC) AS ranking 
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY category, product) AS ranked_spending
WHERE ranking <= 2 
ORDER BY category, ranking; 
--ex 3
WITH call_records AS (
SELECT policy_holder_id,
COUNT(case_id) AS call_count
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id) >= 3)
SELECT COUNT(policy_holder_id) AS member_count
FROM call_records
--ex 4
SELECT pages.page_id 
FROM pages LEFT JOIN page_likes 
ON pages.page_id=page_likes.page_id
where page_likes.page_id is NULL
--ex 5
SELECT 
EXTRACT(MONTH FROM curr_month.event_date) AS mth, 
COUNT(DISTINCT curr_month.user_id) AS monthly_active_users 
FROM user_actions AS curr_month
WHERE EXISTS (SELECT last_month.user_id 
FROM user_actions AS last_month
WHERE last_month.user_id = curr_month.user_id
AND EXTRACT(MONTH FROM last_month.event_date) =
EXTRACT(MONTH FROM curr_month.event_date - interval '1 month'))
AND EXTRACT(MONTH FROM curr_month.event_date) = 7
AND EXTRACT(YEAR FROM curr_month.event_date) = 2022
GROUP BY EXTRACT(MONTH FROM curr_month.event_date)
--ex 6
SELECT DATE_FORMAT(trans_date, '%Y-%m') AS month, country, 
COUNT(id) AS trans_count, 
SUM(state = 'approved') AS approved_count, 
SUM(amount) AS trans_total_amount, 
SUM(IF(state = 'approved', amount, 0)) AS approved_total_amount 
FROM Transactions 
GROUP BY month, country
--ex 7
SELECT product_id, year first_year,quantity,price
FROM Sales
WHERE (product_id, year) 
IN (SELECT product_id, MIN(year) first_year
FROM Sales GROUP BY product_id)
--ex 8
SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(*) FROM Product)
--ex 9
SELECT employee_id 
FROM Employees 
WHERE salary < 30000 AND manager_id NOT IN 
(SELECT employee_id FROM Employees) 
ORDER BY employee_id
--ex 10
SELECT 
COUNT(*) AS duplicate_companies 
FROM (SELECT company_id,title,description FROM job_listings
GROUP BY  company_id,title,description 
HAVING COUNT(job_id)>1) as A
--ex 11
(SELECT name as results FROM users as u
JOIN movierating m ON u.user_id = m.user_id
GROUP BY m.user_id
ORDER BY COUNT(rating) DESC,name
LIMIT 1)
union all
(select title as results FROM movies as mo
JOIN movierating m using(movie_id) where month(created_at)="02" and year(created_at)="2020"
group by title order by avg(rating) desc,title limit 1)
--ex 12
SELECT id, COUNT(*) AS num 
FROM (SELECT requester_id AS id 
FROM RequestAccepted 
UNION ALL 
SELECT accepter_id 
FROM RequestAccepted ) AS friend_request 
GROUP BY id 
ORDER BY num DESC 
LIMIT 1

















