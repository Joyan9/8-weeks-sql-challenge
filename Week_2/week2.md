# Week 2 SQL Case Study

## Overview
This repository contains SQL queries and analyses performed as part of the Week 2 SQL Case Study. The case study focuses on customer orders, runner performance, revenue calculations, and database schema design.
https://8weeksqlchallenge.com/case-study-2/


## Dataset
The study involves three key tables:
1. **customer_orders** - Contains customer order details, including pizza type, exclusions, and extras.
2. **runner_orders** - Tracks delivery details, including pickup time, duration, and distance traveled.
3. **pizza_names** - Maps pizza IDs to their respective names.

## Key Analysis and Queries
### 1. **Handling Extras and Exclusions**
- Used lateral joins and `STRING_SPLIT` to handle pizza extras and exclusions.
- Extracted toppings from a comma-separated list and associated them with orders.

### 2. **Revenue Calculation**
- Assigned fixed prices to pizzas (`$12` for Meat Lovers, `$10` for Vegetarian).
- Calculated total revenue from customer orders.

### 3. **Runner Payments & Profit Calculation**
- Extracted numerical distance values using regex.
- Computed runner fees (`$0.30` per km traveled).
- Calculated net profit after runner payments.

### 4. **Adding a Rating System**
- Designed a new `ratings` table to capture customer feedback (1-5 scale).
- Integrated ratings into runner performance analysis.

### 5. **Comprehensive Order Insights**
- Joined `customer_orders`, `runner_orders`, and `ratings` tables.
- Computed delivery duration, time between order and pickup, average speed, and total pizzas per order.





