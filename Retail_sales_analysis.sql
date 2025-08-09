select * from retail_analysis.orders;


-- find top 10 highest revenue generating products

select product_id, sum(sale_price) as sales
from retail_analysis.orders
group by product_id
order by sales desc
limit 10;


-- find top 5 highest selling products in each region

with cte as (
select region, product_id, sum(sale_price) as sales
from retail_analysis.orders
group by region, product_id
)
select * from (
select * , row_number() over(partition by region order by sales desc) as rn
from cte
) A
where rn <=5;

-- find month over month growth comparison for 2022 and 2023 sales

WITH cte AS (
    SELECT 
        YEAR(order_date) AS order_year,
        MONTH(order_date) AS order_month,
        SUM(sale_price) AS sales
    FROM retail_analysis.orders
    GROUP BY YEAR(order_date), MONTH(order_date)
)
SELECT 
    order_month, 
    round(sum(CASE WHEN order_year = 2022 THEN sales ELSE 0 END),2) AS sales_2022,
    round(sum(CASE WHEN order_year = 2023 THEN sales ELSE 0 END ),2) AS sales_2023
FROM cte
GROUP BY order_month
ORDER BY order_month;


-- for each category which month has the highest sales

WITH cte AS (
    SELECT 
        category,
        YEAR(order_date) AS order_year,
        MONTH(order_date) AS order_month,
        SUM(sale_price) AS sales
    FROM retail_analysis.orders
    GROUP BY category, YEAR(order_date), MONTH(order_date)
)
SELECT category, order_year, order_month, sales
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY category 
               ORDER BY sales DESC
           ) AS rn
    FROM cte
) a
WHERE rn = 1;



-- which sub category had highest growth by profit in 2023 compare to 2022
WITH cte AS (
    SELECT sub_category,
           YEAR(order_date) AS order_year,
           SUM(sale_price) AS sales
    FROM retail_analysis.orders
    GROUP BY sub_category, YEAR(order_date)
),
cte2 AS (
    SELECT sub_category,
           ROUND(SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END), 2) AS sales_2022,
           ROUND(SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END), 2) AS sales_2023
    FROM cte
    GROUP BY sub_category
)
SELECT *,
       (sales_2023 - sales_2022) AS sales_difference
FROM cte2
ORDER BY sales_difference DESC
LIMIT 1;




