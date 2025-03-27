/* 
 * A new James Bond movie will be released soon, and management wants to send promotional material to "action fanatics".
 * They've decided that an action fanatic is any customer where at least 4 of their 5 most recently rented movies are action movies.
 *
 * Write a SQL query that finds all action fanatics.
 */

WITH film_is_action AS (
  SELECT
    f.film_id,
    /* If the film has at least one category of 'Action', flag it as 1, else 0 */
    CASE WHEN MAX(CASE WHEN cat.name = 'Action' THEN 1 ELSE 0 END) = 1
         THEN 1 ELSE 0
    END AS is_action
  FROM film f
  JOIN film_category fc ON f.film_id = fc.film_id
  JOIN category cat ON fc.category_id = cat.category_id
  GROUP BY f.film_id
),
recent_rentals AS (
  SELECT
    r.customer_id,
    r.rental_date,
    fi.is_action,
    ROW_NUMBER() OVER (PARTITION BY r.customer_id ORDER BY r.rental_date DESC) AS rn
  FROM rental r
  JOIN inventory i ON r.inventory_id = i.inventory_id
  JOIN film_is_action fi ON i.film_id = fi.film_id
),
action_summary AS (
  SELECT
    customer_id,
    SUM(is_action) AS action_count
  FROM recent_rentals
  WHERE rn <= 5
  GROUP BY customer_id
)
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN action_summary a ON c.customer_id = a.customer_id
WHERE a.action_count >= 4
ORDER BY c.customer_id;
