-- who is the senior most employee based on job title--
SELECT first_name, last_name, title
FROM employee
ORDER BY levels DESC 
LIMIT 1;

-- which countries  have most invoices -- 
SELECT billing_country,count(DISTINCT invoice_id)
FROM invoice 
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 1;

-- what are top 3 values of total invoices --
SELECT * FROM invoice 
ORDER BY total DESC 
LIMIT 3;

-- which city has the best customer? we would like to throw promotional music festival in the city we made the most money. 
-- write a sql query that return one city that has highest sum return both city name and sum of all invoice totals
SELECT billing_city, sum(total) AS invoice_total 
FROM invoice
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 1;

-- who is the best customer? the customer who has spent the most money will be declared as best customer.         
-- write a query that return the person who has spent the most money?
SELECT c.customer_id, c.first_name, c.last_name, sum(i.total) AS invoice_total 
FROM customer c  
LEFT JOIN invoice i 
ON c.customer_id = i.customer_id 
GROUP BY 1
ORDER BY 4 DESC 
LIMIT 1

-- write a query to return email, first_name, last_name and genre of all rock music listeners.
-- written you list ordered by alphabhatically by email starting with a--

SELECT DISTINCT c.first_name, c.last_name, c.email, g."name" 
FROM customer c 
LEFT JOIN invoice i 
ON c.customer_id = i.customer_id 
LEFT JOIN invoice_line il 
ON i.invoice_id = il.invoice_id 
LEFT JOIN track t 
ON il.track_id = t.track_id 
LEFT JOIN genre g 
ON t.genre_id  = g.genre_id 
WHERE g.name = 'Rock'
ORDER BY c.email ASC;

-- lets inivite the artist who have written the most rock music in our dataset. 
-- write a query that returns the artist name and total track count of top 10 rock bands
SELECT a2."name", count(t.track_id) AS total_track_count 
FROM track t 
LEFT JOIN genre g 
ON t.genre_id  = g.genre_id 
LEFT JOIN album a 
ON t.album_id = a.album_id 
LEFT JOIN artist a2 
ON a.artist_id  = a2.artist_id 
WHERE g."name" = 'Rock'
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 10;

-- Return all the track names that have a song length longer than the avergae song length.
-- return the name and milliseconds for each tarck. order by the song length with the longest songs listed fisrt.
SELECT "name", milliseconds
FROM track 
WHERE milliseconds >  
				  (select avg(milliseconds) FROM track)
ORDER BY 2 DESC 
LIMIT 1;

-- find how much amount spent by eah customer on artists?
-- write a query to return customer name, artist name and total spent
SELECT CONCAT(TRIM(first_name),' ', TRIM(last_name)) AS customer_name,
a2."name" AS artist_name, 
sum(il.unit_price* il.quantity) AS total_spent  
FROM customer c
LEFT JOIN invoice i 
ON c.customer_id = i.customer_id 
LEFT JOIN invoice_line il 
ON i.invoice_id = il.invoice_id 
LEFT JOIN track t 
ON il.track_id = t.track_id 
LEFT JOIN album a 
ON t.album_id = a.album_id 
LEFT JOIN artist a2 
ON a.artist_id = a2.artist_id 
GROUP BY 1, 2
ORDER BY 3 DESC ;

-- we want to find out the most popular music genre for each country.
-- we determine the most popular gener as the genre with the highest amount of purchases. 
-- write a query that returns each country along with the top Genre. 
-- For countries where the maximum number of purchases is shared return all genres
WITH cte AS (
SELECT g."name" AS genre_name,  i.billing_country AS country, 
count(il.quantity) AS highest_amount, ROW_NUMBER () OVER (PARTITION BY i.billing_country ORDER BY count(il.quantity) DESC) AS amount_rank
FROM invoice i 
LEFT JOIN invoice_line il 
ON i.invoice_id = il.invoice_id 
LEFT JOIN track t 
ON il.track_id = t.track_id 
LEFT JOIN genre g 
ON t.genre_id = g.genre_id 
GROUP BY 1, 2
)
SELECT genre_name, country, highest_amount, amount_rank
FROM cte 
WHERE amount_rank = 1


-- write a query that determines the customer that has spent the most on music for each country.
-- write a query that returns the country along with the top customer and how much they spent.
-- for countries where the top amount spent is shared, provide all customers who spent this amount.
WITH cte AS (
SELECT c.country AS country, 
concat(trim(c.first_name), ' ', trim(c.last_name)) AS customer_name, sum(i.total) AS spent,
ROW_NUMBER () OVER (PARTITION BY c.country ORDER BY sum(i.total) DESC) AS customer_rank
FROM customer c 
LEFT JOIN invoice i 
ON c.customer_id = i.customer_id 
GROUP BY 1,2
ORDER BY 1,2,3 DESC 
)
SELECT country, customer_name, spent
FROM cte 
WHERE customer_rank = 1






