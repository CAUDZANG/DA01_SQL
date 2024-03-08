--ex 1
SELECT COUNTRY.CONTINENT, FLOOR(AVG(CITY.POPULATION))
FROM CITY
INNER JOIN COUNTRY 
ON CITY.COUNTRYCODE = COUNTRY.CODE
GROUP BY COUNTRY.CONTINENT;
--ex 2
SELECT 
ROUND(AVG(CASE WHEN signup_action = 'Confirmed' THEN 1 ELSE 0 END), 2) AS confirm_rate
FROM texts
LEFT JOIN emails
USING (email_id)
--ex 3
SELECT age_bucket,
ROUND( 100*( sum(case when activity_type = 'send' then time_spent end) / sum(case when activity_type in ('send', 'open') then time_spent end) ),2) as send_perc,
ROUND( 100*( sum(case when activity_type = 'open' then time_spent end) / sum(case when activity_type in ('send', 'open') then time_spent end) ),2) as open_perc
FROM activities a inner join age_breakdown b on a.user_id=b.user_id
group by age_bucket 
--ex 4
SELECT customer_id
FROM customer_contracts cc
join products pr 
using(product_id)
group by 1
HAVING COUNT(DISTINCT product_category) =3
--ex 5
SELECT E1.employee_id, E1.name, COUNT(E2.reports_to) AS reports_count, ROUND(AVG(E2.age),0) AS average_age
FROM Employees as E1 
INNER JOIN Employees as E2 
ON E1.employee_id = E2.reports_to
GROUP BY E2.reports_to
ORDER BY E1.employee_id;
--ex 6
select p.product_name, sum(o.unit) unit
from products as p
join orders as o
on p.product_id = o.product_id
where month(order_date) = 2 and year(order_date) =2020
group by p.product_id
having unit >=100 
--ex 7
SELECT pages.page_id 
FROM pages LEFT JOIN page_likes 
ON pages.page_id=page_likes.page_id
where page_likes.page_id is NULL
---MID-COURSE TEST
--ex 1
select 
min (distinct(replacement_cost))
from film
--ex 2
select 
case 
when replacement_cost between 9.99 and 19.99 then 'low'
when replacement_cost between 20.00 and 24.99 then 'medium'
else 'high'
end category,
count (*) as number_of_movie
from film
group by category
--ex 3
select a.title, a.length, c.name
from film as a
join public.film_category as b on a.film_id = b.film_id
join public.category as c on b.category_id = c.category_id
where (c.name= 'Sports' or c.name= 'Drama')
order by length desc
--ex 4
select c.name,
count (title) as so_luong from film as a
join public.film_category as b on a.film_id = b.film_id
join public.category as c on b.category_id = c.category_id
group by c.name
order by count (title) desc
--ex 5
select b.first_name, b.last_name,
count (film_id) as so_luong from film_actor as a
join public.actor as b on a.actor_id =b.actor_id
group by b.first_name, b.last_name
order by count (film_id) desc
--ex 6
select 
count (address) as so_luong from address as a
left join public.customer as b
on a.address_id =b. address_id
where customer_id is null
--ex 7
select a.city ,sum (d.amount) as doanh_thu
from city as a
join public.address as b on a.city_id =b.city_id
join public.customer as c on b.address_id = c.address_id
join public.payment as d on c.customer_id = d.customer_id
group by a.city
order by doanh_thu desc
--ex 8
select concat (a.country ,', ',b.city) as tp ,sum (e.amount) as doanh_thu
from country as a
join public.city as b on a.country_id =b.country_id
join public.address as c on b.city_id =c.city_id
join public.customer as d on c.address_id = d.address_id
join public.payment as e on d.customer_id = e.customer_id
group by a.country, b.city
order by doanh_thu 


















