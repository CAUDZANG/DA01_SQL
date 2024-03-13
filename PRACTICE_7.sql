--ex 1
SELECT DATE_PART('year', transaction_date) AS year, product_id, spend AS curr_yr_spend, 
LAG(spend) OVER(PARTITION BY product_id ORDER BY DATE_PART('year', transaction_date)) AS prev_yr_spend, 
ROUND((spend - LAG(spend) OVER(PARTITION BY product_id ORDER BY DATE_PART('year', transaction_date))) 
/ LAG(spend) OVER(PARTITION BY product_id ORDER BY DATE_PART('year', transaction_date)) * 100, 2) AS yoy_rate
FROM user_transactions
--ex 2
SELECT 
DISTINCT card_name, 
FIRST_VALUE(issued_amount) OVER (PARTITION BY card_name ORDER BY issue_year, issue_month ) AS issued_amount
from monthly_cards_issued
ORDER BY issued_amount DESC
--ex 3
SELECT t.user_id, t.spend, t.transaction_date FROM 
(SELECT ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date ASC) AS rownum, user_id, spend, transaction_date 
FROM transactions) AS t
WHERE rownum = 3
--ex 4
with cte as (SELECT *, rank() over(PARTITION BY user_id ORDER BY transaction_date DESC) as rn 
FROM user_transactions)
select transaction_date, user_id, count(product_id) from cte where rn =1 group by transaction_date, user_id
--ex 5
select t.user_id,t.tweet_date , round((t.st*1.00)/(case when t.rn<3 then t.rn else 3 end),2) from
(SELECT user_id,tweet_date , 
tweet_count+lag(tweet_count,1,0) over(partition by user_id order by tweet_date)+lag(tweet_count,2,0) over(partition by user_id order by tweet_date) as st , row_number() over (partition by user_id)  as rn
from tweets) t
--ex 6
Select 
sum(Case when (next_transaction_time is not null) and 
((next_transaction_time - transaction_timestamp) <= INTERVAL '10 minutes') then 1 else 0 end) as payment_count
from
(Select merchant_id, credit_card_id, transaction_timestamp, amount,
lead(transaction_timestamp,1) over(PARTITION BY merchant_id, credit_card_id, amount) as next_transaction_time
from transactions) as s
--ex 7
SELECT category, product, total_spend 
FROM (SELECT category, product, 
SUM(spend) AS total_spend,
RANK() OVER (PARTITION BY category 
ORDER BY SUM(spend) DESC) AS ranking 
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY category, product) AS ranked_spending
WHERE ranking <= 2 
ORDER BY category, ranking
--ex 8
SELECT * FROM 
(SELECT artist_name,
DENSE_RANK() OVER(ORDER BY COUNT(song_id) DESC) AS artist_rank
FROM artists
JOIN songs USING(artist_id)
JOIN global_song_rank USING(song_id)
WHERE rank <=10 
GROUP BY artist_name) AS t
WHERE artist_rank <=5
