--1. how many pizzas were ordered ?
select count(*) from customer_orders;

--2. How many unique customer orders were made?
select count(distinct order_id) from customer_orders;

--3. How many successful orders were delivered by each runner?

select * from runner_orders;

with cleaned_runner_orders as(
select *,
	(case 
		when cancellation in ('Customer Cancellation', 'Restaurant Cancellation')
		then 'cancelled'
		else 'successful'
	end) as order_status
from runner_orders
)

select runner_id, Count(distinct order_id) as successful_orders
from cleaned_runner_orders
where order_status = 'successful'
group by runner_id

--4. How many of each type of pizza was delivered?
-- here delivered means successful
with cleaned_runner_orders as(
select *,
	(case 
		when cancellation in ('Customer Cancellation', 'Restaurant Cancellation')
		then 'cancelled'
		else 'successful'
	end) as order_status
from runner_orders
), cte2 as(
select * from customer_orders c
JOIN 
pizza_names p ON c.pizza_id = p.pizza_id
JOIN 
cleaned_runner_orders cl ON cl.order_id = c.order_id
)

select 
cte2.pizza_name, count(*)
from cte2
where order_status = 'successful'
GROUP BY cte2.pizza_name

--5. How many Vegetarian and Meatlovers were ordered by each customer?
select c.customer_id,
p.pizza_name,  count(*) as total_orders
from customer_orders c
JOIN pizza_names p
ON c.pizza_id = p.pizza_id
group by p.pizza_name, c.customer_id
order by c.customer_id

-- 6. What was the maximum number of pizzas delivered in a single order?
with cleaned_runner_orders as(
select *,
	(case 
		when cancellation in ('Customer Cancellation', 'Restaurant Cancellation')
		then 'cancelled'
		else 'successful'
	end) as order_status
from runner_orders
)

select c.order_id, count(*) as total_pizzas from customer_orders c
join cleaned_runner_orders cl 
ON c.order_id = cl.order_id
where order_status = 'successful'
group by c.order_id
order by total_pizzas desc
limit 1


