-- 1. Sales and Profit by Segment
select segment, sum(sales), sum(profit)
from superstore.orders
group by segment;

-- 2. Best seller products
select Product_Name, sum(quantity)
from superstore.orders
group by Product_Name
order by sum(quantity) desc
limit 10;

-- 3. How many technology products each customer buy

select Customer_ID,
Customer_Name,
Segment,
Count(distinct Order_ID) as 'Number of Orders',
Count(distinct Product_ID) as 'Number of Products',
Sum(Sales) as 'Total Sales',
SUM(Sales)/Count(distinct Order_ID) as 'Revenue per Order',
SUM(CASE WHEN category = 'Technology' THEN 1 ELSE 0 END) as 'Number of Technology'
from superstore.orders
group by Customer_ID, Customer_Name, Segment;

-- 4. Top 10 products with the highest number of returned products

select product_id,
product_name, 
sum(o.quantity) as total_quantity
from superstore.orders o 
join superstore.returns r 
  on o.order_id = r.order_id 
group by product_id, product_name 
order by total_quantity DESC 
LIMIT 10;

-- 5. Top 10 cities with highest Sales per returned order?

select o.city, 
sum(sales)/count(distinct o.order_id) as average_sales_per_order
from superstore.orders o
join superstore.returns r on o.order_id = r.order_id 
group by o.city
order by average_sales_per_order DESC
limit 10;

-- 6. Customer Sales & Order Metrics with Product Breakdown and Recent Sales Trends 

-- - Customer ID & Customer Name & Segment
-- - Number of Orders
-- - Number of Products
-- - Total Sales
-- - Revenue per Order
-- - Number of Orders that have at least one Technology products
-- ---- USE DATE FUNCTIONS
-- - Total Sales in the last 6 months (Using 2017-12-30 as current date)
-- - Days since the latest order (Using 2017-12-30 as current date)
-- - Total Sales in the previous Month (Using 2017-12-30 as current date)

select Customer_ID,
Customer_Name,
Segment,
Count(distinct Order_ID) as 'Number of Orders',
Count(distinct Product_ID) as 'Number of Products',
Sum(Sales) as 'Total Sales',
SUM(Sales)/Count(distinct Order_ID) as 'Revenue per Order',
COUNT(distinct CASE WHEN category = 'Technology' THEN order_id END) as 'Number of Technology',
sum(case when
   order_date <= '2017-12-30' and order_date >= date_add('2017-12-30', interval -6 month)
   then sales
   else 0
   end)
 as 'Sales last 6 months',
DATEDIFF('2017-12-30', MAX(Order_date)) as 'Days since lastest order',
sum(case when
    order_date <= date_add('2017-12-30', interval -1 month) and order_date >= DATE_SUB(DATE_FORMAT('2017-12-30', '%Y-%m-01'), INTERVAL 1 MONTH)
    then sales
    else 0
    end)
as Sales_previous_month
from superstore.orders
group by Customer_ID, Customer_Name, Segment;

-- 7. Customers with High Return Activity: Profile and Returned Order Sales Summary
-- Get a list of all customers that have returned at least 2 order. In this list, we need following information
-- Name
-- Customer ID
-- Segment
-- Number of returned orders
-- Total Sales of Returned orders

select customer_name, customer_id, segment,
count(distinct r.order_id) 'number of return orders',
sum(o.sales) as 'total sales of returned orders'
from superstore.orders o
join superstore.returns r on o.order_id = r.order_id 
group by customer_name, customer_id, segment
having count(distinct r.order_id) >= 2;

-- 8. Monthly Customer Revenue, Rank, and Growth Tracking by Segment
-- Get a full list of customers which has
-- - Monthly total revenue, total profit
-- - For each customer, get a rank for each month based on total Sales against all other customers in the same Segment
-- - For each customer, get the difference of Total Sales against the Top 1 Customer in the same Segment each month.
-- - For each customer, get the % growth of current month total sales compared to previous “order month” total sales

-- Final table should have
-- - Customer ID, Name, Segment, Month, total sale, total profit,Monthly sale Rank,Month Sales Difference, pre-month sale, percent growth

select customer_id,
	   customer_name,
       segment,
       date_format(order_date, '%Y-%m-01') as month,
       sum(sales) as total_sales,
       sum(profit) as total_profit,
       sum(sum(sales)) over (
         partition by date_format(order_date, '%Y-%m-01'), customer_id
         order by date_format(order_date, '%Y-%m-01')) as monthly_sales,
	   row_number() over (partition by segment order by sum(sales) desc) as rank_sales 
from superstore.orders
group by customer_id,
	   customer_name,
       segment,
       date_format(order_date, '%Y-%m-01');
       
with data_pool as (
  select customer_id,
	   customer_name,
       segment,
       date_format(order_date, '%Y-%m-01') as order_month,
       sum(sales) as total_sales,
       sum(profit) as total_profit,
	   row_number() over (partition by segment order by sum(sales) desc) as rank_sales 
from superstore.orders
group by customer_id,
	   customer_name,
       segment,
       date_format(order_date, '%Y-%m-01')
)
select *,
       lag(p.total_sales) over(order by order_month) as prev_month_sales,
      (p.total_sales - lag(p.total_sales) over(order by order_month))/lag(p.total_sales) over(order by order_month) as growth,
      last_value(total_sales) over(
         partition by segment 
         order by total_sales 
         rows between unbounded preceding and unbounded following
         ) as highest_sales,
	   last_value(total_sales) over(
         partition by segment 
         order by total_sales 
         rows between unbounded preceding and unbounded following
         ) - total_sales as difference
from data_pool p 
order by rank_sales;

select *
from superstore.orders;

-- 8. Customer Retention Insights: Spending Patterns, Order Gaps, Return Frequency, and Inactivity Flags
-- Customer Retention Analysis. In one query, build a datasource (create a table from a code) that could answer the following questions in Tableau. Use “TRUE/FALSE Flag” when needed to simplify the final data source.
-- - Customer spent on each order - done
-- - Customers who spent more than $1000 in total and did not buy anything in the last 180 days (Use 2017-12-30 as current day and use Function to calculate 180 days) - done
-- - How many customers have the Gap Days between 2 consecutive orders more than 90 days?
-- - How many time one customer return after 90 days between 2 orders
-- - How much customer spent on the First order and the Last Orders - done

-- * Note: DO NOT MIX Aggregation with Non-Aggregation Window Functions. Split query if needed then join them again later. 
-- Try to imagine how your final table will look like before starting the coding

with customer_pool as (
  select distinct
         customer_id,
         customer_name,
         segment
   from superstore.orders
), -- select count(*) from customer_pool;

customer_order as (
  select cust.customer_id,
         ord.order_id,
		 ord.order_date,
         sum(ord.sales) as order_sales,
         sum(ord.profit) as order_profit
  from superstore.orders ord
  join customer_pool cust on 
    ord.customer_id = cust.customer_id
  group by cust.customer_id, ord.order_id, ord.order_date, ord.sales
    
), -- select count(*) from customer_order;

sales_summary as (
  select customer_id,
         sum(order_sales) as total_sales,
         sum(order_sales) > 1000 and DATEDIFF('2017-12-30',max(DATE_FORMAT(order_date, '%Y-%m-%D'))) >= 180 used_to_be_good_buyer
  from customer_order
  group by customer_id
), -- select count(*) from sales_summary;

ranked_order as (
  select customer_id,
         order_id,
		 order_date,
         order_sales,
         row_number () over (partition by customer_id order by order_date) = 1 as first_order,
         row_number () over (partition by customer_id order by order_date desc) = 1 as last_order
   from customer_order
),

prev_order as (
  select customer_id, 
         order_id,
         order_date,
         LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order_date,
         DATEDIFF(order_date, LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)) > 90 AS return_after_90_days
  from customer_order
  order by customer_id, order_date
),

count_day_return as (
  select customer_id,
          SUM(return_after_90_days) as num_return_days_after_90_days
  from prev_order
  group by customer_id
)

  select count(*), count(distinct co.customer_id), count(distinct co.order_id)
  from customer_pool cp
  left join customer_order co on
    cp.customer_id = co.customer_id 
  left join sales_summary su on 
    co.customer_id = su.customer_id
  left join prev_order pr on
    co.customer_id = pr.customer_id
    and co.order_id = pr.order_id;

-- 9. Customer Segmentation using RFM (Recency - Frequency - Monetary) model
-- This model requires 3 different factors related to each customer 
-- Recency: days since the last order
-- Frequency: Number of orders
-- Monetary: total spent
-- For each metric, we calculate the Percentile (PERCENT_RANK()) of each customer against their Segment or total customers. 
-- This will return the result from 0 - 1 (0 - 100%)
-- From that result we group them into 4 or 5 different groups for each metric. 
-- We use Numbers to group each metric (1 - 4) where 1 is the best and 4 is the worst. 
-- Be aware of Recency as it is different from other 2.
-- Exp: 0 - 25% => 1	; 25 - 50% => 2   ; 	50 - 75% => 3 	;  75 - 100% => 4
-- At the end, each customer will have their own Segmentation by the combination of 3 Metrics:
-- Customer ID, Recency, Frequency, Monetary, Recency_rank, Frequency_Rank, Monetary_Rank, RFM (Concatenate 3 ranks: 111; 124; 342… or Sum them up: 3; 6; 10;)


with base as (
  select customer_id,
		DATEDIFF('2017-12-30',max(DATE_FORMAT(order_date, '%Y-%m-%D'))) as recency,
        count(distinct order_id) as frequency,
        sum(sales) as monetary
from superstore.orders
group by customer_id
),
ranked as (
  select *,
         percent_rank() over (order by recency) as recency_percentile,
         percent_rank() over (order by frequency DESC) as frequency_percentile,
         percent_rank() over (order by monetary) as monetary_percentile
  from base
  
),
scaled as (
  select *,
  case 
    when recency_percentile <= 0.20 then 5
    when recency_percentile between 0.20 and 0.4 then 4
    when recency_percentile between 0.4 and 0.6 then 3
    when recency_percentile between 0.6 and 0.8 then 2
    else 1
  end as recency_score,
  
  case 
	when frequency_percentile <= 0.20 then 1
    when frequency_percentile between 0.20 and 0.4 then 2
    when frequency_percentile between 0.4 and 0.6 then 3
    when frequency_percentile between 0.6 and 0.8 then 4
    else 5
  end as frequency_score,
  
  case 
   when monetary_percentile <= 0.20 then 1
    when monetary_percentile between 0.20 and 0.4 then 2
    when monetary_percentile between 0.4 and 0.6 then 3
    when monetary_percentile between 0.6 and 0.8 then 4
    else 5
  end as monetary_score
  from ranked
)
select *,
case 
  when (recency_score between 4 and 5) and (frequency_score between 4 and 5) and (monetary_score between 4 and 5) then 'champion'
  when (recency_score between 2 and 4) and (frequency_score between 2 and 4) and (monetary_score between 2 and 4) then 'loyal customers'
  when (recency_score between 3 and 5) and (frequency_score between 1 and 3) and (monetary_score between 1 and 3) then 'potential loyalists'
  when (recency_score between 4 and 5) and (frequency_score < 2) and (monetary_score < 2) then 'new customers'
  when (recency_score between 3 and 4) and (frequency_score < 2) and (monetary_score < 2) then 'promising'
  when (recency_score between 3 and 4) and (frequency_score between 3 and 4) and (monetary_score between 3 and 4) then 'need attention'
  when (recency_score between 2 and 3) and (frequency_score < 3) and (monetary_score < 3) then 'about to sleep'
  when (recency_score < 3) and (frequency_score between 2 and 5) and (monetary_score between 2 and 5) then 'at risk'
  when (recency_score < 2) and (frequency_score between 4 and 5) and (monetary_score between 4 and 5) then 'cant lose them'
  when (recency_score between 2 and 3) and (frequency_score between 2 and 3) and (monetary_score between 2 and 3) then 'hibernating'
  when (recency_score < 2) and (frequency_score <2 ) and (monetary_score <2 ) then 'lost'
end as customer_segment
from scaled

  




