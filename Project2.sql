--1.Số lượng đơn hàng và số lượng khách hàng mỗi tháng
--Thống kê tổng số lượng người mua và số lượng đơn hàng đã hoàn thành mỗi tháng (Từ 1/2019-4/2022)
SELECT 
FORMAT_DATE("%Y-%m", created_at) AS month_year,
COUNT(user_id) AS total_users,
COUNT(order_id) AS total_order
FROM `bigquery-public-data.thelook_ecommerce.order_items`
WHERE status = 'Complete' and FORMAT_DATE("%Y-%m", created_at) between '2018-12-31' and '2022-4-30' 
GROUP BY month_year
ORDER BY month_year 
    --Insight. Số lượng đơn hàng tăng dần theo mỗi tháng
--2.Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
--Thống kê giá trị đơn hàng trung bình và tổng số người dùng khác nhau mỗi tháng (Từ 1/2019-4/2022)
SELECT 
FORMAT_DATE("%Y-%m", created_at) AS month_year,
COUNT(DISTINCT user_id) AS distinct_users,
ROUND((SUM(sale_price)/COUNT(DISTINCT order_id)),2) AS average_order_value
FROM `bigquery-public-data.thelook_ecommerce.order_items`
WHERE status = 'Complete' and FORMAT_DATE("%Y-%m", created_at) between '2018-12-31' and '2022-04-30'
GROUP BY month_year
ORDER BY month_year;
    --Insight. Số lượng người dùng mới mỗi tháng tăng 
--3.3. Nhóm khách hàng theo độ tuổi
--Tìm các khách hàng có trẻ tuổi nhất và lớn tuổi nhất theo từng giới tính (Từ 1/2019-4/2022)
with twt_customer as
(select first_name,last_name,gender,age,
CASE WHEN gender = 'M' THEN 1 ELSE null END AS male,
CASE WHEN gender = 'F' THEN 1 ELSE null END AS female,
CASE
WHEN age < 13 THEN 'Youngest'
WHEN age > 69 THEN 'Oldest'
    END AS age_group
from bigquery-public-data.thelook_ecommerce.users
where created_at between '2019-01-01' and '2022-4-30'
group by first_name,last_name,gender,age)
select gender,age,
COUNT(female) AS female,
COUNT(male) AS male,
CASE
WHEN age < 13 THEN 'Youngest'
WHEN age > 69 THEN 'Oldest'
    END AS age_group,
from twt_customer
where age =12 or age=70
group by gender,age
    --Insight. KH trẻ nhất là 12 tuổi 534 Nữ và 505 Nam, KH lớn tuổi nhất là 70 tuổi 545 Nữ và 536 Nam
--4.Top 5 sản phẩm mỗi tháng.
--Thống kê top 5 sản phẩm có lợi nhuận cao nhất từng tháng (xếp hạng cho từng sản phẩm). 
WITH
main AS (
SELECT  
FORMAT_DATE("%Y-%m", created_at) AS month_year,
name AS product_name,
products.id AS products_id,
ROUND(retail_price) AS retail_price,
ROUND(cost) AS cost,
SUM(sale_price-cost) AS profit
FROM `bigquery-public-data.thelook_ecommerce.products` products
JOIN `bigquery-public-data.thelook_ecommerce.order_items` orders  
ON products.id = orders.product_id
WHERE status = 'Complete'
GROUP BY 1,2,3,4,5
),
top_most AS (
SELECT  *, DENSE_RANK() OVER (ORDER BY profit DESC) AS top_rank
FROM main
)
SELECT *  FROM top_most
ORDER BY top_rank 
LIMIT 5
--5.5.Doanh thu tính đến thời điểm hiện tại trên mỗi danh mục
--Thống kê tổng doanh thu theo ngày của từng danh mục sản phẩm (category) trong 3 tháng qua ( giả sử ngày hiện tại là 15/4/2022)
WITH
total_profit AS (
SELECT 
DATE(orders.shipped_at) AS order_date,
products.category AS product_categories,
SUM(sale_price-cost) AS profit
FROM `bigquery-public-data.thelook_ecommerce.products` products
INNER JOIN `bigquery-public-data.thelook_ecommerce.order_items` orders 
ON products.id = orders.product_id
WHERE status = 'Complete'
AND orders.created_at BETWEEN '2022-01-01'AND '2022-04-15'
GROUP BY 1,2
ORDER BY 2,1
),
revenue_table AS (
SELECT
order_date,
product_categories,
profit,
SUM(profit) OVER(PARTITION BY product_categories, EXTRACT(MONTH FROM order_date) ORDER BY 2,1) AS revenue
FROM total_profit
ORDER BY 2,1
)
SELECT 
order_date,
product_categories,
ROUND(revenue, 3) AS revenue
FROM revenue_table
WHERE order_date BETWEEN '2022-01-01'AND '2022-04-15'


