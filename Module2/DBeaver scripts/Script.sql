--TASK, let's answer the questions given in module 1

--order table
select * 
from orders o
limit 10;

--people table
SELECT person, region
FROM people p;

--returns table
SELECT returned, order_id
FROM "returns" r;



select sum(o.sales) as total_sales, 		 --Total Sales
sum(o.profit) as total_profit,				 --Total Profit
sum(o.profit)/sum(o.sales) as profit_ratio   --Profit Ratio

from orders o


--check amount unique order_id = 5009
select count(o.order_id), count(distinct o.order_id) 
from orders o 


--Profit per Order
select o.order_id, sum(o.profit) as order_profit 
from orders o 
group by 1
order by 2 desc


--Sales per Customer
select p.person, sum(o.sales)  
from orders o 
left join people p on o.region = p.region 
group by p.person 
order by 2 desc 


--Avg. Discount
SELECT avg(o.discount)
FROM orders o


--Monthly Sales by Segment
select DATE_TRUNC('month', o.order_date) AS date_to_month,
	   o.segment,
       sum(o.sales) AS sales_sum
FROM orders o 
GROUP BY DATE_TRUNC('month', o.order_date), o.segment 
order by 1, 3 desc


--Monthly Sales by Product Category
select DATE_TRUNC('month', o.order_date) AS date_to_month,
	   o.category,
       sum(o.sales) AS sales_sum
FROM orders o 
GROUP BY DATE_TRUNC('month', o.order_date), o.category 
order by 1, 3 desc


--Sales by Product Category over time (Продажи по категориям)
--Всего sales для каждой category
select o.category, sum(o.sales) as total_sales
from orders o 
group by 1
order by 2 desc 


--Решил сделать коммулятивную сумму sales по месяцам для каждой category
select distinct DATE_TRUNC('month', o.order_date) AS date_to_month,
	   o.category,
	   sum(o.sales) over(partition by o.category order by DATE_TRUNC('month', o.order_date))   
from orders o 
order by 1,2	


--Sales and Profit by Customer
select p.person, sum(o.sales) as sales_per_customer, sum(o.profit) as profit_per_customer  
from orders o 
left join people p on o.region = p.region 
group by p.person 
order by 3 desc 


--Sales per region
select o.region, sum(o.sales) as sales_per_region
from orders o 
group by 1 
order by 2 desc 

