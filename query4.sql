/* Out of the top 10 paying customers in 2007, who paid the maximum
difference between two consecutive months?
*/
WITH top10
AS (SELECT customer_id,
          sum(amount)
   FROM payment p
   WHERE date_part('year', p.payment_date)='2007'
   GROUP BY 1
   ORDER BY 2 DESC
   LIMIT 10)

SELECT date_part('month', p.payment_date) AS pay_month,
       concat(c.first_name, ' ', c.last_name) AS customer_name,
       sum(p.amount) AS pay_amount,
       lag(sum(p.amount)) OVER wind AS prevmon_amount,
       sum(p.amount) - lag(sum(p.amount)) OVER wind AS difference
FROM payment p
JOIN top10
  ON p.customer_id=top10.customer_id
JOIN customer c
  ON top10.customer_id=c.customer_id
GROUP BY 1, 2
WINDOW wind AS (PARTITION BY concat(c.first_name, ' ', c.last_name)
                           ORDER BY concat(c.first_name, ' ', c.last_name),
                                   date_part('month', p.payment_date))
ORDER BY 2, 1;
