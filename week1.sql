/*
CREATE DATABASE dannys_diner;

CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  */

  /* 
  --------------------
  Case Study Questions
  --------------------
   */

-- 1. What is the total amount each customer spent at the restaurant?
SELECT
s.customer_id,
SUM(price) as total_amount
FROM sales s
JOIN menu m
ON s.product_id = m.product_id
GROUP BY s.customer_id;

-- 2. How many days has each customer visited the restaurant?
SELECT
m.customer_id,
COUNT(DISTINCT order_date) as days
FROM sales s
RIGHT JOIN members m -- get all customers
ON s.customer_id = m.customer_id
GROUP BY m.customer_id;

-- 3. What was the first item from the menu purchased by each customer?
SELECT
s.customer_id,
mu.product_name
FROM sales s
JOIN members m
ON s.customer_id = m.customer_id AND s.order_date = m.join_date -- get first order date
JOIN menu mu
ON s.product_id = mu.product_id;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT
mu.product_name,
COUNT(s.product_id) as num_of_orders
FROM menu mu
LEFT JOIN sales s
ON mu.product_id = s.product_id
GROUP BY mu.product_name;

-- 5. Which item was the most popular for each customer?
WITH customer_orders_per_product AS ( 
    SELECT
        s.customer_id AS customer_id,
        s.product_id AS product_id,
        COUNT(1) AS orders
    FROM sales s
    GROUP BY s.customer_id, s.product_id
)
SELECT
    customer_id, 
    MAX(orders) AS most_popular_item
FROM customer_orders_per_product
GROUP BY customer_id;


-- 6. Which item was purchased first by the customer after they became a member?

WITH ranked_sales AS (
    SELECT
        s.customer_id,
        s.product_id,
        ROW_NUMBER() OVER (
            PARTITION BY s.customer_id
            ORDER BY s.order_date
        ) AS row_num
    FROM sales s
    JOIN members m
        ON s.customer_id = m.customer_id
       AND s.order_date >= m.join_date
)
SELECT
    customer_id,
    product_id
FROM ranked_sales
WHERE row_num = 1
ORDER BY customer_id;


-- 7. Which item was purchased just before the customer became a member?
WITH ranked_sales AS (
    SELECT
        s.customer_id,
        s.product_id,
		s.order_date,
		m.join_date,
        ROW_NUMBER() OVER (
            PARTITION BY s.customer_id
            ORDER BY s.order_date DESC
        ) AS row_num
    FROM sales s
    JOIN members m
        ON s.customer_id = m.customer_id
       AND s.order_date < m.join_date
)
SELECT
    customer_id,
    product_id
FROM ranked_sales
WHERE row_num = 1;


-- 8. What is the total items and amount spent for each member before they became a member?
SELECT
s.customer_id,
COUNT(s.product_id) as total_items,
SUM(mu.price) as amount
FROM sales s
JOIN menu mu
ON s.product_id = mu.product_id
JOIN members m
ON s.customer_id = m.customer_id
AND s.order_date < m.join_date -- only those orders before they became members
GROUP BY s.customer_id


-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT
s.customer_id,
SUM(
CASE
WHEN mu.product_name = 'sushi'
THEN mu.price * 10 * 2
ElSE mu.price * 10
END) 
AS Points
FROM sales s
JOIN menu mu
ON s.product_id = mu.product_id
GROUP BY s.customer_id


-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, 
--		not just sushi - how many points do customer A and B have at the end of January?
SELECT s.customer_id, SUM(
    CASE
        WHEN DATEDIFF(day, s.order_date, m.join_date) <= 7 THEN mu.price * 10 * 2
        ELSE mu.price * 10
    END
) AS Points
FROM sales s
JOIN menu mu ON s.product_id = mu.product_id
JOIN members m ON s.customer_id = m.customer_id
WHERE s.order_date <= '2021-01-31'
GROUP BY s.customer_id;
