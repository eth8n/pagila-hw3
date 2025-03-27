/*
 * Management also wants to create a "best sellers" list for each category.
 *
 * Write a SQL query that:
 * For each category, reports the five films that have been rented the most for each category.
 *
 * Note that in the last query, we were ranking films by the total amount of payments made,
 * but in this query, you are ranking by the total number of times the movie has been rented (and ignoring the price).
 */

SELECT c.name, f.title, film_rentals.rental_count as "total rentals"
FROM category c
JOIN film_category fc USING (category_id)
JOIN film f USING (film_id)
JOIN (
    SELECT f.film_id, COUNT(r.rental_id) AS rental_count
    FROM film f
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY f.film_id
) film_rentals USING (film_id)
JOIN (
    SELECT category_id, film_id,
        RANK() OVER (
            PARTITION BY category_id ORDER BY COALESCE(rental_count, 0) DESC, title DESC
        ) AS rank
    FROM film_category
    JOIN (
        SELECT f.film_id, f.title, COUNT(r.rental_id) AS rental_count
        FROM film f
        JOIN inventory i ON f.film_id = i.film_id
        JOIN rental r ON i.inventory_id = r.inventory_id
        GROUP BY f.film_id
    ) film_rentals USING (film_id)
) ranked_films USING (category_id, film_id)
WHERE ranked_films.rank <= 5
ORDER BY c.name, film_rentals.rental_count DESC, f.title;
