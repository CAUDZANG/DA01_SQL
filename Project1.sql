--Chuyển đổi kiểu dữ liệu phù hợp cho các trường ( sử dụng câu lệnh ALTER)
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderdate type date using orderdate:: timestamp
ALTER COLUMN productline type text,
ALTER COLUMN productcode type text,
ALTER COLUMN postalcode type text,
ALTER COLUMN dealsize type text
  
SET datestyle = 'iso,mdy';  
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE date USING (TRIM(orderdate):: date)

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN sales TYPE numeric(10,2)
USING sales::numeric(10,2)
ALTER COLUMN phone TYPE numeric
USING phone::numeric;
--Check NULL/BLANK (‘’)  ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE.
Select ordernumber, quantityordered, priceeach, orderlinenumber, sales, orderdate
From sales_dataset_rfm_prj
Where ordernumber is null
--Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME . Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường. Gợi ý: ( ADD column sau đó UPDATE)
alter table sales_dataset_rfm_prj
add contactfirstname text,
add contactlastname text
