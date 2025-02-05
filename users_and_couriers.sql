-- Расчитаем приросты числа новых пользователей (new_users_change) и новых курьеров (new_couriers_change), а также приросты общего числа пользователей (total_users_growth) и курьеров (total_couriers_growth).

SELECT date,
       new_users,
       new_couriers,
       total_users,
       total_couriers,
       new_users_change,
       new_couriers_change,
       ROUND((total_users - LAG(total_users) OVER(ORDER BY date)) * 100::DECIMAL / LAG(total_users) OVER(ORDER BY date), 2) AS total_users_growth,
       ROUND((total_couriers - LAG(total_couriers) OVER(ORDER BY date)) * 100::DECIMAL / LAG(total_couriers) OVER(ORDER BY date), 2) AS total_couriers_growth
  FROM
(SELECT t_1.date,
       n_1.new_users,
       t_1.new_couriers,
       SUM(n_1.new_users) OVER(ORDER BY t_1.date)::int AS total_users,
       SUM(t_1.new_couriers) OVER(ORDER BY t_1.date)::int AS total_couriers,
       ROUND((n_1.new_users - LAG(n_1.new_users) OVER(ORDER BY t_1.date)::int) * 100::DECIMAL / LAG(n_1.new_users) OVER(ORDER BY t_1.date), 2) AS new_users_change,
       ROUND((t_1.new_couriers - LAG(t_1.new_couriers) OVER(ORDER BY t_1.date)::int) * 100::DECIMAL / LAG(t_1.new_couriers) OVER(ORDER BY t_1.date), 2) AS new_couriers_change
  FROM 
  (SELECT COUNT(courier_id) AS new_couriers,
          date
     FROM     
(SELECT courier_id,
        MIN(time::date) AS date
   FROM courier_actions
  GROUP BY 1) t
  GROUP BY date) t_1
  JOIN 
 (SELECT COUNT(user_id) AS new_users,
         date
    FROM    
 (SELECT user_id,
         MIN(time::date) AS date
    FROM user_actions
   GROUP BY 1) n 
   GROUP BY date) n_1 ON t_1.date = n_1.date
   ORDER BY 1) q