//1 // Create a query that lists each movie, the film category //
//it is classified in, and the number of times it has been rented out.//

SELECT f.title film_title,
      c.name category_name,
       COUNT(*) rental_count
FROM rental r
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film f
ON i.film_id = f.film_id
JOIN film_category fc
ON fc.film_id = f.film_id
JOIN category c
ON fc.category_id = c.category_id
GROUP BY 1,2
ORDER BY 2,1



//2// provide a table with the movie titles and divide them into 4 levels
//(first_quarter, second_quarter, third_quarter, and final_quarter)
//based on the quartiles (25%, 50%, 75%) of the rental duration
//for movies across all categories

SELECT f.title,
       c.name,
       f.rental_duration,
       NTILE(4) OVER(ORDER BY f.rental_duration) AS standard_quartile
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN film f
ON f.film_id = fc.film_id
WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')



//3// provide a table with the family-friendly film category,
// each of the quartiles, and the corresponding count of movies within
// each combination of film category for each corresponding rental duration category.

WITH tab1 AS (
SELECT f.title, c.name AS category,         f.rental_duration,
NTILE(4) OVER(ORDER BY f.rental_duration) AS standard_quartile
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN film f
ON f.film_id = fc.film_id
WHERE c.name IN ('Animation','Children','Classics','Comedy', 'Family', 'Music'))
SELECT category, standard_quartile, COUNT(*)
FROM tab1
GROUP BY 1, 2
ORDER BY 1, 2



//4// Write a query that returns the store ID for the store,
// the year and month and the number of rental orders
// each store has fulfilled for that month.

SELECT DATE_PART('MONTH',rental_date) rental_month, DATE_PART('YEAR',rental_date) rental_year, s.store_id, count(*) count_rentals
FROM rental r
JOIN customer c
ON r.customer_id = c.customer_id
JOIN address a
ON a.address_id = c.address_id
FULL OUTER JOIN store s
ON s.address_id = a.address_id
GROUP BY 1,2,3
ORDER BY 4
