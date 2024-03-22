-- 1) Write a query to return the name of the store and its manager, that generated the most sales.  --
SELECT store, manager
FROM sales_by_store 
ORDER BY total_sales DESC 
LIMIT 1

--2) Write a query to find the top 3 film categories that generated the most sales.--
SELECT category 
FROM sales_by_film_category 
ORDER BY total_sales DESC 
LIMIT 3;

--3) Write a query to return the titles of the 5 shortest movies by duration.--
SELECT title 
FROM film 
ORDER BY length ASC 
LIMIT 5;

-- 4) Write a SQL query to return this staff's first name and last name.
-- • Picture field contains the link that points to a staff's profile image.
-- • There is only one staff who doesn't have a profile picture.
-- • Use colname IS NULL to identify data that are missing. 
SELECT first_name, last_name 
FROM staff 
WHERE picture IS NULL ;

-- 5) Write a query to return the total movie rental revenue for each month.
SELECT EXTRACT (YEAR FROM payment_date) AS year, EXTRACT(MONTH FROM payment_date) AS month , sum(amount) AS rev
FROM payment
GROUP BY 1, 2;

-- 6) Write a query to return daily revenue in Feb, 2007.
SELECT CAST (payment_date AS date) AS dt, amount  
FROM payment
WHERE EXTRACT (YEAR FROM payment_date) = 2007
AND EXTRACT (MONTH FROM payment_date) = 2;


-- 7) Write a query to return the total number of unique customers for each month
SELECT EXTRACT(YEAR FROM rental_date) AS dt, EXTRACT(MONTH FROM rental_date) AS mn, count(DISTINCT customer_id)
FROM rental
GROUP BY 1, 2;

-- 8) Write a query to return the average customer spend by month.
SELECT EXTRACT(YEAR FROM payment_date) AS dt, EXTRACT(MONTH FROM payment_date) AS mn, avg(amount)
FROM payment
GROUP BY 1, 2;

-- 9) Write a query to count the number of customers who spend more than (>) $20 by month
SELECT EXTRACT(YEAR FROM payment_date) AS dt, EXTRACT(MONTH FROM payment_date) AS mn, count(customer_id)
FROM payment
GROUP BY 1, 2
HAVING avg(amount) > 2;

-- 10) Write a query to return the minimum and maximum customer total spend in Feb 2007
SELECT max(spend) AS max_spend, min(spend) AS min_spend
FROM (SELECT customer_id , sum(amount) AS spend 
FROM payment
WHERE EXTRACT(YEAR FROM payment_date) = 2007
AND EXTRACT(MONTH FROM payment_date) = 02
GROUP BY 1) X ;


