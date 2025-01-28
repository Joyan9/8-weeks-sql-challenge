SET search_path = pizza_runner;

-- How many pizzas were ordered?
SELECT
	COUNT(DISTINCT order_id) as orders
FROM customer_orders;

-- How many unique customer orders were made?
SELECT
	COUNT(DISTINCT customer_id) as customers
FROM customer_orders;

-- How many successful orders were delivered by each runner?
SELECT
	runner_id,
    COUNT(order_id) as orders
FROM runner_orders
WHERE pickup_time <> 'null' -- filter out all cancelled orders
GROUP BY runner_id;

-- What was the maximum number of pizzas delivered in a single order?
WITH 
pizzas_per_order AS 
(
 SELECT
 order_id,
 COUNT(pizza_id) as pizzas
FROM customer_orders
GROUP BY order_id
), 
pizzas_per_order_wt_rank AS (
  SELECT
	*,
    DENSE_RANK() OVER(ORDER BY pizzas DESC) as rank
FROM pizzas_per_order
 
)
  
SELECT * FROM pizzas_per_order_wt_rank
WHERE rank = 1;


-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
WITH
orders_with_changes_flag AS (
SELECT
 *,
 CASE 
 -- how many orders with at least 1 change
 WHEN exclusions NOT IN ('','null')
 		OR extras NOT IN ('null', 'NaN','')
 THEN 1
 ELSE 0
 END as changes 
FROM customer_orders
)

SELECT
changes as is_changed,
COUNT(DISTINCT order_id) as orders
FROM orders_with_changes_flag
GROUP BY changes;


-- How many pizzas were delivered that had both exclusions and extras?

WITH
orders_with_changes_flag AS (
SELECT
 *,
 CASE 
 -- both exclusions and extras at least 1 change
 WHEN exclusions NOT IN ('','null')
 		AND extras NOT IN ('null', 'NaN','')
 THEN 1
 ELSE 0
 END as changes 
FROM customer_orders
)

SELECT
changes as has_changes_to_exclusion_and_extras,
COUNT(DISTINCT order_id) as orders
FROM orders_with_changes_flag
GROUP BY changes;
