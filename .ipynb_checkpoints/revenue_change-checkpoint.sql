-- Расчитаем выручку, полученную в этот день(revenue), суммарную выручку на текущий день (total_revenue), прирост выручки, полученной в этот день, относительно значения выручки за предыдущий день (revenue_change).

WITH cte AS (SELECT o.date,
                     o.product_id,
                     o.order_id,
                     p.price
                FROM       
             (SELECT creation_time::date AS date,
                     UNNEST(product_ids) AS product_id,
                     order_id  
                FROM orders
               WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')) o
                JOIN products p ON o.product_id = p.product_id)

 SELECT date,
        revenue,
        SUM(revenue) OVER(ORDER BY date) AS total_revenue,
        ROUND((revenue - LAG(revenue) OVER(ORDER BY date))::DECIMAL * 100 / LAG(revenue) OVER(ORDER BY date) , 2) AS revenue_change
   FROM       
(SELECT date, 
        SUM(price) AS revenue
   FROM cte
  GROUP BY 1
  ORDER BY 1) t