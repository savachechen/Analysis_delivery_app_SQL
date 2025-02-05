-- Расчитаем число доставленных заказов (successful_orders), число отменённых заказов (canceled_orders), долю отменённых заказов в общем числе заказов (cancel rate).

SELECT DATE_PART('hour', creation_time)::int AS hour,
       COUNT(order_id) FILTER(WHERE order_id IN (SELECT order_id FROM courier_actions WHERE action = 'deliver_order')) AS successful_orders,
       COUNT(order_id) FILTER(WHERE order_id IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')) AS canceled_orders,
       ROUND(COUNT(order_id) FILTER(WHERE order_id IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order'))::DECIMAL / COUNT(order_id), 3) AS cancel_rate
  FROM orders
 GROUP BY 1
 ORDER BY 1