---ex 1
select distinct city from station
where id % 2 = 0
---ex 2
select (count(city) - count(distinct city)) from station;
---ex 3
select round(avg(salary)) - round(avg(replace(salary,0,''))) from employees
---ex 4
SELECT
ROUND(cast(sum(item_count*order_occurrences)/sum(order_occurrences)as decimal) ,1)as mean
FROM items_per_order;
---ex 5
SELECT candidate_id
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill) = 3
ORDER BY candidate_id;
---ex 6
SELECT user_id, 
DATE(MAX(post_date))-DATE(MIN(post_date)) as days_between
FROM posts
where post_date BETWEEN('2021-01-01')and ('2021-12-31')
GROUP BY user_id
HAVING count (post_date)>=2
---ex 7
SELECT card_name,
MAX(issued_amount)-MIN(issued_amount) as difference
FROM monthly_cards_issued
group by card_name
order by difference desc
---ex 8
SELECT manufacturer,
COUNT (drug) as drug_count,
ABS(SUM(cogs-total_sales)) as total_loss
FROM pharmacy_sales
where total_sales<cogs
GROUP BY manufacturer
ORDER BY total_loss desc
---ex 9
select * from Cinema
where id%2=1 and description <> 'boring'
order by rating desc
---ex 10
select teacher_id,
count(distinct subject_id) as cnt
from teacher
group by teacher_id
---ex 11
select user_id, 
count(follower_id) as followers_count from followers
group by user_id
order by user_id
---ex 12
SELECT class
FROM Courses
GROUP BY class
HAVING COUNT(student) >= 5;


























