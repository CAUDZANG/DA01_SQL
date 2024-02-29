---ex 1
select name from students
where marks > 75
order by RIGHT (name,3),id
---ex 2
select user_id,
concat(upper(left(name,1)),lower(right(name,length(name)-1))) as name
from users
---ex 3
SELECT manufacturer,
concat('$',round(sum (total_sales)/1000000),' ', 'million') as sale
FROM pharmacy_sales
group by manufacturer
order by sum (total_sales) desc , manufacturer
---ex 4
SELECT 
extract (month from submit_date) as mth,
product_id ,
round(AVG(stars),2) as avg_stars
FROM reviews
group by product_id, extract (month from submit_date)
ORDER BY mth, product_id
---ex 5
SELECT sender_id,
count(message_id) as message_count
FROM messages
WHERE
extract (month from sent_date) = '8'AND
extract (year from sent_date) = '2022'
GROUP BY sender_id ,message_count
order by message_count desc 
limit 2
---ex 6
select 
tweet_id
from Tweets
where length(content) >15
---ex 7
select activity_date as day,
count(distinct user_id) as active_users
from activity 
where (activity_date > '2019-06-27' and activity_date <='2019-07-27')
group by day
---ex 8
select 
count (distinct id) as number_employees
from employees
where (joining_date > '2022-01-01'and joining_date>= '2020-07-31')
---ex 9
select position ('a' from first_name) as position
from worker
where first_name ='Amitah'
---ex 10
select 
substring (title, length(winery)+2,4)
from winemag_p2
where country  =  'Macedonia'












