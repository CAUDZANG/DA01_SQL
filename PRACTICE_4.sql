---ex 1
SELECT 
SUM(CASE WHEN device_type = 'laptop' THEN 1 ELSE 0 END) AS laptop_views, 
SUM(CASE WHEN device_type IN ('tablet', 'phone') THEN 1 ELSE 0 END) AS mobile_views 
FROM viewership;
--ex 2
SELECT x,y,z,
case WHEN (x+y) > z AND (x+z) > y AND (y+z) > x THEN 'Yes' ELSE 'No' end AS triangle
FROM Triangle
---ex 3

---ex 4 
select name from customer
where referee_id != 2
or referee_id is null
---ex 5
SELECT survived,
COUNT(passengerid) FILTER(WHERE pclass = 1) AS first_class,
COUNT(passengerid) FILTER(WHERE pclass = 2) AS second_class,
COUNT(passengerid) FILTER(WHERE pclass = 3) AS third_class
FROM titanic
GROUP BY survived
