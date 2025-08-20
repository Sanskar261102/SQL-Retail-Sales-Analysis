create database sales_analysis;
use sales_analysis;
show tables;
select * from data;

select transactions_id  from data;

show tables;

select * from data;


alter table data
change `ï»¿transactions_id` `transactions_id` int;

select * from data;

alter table data
add primary key (`transactions_id`);

select * from data; 

/*checking number of rows in the data and in the excel to validate imported data*/
 select count(*) from data;
 
/*check if any null value exist in the transactions_id column*/ 
select * from data 
where transactions_id is null;

/*check if any null value exist in any column*/ 
select * from data 
where sale_date is null;

select * from data 
where sale_time is null;
 /*do this for all*/
/*instead of all this, this ca also be done as:*/

select * from data
where 
	transactions_id is null 
	or 
    sale_date is null 
    or 
    sale_time is null 
    or 
    customer_id is null 
    or 
    gender is null 
    or 
    age is null 
    or 
    category is null 
    or 
    price_per_unit is null
    or
    cogs is null
    or 
    quantiy is null
    or 
    total_sale is null;

/* if any null value exists, we would have used the same query with a change in the first line only*/

delete from data
where 
	transactions_id is null 
	or 
    sale_date is null 
    or 
    sale_time is null 
    or 
    customer_id is null 
    or 
    gender is null 
    or 
    age is null 
    or 
    category is null 
    or 
    price_per_unit is null
    or
    cogs is null
    or 
    quantiy is null
    or 
    total_sale is null;

/*since 0 rows affected, this also validates that there was no null value in any column*/

/*Data Exploration*/

/*how many sales we have*/ 

select * from data;
select sum(total_sale) from data;

/*how many custoemrs do we have*/
select  count(distinct(customer_id)) from data;

/*how many cateogires did sales*/

select count(distinct(category)) from data;

/*name of categories*/

select distinct(category) from data;


-- Data Analysis, Business Key Problems and Answers

/*Write a sql query to retrieve all columns for sales made on '2022-11-05'*/
select * from data;

select * from data 
where sale_date = '2022-11-05';

/*category is clothing and the quantity sold is more than 10 in the month of nov 2022*/
select * from data
where 
category = 'Clothing' 
and 
quantiy > 10
and 
sale_date between '2022-11-01' and '2022-11-30'; 

/*calculate total sales for each category*/
select category as Category,sum(total_sale) as Total_Sale from data
group by category;

/*find the average age of the person who bought item from beauty category*/
select avg(age) as Average_Age from data 
where category = 'Beauty';

/*find all transaction where total sale is greater than 1k*/
select * from data
where total_sale > 1000;

/*total number of transaction made by each gender in each category*/
select gender,category,count(transactions_id) as total_number_of_transaction from data
group by gender desc,category;

/* calculate sale for each month of each year and also find out the best selling month of eah year*/
/* to execute this query the data in the sale date column we need to first convert the data into 'date' data type*/
 show tables;
 select * from data;
 
 alter table data 
 modify sale_date date;
 
 select year(sale_date) as `Year`,month(sale_date) as `Month` ,avg(total_sale) as average_sale_per_month from data 
 group by year(sale_date),month(sale_date)
 order by year(sale_date) desc,month(sale_date) desc;
 
 /*best selling month in each year*/
with cte as  (
 select year(sale_date) as `Year`,month(sale_date) as `Month` ,avg(total_sale) as average_sale_per_month from data 
 group by year(sale_date),month(sale_date)
 )
select Year, Month , average_sale_per_month as sales_amount_avg  from ( 
select cte.*,
row_number() over (partition by cte.year order by average_sale_per_month desc  )  as rn from cte
) ranked 
where rn = 1
order by year desc; 

/*find out top 5 customers based on highest total sales*/

select * from data;

select customer_id,total_sale from data
order by total_sale desc limit 5;

/*find out the unique customers who purchased items from each category*/

select * from data;
SELECT DISTINCT customer_id as unique_customers_id, category
FROM data
WHERE category IN ('Clothing', 'Beauty', 'Electronics')
ORDER BY customer_id ASC;


/*sql query to create morning,afternoon, evening shift and number of orders in each shift*/

select * from data;

alter table data
modify sale_time time;

select
case 
    when hour(sale_time) <=12 then 'Morning'
    when hour(sale_time) between 12 and 17 then 'Afternoon'
    when hour(sale_time) >17 then 'Evening'
    else 'Night'
    end as Shift,
    count(*) as number_of_orders
from data
group by shift
order by number_of_orders desc;


/*End of Project*/