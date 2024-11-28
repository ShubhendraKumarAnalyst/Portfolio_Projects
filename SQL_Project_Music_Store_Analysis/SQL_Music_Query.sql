
/* Question Set 1

 Question 1: Who is the senior most employee based on job title?*/

SELECT *
from employee
order by levels desc
LIMIT 1;

/* Question 2:Which countries have the most Invoices?*/
select count(*) as count , billing_country
from invoice
group by billing_country 
order by count desc;

/*Question #: What are top 3 values of total invoice?*/

select total
from invoice
order by total desc
limit 3;

/*Question 4: Which city has the best customers? We would like to throw a promotional Music 
Festival in the city we made the most money. Write a query that returns one city that 
has the highest sum of invoice totals. Return both the city name & sum of all invoice 
totals*/

select billing_city, sum(total) as invoice_total
from invoice
group by billing_city
order by invoice_total desc
limit 1;

/* Question 5: Who is the best customer? The customer who has spent the most money will be 
declared the best customer. Write a query that returns the person who has spent the 
most money*/
select *
from invoice;

select *
from customer;

select customer.first_name,customer.last_name,sum(invoice.total) as total_invoice
from invoice
join customer
	on invoice.customer_id = customer.customer_id
group by customer.first_name,customer.last_name
order by total_invoice desc
limit 1;

/* Question Set 2
Question 1: Write query to return the email, first name, last name, & Genre of all Rock Music 
listeners. Return your list ordered alphabetically by email starting with A.*/

select *
from customer;

select *
from album;

select *
from track;

select *
from genre;

select *
from invoice_line;

select customer.first_name,customer.last_name,customer.email,genre.name
from track
join genre
	on track.genre_id = genre.genre_id
join invoice_line
	on invoice_line.track_id = track.track_id
join invoice
	on invoice.invoice_id = invoice_line.invoice_id
join customer
	on customer.customer_id = invoice.customer_id
where genre.name = 'Rock'
order by customer.email asc;

/* Question 2: Let's invite the artists who have written the most rock music in our dataset. Write a 
query that returns the Artist name and total track count of the top 10 rock bands*/

select *
from artist;

select artist.artist_id, artist.name, count(artist.artist_id) as total_track_count
from track
join album
	on album.album_id = track.album_id
join artist
	on artist.artist_id = album.artist_id
join genre
	on genre.genre_id = track.genre_id
where genre.name like 'Rock'
group by `count(artist.name)`
order by total_track_count desc;

/* Question 3:  Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the 
longest songs listed first.*/

select track_id,name,milliseconds
from track
where milliseconds > (
select avg(milliseconds) as avg_length
from track
)
order by milliseconds desc;

/*Question Set 3
Question 1: Find how much amount spent by each customer on artists? Write a query to return
customer name, artist name and total spent*/select *
from invoice;

WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;


/* Question 2: We want to find out the most popular music Genre for each country. We determine the 
most popular genre as the genre with the highest amount of purchases. Write a query 
that returns each country along with the top Genre. For countries where the maximum 
number of purchases is shared return all Genres.*/

with popular_genre as
(
select count(invoice_line.quantity) purchases, customer.country, genre.name, genre.genre_id,
	row_number() over(partition by customer.country order by COUNT(invoice_line.quantity) DESC) as row_num
from invoice_line
	join invoice on invoice.invoice_id = invoice_line.invoice_id
	join customer on customer.customer_id = invoice.customer_id
	join track on track.track_id = invoice_line.track_id
	join genre on track.genre_id = genre.genre_id
	group by 2,3,4
	order by purchases asc 
)
select * 
from popular_genre
where row_num <=1
;

/*Question 3: Write a query that determines the customer that has spent the most on music for each 
country. Write a query that returns the country along with the top customer and how
much they spent. For countries where the top amount spent is shared, provide all 
customers who spent this amount*/


with top_customer_country as
(
select customer.customer_id, customer.first_name, customer.last_name,billing_country, sum(total) as total_spent, 
	row_number() over(partition by billing_country order by sum(total) DESC) as row_num
from invoice
	join customer on customer.customer_id = invoice.customer_id
	group by 1,2,3,4
	order by 4,5 desc 
)
select * 
from top_customer_country
where row_num <=1
;

/*https://www.linkedin.com/in/shubhendrakumar/*/
/*I am an enthusiastic Data Analyst */
/*Thank You */
