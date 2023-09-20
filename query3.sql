/* Who are the top 5 paying customers in 2007, and what was the amount
 of their monthly payments?
*/
WITH top5
AS (SELECT customer_id,
          sum(amount)
   FROM payment p
   WHERE date_part('year', p.payment_date)='2007'
   GROUP BY 1
   ORDER BY 2 DESC
   LIMIT 5)

SELECT date_part('month', p.payment_date) AS pay_month,
       concat(c.first_name, ' ', c.last_name) AS customer_name,
       sum(p.amount) AS pay_amount
FROM payment p
JOIN top5
  ON p.customer_id=top5.customer_id
JOIN customer c
  ON top5.customer_id=c.customer_id
GROUP BY 1, 2
ORDER BY 2, 1;
