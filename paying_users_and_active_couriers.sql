-- Расчитаем число платящих пользователей (paying_users) и число активных курьеров (active_couriers), а также долю платящих пользователей в общем числе пользователей на текущий день (paying_users_share) и долю активных курьеров в общем числе курьеров на текущий день (active_couriers_share).

SELECT t_3.date,
        t_3.paying_users,
        t_4.active_couriers,
        ROUND(t_3.paying_users * 100::DECIMAL / m.total_users, 2) AS paying_users_share,
        ROUND(t_4.active_couriers * 100::DECIMAL / m.total_couriers, 2) AS active_couriers_share
   FROM       
(SELECT time::date AS date,
        COUNT(DISTINCT user_id) FILTER(WHERE action = 'create_order') AS paying_users,
        COUNT(DISTINCT user_id) AS total_users
   FROM user_actions
  WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order') 
  GROUP BY 1
  ORDER BY 1) t_3
   JOIN
(SELECT time::date AS date,
        COUNT(DISTINCT courier_id) FILTER(WHERE action = 'accept_order' OR order_id IN (SELECT order_id FROM courier_actions WHERE action = 'deliver_order')) AS active_couriers,
        COUNT(DISTINCT courier_id) AS total_couriers
   FROM courier_actions
  WHERE order_id IN (SELECT order_id FROM courier_actions WHERE action = 'deliver_order')
  GROUP BY 1
  ORDER BY 1) t_4
     ON t_3.date = t_4.date
   JOIN 
(SELECT t_1.date,
        n_1.new_users,
        t_1.new_couriers,
        sum(n_1.new_users) OVER(ORDER BY t_1.date)::int as total_users,
        sum(t_1.new_couriers) OVER(ORDER BY t_1.date)::int as total_couriers
   FROM (SELECT count(courier_id) as new_couriers,
                date
           FROM (SELECT courier_id,
                        min(time::date) as date
                   FROM courier_actions
                  GROUP BY 1) t
          GROUP BY date) t_1 join (SELECT count(user_id) as new_users,
                                          date
                         FROM   (SELECT user_id,
                                        min(time::date) as date
                                 FROM   user_actions
                                 GROUP BY 1) n
                         GROUP BY date) n_1
        ON t_1.date = n_1.date
  ORDER BY 1) m ON t_3.date = m.date