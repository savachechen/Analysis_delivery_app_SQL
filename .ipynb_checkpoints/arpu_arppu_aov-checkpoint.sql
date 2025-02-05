-- Расчитаем Выручку на пользователя (ARPU) за текущий день, выручку на платящего пользователя (ARPPU) за текущий день, выручку с заказа, или средний чек (AOV) за текущий день.

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
                
SELECT t.date,
       ROUND(t.revenue::DECIMAL / t_2.total_users, 2) AS arpu,
       ROUND(t.revenue::DECIMAL / t_2.paying_users, 2) AS arppu,
       ROUND(t.revenue::DECIMAL / t.total_orders, 2) AS aov
   FROM       
(SELECT date, 
        SUM(price) AS revenue,
        count(distinct order_id) AS total_orders
   FROM cte
  GROUP BY 1
  ORDER BY 1) t JOIN                
(SELECT time::date as date,
       count(distinct user_id) filter(WHERE action = 'create_order' AND order_id not in (SELECT order_id
                                                                                           FROM user_actions
                                                                                          WHERE action = 'cancel_order')) as paying_users,
       count(distinct user_id) as total_users
  FROM user_actions 
 GROUP BY 1
 ORDER BY 1) t_2 ON t.date = t_2.date