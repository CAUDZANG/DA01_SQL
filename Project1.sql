--Chuyển đổi kiểu dữ liệu phù hợp cho các trường ( sử dụng câu lệnh ALTER)
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN ordernumber         TYPE numeric USING sales::numeric,
ALTER COLUMN quantityordered     TYPE numeric USING sales::numeric,
ALTER COLUMN priceeach           TYPE numeric(5,2) USING sales::numeric(5,2),
ALTER COLUMN orderlinenumber     TYPE numeric USING sales::numeric,
ALTER COLUMN sales               TYPE numeric(10,2) USING sales::numeric(10,2),
ALTER COLUMN status              TYPE text,
ALTER COLUMN productline         TYPE text,
ALTER COLUMN productcode         TYPE text,
ALTER COLUMN msrp                TYPE numeric USING sales::numeric
ALTER COLUMN customername        TYPE text,
ALTER COLUMN addressline1        TYPE text,
ALTER COLUMN addressline2        TYPE text,
ALTER COLUMN city                TYPE text,
ALTER COLUMN state               TYPE text,
ALTER COLUMN postalcode          TYPE text,
ALTER COLUMN country             TYPE text,
ALTER COLUMN territory           TYPE text,
ALTER COLUMN contactfullname     TYPE text,
ALTER COLUMN dealsize            TYPE text,
 
SET datestyle = 'iso,mdy';  
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE date USING (TRIM(orderdate):: date),
--Check NULL/BLANK (‘’)  ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE.
Select ordernumber
From sales_dataset_rfm_prj
Where ordernumber is null
Select quantityordered
From sales_dataset_rfm_prj
Where quantityordered is null
Select priceeach
From sales_dataset_rfm_prj
Where priceeach is null
Select orderlinenumber
From sales_dataset_rfm_prj
Where orderlinenumber is null
Select sales
From sales_dataset_rfm_prj
Where sales is null
Select orderdate
From sales_dataset_rfm_prj
Where orderdate is null
--Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME . Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường. Gợi ý: ( ADD column sau đó UPDATE)
alter table sales_dataset_rfm_prj
add contactfirstname text,
add contactlastname text
  
update sales_dataset_rfm_prj
set contactfirstname = substring (contactfullname from 1 for position ('-' in contactfullname)-1) ,
set contactlastname = substring (contactfullname from position ('-' in contactfullname)+1 ) 

UPDATE sales_dataset_rfm_prj
SET contactlastname=UPPER(LEFT(contactlastname,1))|| LOWER(SUBSTRING(contactlastname,2,length(contactlastname))),
SET contactfirstname=UPPER(LEFT(contactfirstname,1))|| LOWER(SUBSTRING(contactfirstname,2,length(contactfirstname)))
--Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE
alter table sales_dataset_rfm_prj
add QTR_ID numeric,
add MONTH_ID text,
add YEAR_ID numeric

UPDATE sales_dataset_rfm_prj
set qtr_id =extract (QUARTER from orderdate),
set month_id =extract (month from orderdate),
set year_id =extract (year from orderdate)
--Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó (2 cách) ( Không chạy câu lệnh trước khi bài được review)
--BOXPLOT
with twt_min_max_value as(
select Q1-1.5*IQR as min_value,
Q3+1.5*IQR as max_value 
from(
select 
percentile_cont(0.25) within group (order by QUANTITYORDERED) as Q1,
percentile_cont(0.75) within group (order by QUANTITYORDERED) as Q3,
percentile_cont(0.75) within group (order by QUANTITYORDERED) -percentile_cont(0.25) within group (order by QUANTITYORDERED) as IQR
from sales_dataset_rfm_prj
) as a)

select * from sales_dataset_rfm_prj
where QUANTITYORDERED <(select min_value from twt_min_max_value)
or QUANTITYORDERED >(select max_value from twt_min_max_value)
--Z-SCORE
with cte as
(select QUANTITYORDERED,
(select avg(QUANTITYORDERED)
from sales_dataset_rfm_prj) as avg,
(select stddev (QUANTITYORDERED) from sales_dataset_rfm_prj) as stddev
from sales_dataset_rfm_prj)

select QUANTITYORDERED, (QUANTITYORDERED-avg)/stddev as z_score
from cte
where abs ((QUANTITYORDERED-avg)/stddev) >6
--Sau khi làm sạch dữ liệu, hãy lưu vào bảng mới  tên là SALES_DATASET_RFM_PRJ_CLEAN
create table SALES_DATASET_RFM_PRJ_CLEAN as select * from sales_dataset_rfm_prj







