/* Compare the number of movies within each combination of family-friendly
 categories based on rental duration category.
*/
WITH t1
AS (SELECT
  f.title,
  c.name,
  f.rental_duration,
  NTILE(4) OVER
  (ORDER BY f.rental_duration) AS rental_length_category
FROM film f
JOIN film_category fc
  ON f.film_id = fc.film_id
JOIN category c
  ON fc.category_id = c.category_id
  AND c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music'))

SELECT
  t1.name AS movie_category,
  t1.rental_length_category,
  COUNT(*)
FROM t1
GROUP BY 1, 2
ORDER BY 1, 2;
