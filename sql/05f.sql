/* 
 * Finding movies with similar categories still gives you too many options.
 *
 * Write a SQL query that lists all movies that share 2 categories with AMERICAN CIRCUS and 1 actor.
 *
 * HINT:
 * It's possible to complete this problem both with and without set operations,
 * but I find the version using set operations much more intuitive.
 */

(
  SELECT f.title
  FROM film f
  JOIN film_category fc ON f.film_id = fc.film_id
  WHERE fc.category_id IN (
      SELECT category_id
      FROM film_category
      WHERE film_id = (SELECT film_id FROM film WHERE title = 'AMERICAN CIRCUS')
  )
  GROUP BY f.title
  HAVING COUNT(DISTINCT fc.category_id) >= 2
)
INTERSECT
(
  SELECT f.title
  FROM film f
  JOIN film_actor fa ON f.film_id = fa.film_id
  WHERE fa.actor_id IN (
      SELECT actor_id
      FROM film_actor
      WHERE film_id = (SELECT film_id FROM film WHERE title = 'AMERICAN CIRCUS')
  )
  GROUP BY f.title
  HAVING COUNT(DISTINCT fa.actor_id) >= 1
)
ORDER BY title;

