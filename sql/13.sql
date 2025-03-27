/*
 * Management wants to create a "best sellers" list for each actor.
 *
 * Write a SQL query that:
 * For each actor, reports the three films that the actor starred in that have brought in the most revenue for the company.
 * (The revenue is the sum of all payments associated with that film.)
 *
 * HINT:
 * For correct output, you will have to rank the films for each actor.
 * My solution uses the `rank` window function.
 */

SELECT a.actor_id, a.first_name, a.last_name,
       f.film_id, f.title, ranked_films.rank, film_revenue.revenue
FROM actor a
JOIN film_actor fa USING (actor_id)
JOIN film f USING (film_id)
JOIN (
    	SELECT f.film_id, sum(p.amount) as revenue
        FROM film f
        JOIN inventory i on f.film_id = i.film_id
        JOIN rental r on i.inventory_id = r.inventory_id
        JOIN payment p on r.rental_id = p.rental_id
        GROUP BY f.film_id
) film_revenue USING (film_id)
JOIN (
    SELECT actor_id, film_id,
           RANK() OVER (
            PARTITION BY actor_id ORDER BY COALESCE(revenue, 0.00) DESC, film_id ASC
           ) AS rank
    FROM film_actor
    JOIN (
        SELECT f.film_id, sum(p.amount) as revenue
        FROM film f
        JOIN inventory i on f.film_id = i.film_id
        JOIN rental r on i.inventory_id = r.inventory_id
        JOIN payment p on r.rental_id = p.rental_id
        GROUP BY f.film_id
    ) film_revenue USING (film_id)
) ranked_films USING (actor_id, film_id)
WHERE ranked_films.rank <= 3
ORDER BY a.actor_id, ranked_films.rank;
