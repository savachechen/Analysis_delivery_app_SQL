-- Расчитаем накопленную выручку на пользователя (running_arpu), накопленную выручку на платящего пользователя (running_arppu), накопленную выручку с заказа, или средний чек (running_aov).

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
       ROUND(total_revenue::DECIMAL / running_total_users, 2) AS running_arpu,
       ROUND(total_revenue::DECIMAL / running_paying_users, 2) AS running_arppu,
       ROUND(total_revenue::DECIMAL / running_total_orders, 2) AS running_aov
  FROM       
(SELECT t.date,
        SUM(total_orders) OVER(ORDER BY t.date) AS running_total_orders,
        SUM(total_users) OVER(ORDER BY t.date) AS running_total_users,
        SUM(total_paying_users) OVER(ORDER BY t.date) AS running_paying_users,
        SUM(revenue) OVER(ORDER BY t.date) AS total_revenue
   FROM       
(SELECT date, 
        SUM(price) AS revenue,
        count(distinct order_id) AS total_orders
   FROM cte
  GROUP BY 1
  ORDER BY 1) t JOIN
(SELECT n_1.date,
        total_users,
        total_paying_users
   FROM       
(SELECT COUNT(user_id) AS total_users,
        date
        FROM    
 (SELECT user_id,
         MIN(time::date) AS date
    FROM user_actions
 GROUP BY 1) n 
 GROUP BY date
 ORDER BY date) n_1
 JOIN
 (SELECT COUNT(paying_users) AS total_paying_users,
         date
    FROM        
 (SELECT user_id AS paying_users,
         MIN(time::date) AS date
    FROM user_actions
    WHERE action = 'create_order' AND order_id not in (SELECT order_id
                                                         FROM user_actions
                                                        WHERE action = 'cancel_order')
 GROUP BY 1) m
 GROUP BY date
 ORDER BY date) m_1 ON n_1.date = m_1.date) t_2 ON t.date = t_2.date) t_3