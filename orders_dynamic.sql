-- Расчитаем Общее число заказов (orders), число первых заказов (first_orders), число заказов новых пользователей (new_users_orders), долю первых заказов в общем числе заказов (first_orders_share), долю заказов новых пользователей в общем числе заказов (new_users_orders_share).

WITH cte AS (      
WITH first_actions AS (
    SELECT user_id,
           MIN(time::date) AS first_action_date
    FROM user_actions
    GROUP BY user_id
),
orders_in_first_day AS (
    SELECT user_id,
           time::date AS order_date,
           COUNT(order_id) AS order_count
    FROM user_actions
    WHERE action = 'create_order'
      AND order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')
    GROUP BY user_id, time::date
)
 
SELECT fa.user_id,
       fa.first_action_date AS date,
       COALESCE(o.order_count, 0) AS count
FROM first_actions fa
LEFT JOIN orders_in_first_day o ON fa.user_id = o.user_id AND fa.first_action_date = o.order_date
ORDER BY fa.user_id)

SELECT t_1.date,
       t_1.orders,
       t_2.first_orders,
       t_3.new_users_orders,
       round(t_2.first_orders * 100::decimal / t_1.orders, 2) as first_orders_share,
       round(t_3.new_users_orders * 100::decimal / t_1.orders, 2) as new_users_orders_share
  FROM (SELECT time::date as date,
               count(order_id) as orders
          FROM user_actions
         WHERE action = 'create_order'
           and order_id not in (SELECT order_id
                                  FROM user_actions
                                 WHERE action = 'cancel_order')
         GROUP BY 1
         ORDER BY 1) t_1 join (SELECT date::date as date,
                                      count(user_id) as first_orders
                                 FROM (SELECT user_id,
                                              min(time)::date as date
                                         FROM user_actions
                                        WHERE action = 'create_order'
                                          and order_id not in (SELECT order_id
                                                                 FROM user_actions
                                                                WHERE action = 'cancel_order')
                                GROUP BY 1) t
                                GROUP BY 1
                                ORDER BY 1) t_2
        ON t_1.date = t_2.date join (SELECT date,
                                            SUM(count)::int AS new_users_orders
                                       FROM cte
                                       GROUP BY 1
                                       ORDER BY 1) t_3
        ON t_1.date = t_3.date