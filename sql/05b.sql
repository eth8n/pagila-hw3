/*
 * Write a SQL query that lists the title of all movies where at least 2 actors were also in 'AMERICAN CIRCUS'.
 */

SELECT f.title
FROM film_actor AS fa1
JOIN film_actor AS fa2 ON fa1.actor_id = fa2.actor_id
JOIN film AS f ON fa2.film_id = f.film_id
WHERE fa1.film_id = (SELECT film_id FROM film WHERE title = 'AMERICAN CIRCUS')
GROUP BY f.title
HAVING COUNT(DISTINCT fa2.actor_id) >= 2
ORDER BY f.title;
