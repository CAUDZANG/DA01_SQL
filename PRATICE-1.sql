--ex 1
select NAME from CITY 
where COUNTRYCODE = "USA"
and POPULATION > 120000
--ex 2 
select * from CITY
where COUNTRYCODE ="JPN"
--ex 3
select CITY, STATE from STATION
--ex 4
select distinct CITY from STATION
where CITY like 'A%' 
or CITY like 'E%' 
or CITY like 'I%' 
or CITY like 'O%' 
or CITY like 'U%' 
--ex 5
select distinct CITY from STATION
where CITY like '%A' 
or CITY like '%E' 
or CITY like '%I' 
or CITY like '%O' 
or CITY like '%U' 
--ex 6
select distinct CITY from STATION
where CITY not like 'A%' 
and CITY not like 'E%' 
and CITY not like 'I%' 
and CITY not like 'O%' 
and CITY not like 'U%' 
--ex 7
select NAME from Employee
order by NAME
--ex 8
select NAME from employee
where salary > 2000
and months <10
order by employee_id asc
--ex 9
select product_id from Products
where low_fats ='Y'
and recyclable ='Y'
--ex 10
select name from customer
where referee_id != 2
or referee_id is null
--ex 11
select name, population, area from world
where area >= 3000000 
or population >=25000000
--ex 12
select distinct author_id as id from views
where author_id = viewer_id
order by id asc
--ex 13
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date IS NULL
--ex 14
select * from lyft_drivers
where yearly_salary <= 30000 or yearly_salary >= 70000
--ex 15
select * from uber_advertising
where money_spent >100000
and year = 2019























