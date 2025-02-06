# Analysis_delivery_app_SQL
**Цель:** написание SQL-запросов для анализа динамики роста аудитории сервиса и ключевых продуктовых метрик. 
**Стэк:** SQL, PostgreSQL, Redash

В данном проекте реализованы сложные SQL-запросы к базе данных food delivery-сервиса с применением оконных функций, cte и подзапросов. Запросы написаны в интерфейсе платформы Redash, там же собирался финальный дашборд.
Таблицы, представленные в данных: `courier_actions` - действия курьеров, `user_actions` - действия пользователей, `users` - данные пользователей, `couriers` - данные курьеров, `products` - перечень сведений о товарах и их цене, `orders` - логи с заказами.
Схема представлена ниже:

<img src="Images/tables.png" alt="Схема таблиц" style="width: 400px; height: auto;">

С текстом запросов можно ознакомиться в соответствущих .sql файлах.

**Результаты:**  

1) Построены графики с динамикой ежедневного прироста пользователей и курьеров в абсолютных и относительных величинах

New users and couriers dynamic / change 
<div align="center">

<img src="https://github.com/savachechen/Analysis_delivery_app_SQL/blob/main/Images/new_users_and_couriers.png" width="500"> <img src="https://github.com/savachechen/Analysis_delivery_app_SQL/blob/main/Images/new_users_and_couriers_change.png" width="500"> 

</div>

Total users and couriers dynamic / change 

<img src="https://github.com/savachechen/Analysis_delivery_app_SQL/blob/main/Images/total_users_and_couriers.png" width="500"> <img src="https://github.com/savachechen/Analysis_delivery_app_SQL/blob/main/Images/total_users_and_couriers_growth.png" width="500">

2) Проанализирована динамика платящих юзеров и активных курьеров

Paying users and active couriers / share

<img src="https://github.com/savachechen/Analysis_delivery_app_SQL/blob/main/Images/paying_users_and_active_couriers.png" width="500"> <img src="https://github.com/savachechen/Analysis_delivery_app_SQL/blob/main/Images/paying_users_and_active_couriers_share.png" width="500">

3) Проанализирована динамика заказов

First orders dynamic / share 

<img src="https://github.com/savachechen/Analysis_delivery_app_SQL/blob/main/Images/orders_dynamic.png" width="500"> <img src="https://github.com/savachechen/Analysis_delivery_app_SQL/blob/main/Images/orders_dynamic_share.png" width="500">

Cancel rate per hour dynamic

<img src="https://github.com/savachechen/Analysis_delivery_app_SQL/blob/main/Images/successful_and_canceled_orders.png">

4) Проанализирована динамика основных метрик: revenue, ARPU, ARPPU, AOV (текущие и накопленные)

Daily revenue

<img src="https://github.com/savachechen/Analysis_delivery_app_SQL/blob/main/Images/revenue_change.png">

Main metrics / Running metrics

<img src="https://github.com/savachechen/Analysis_delivery_app_SQL/blob/main/Images/arpu_arppu_aov.png" width="500"> <img src="https://github.com/savachechen/Analysis_delivery_app_SQL/blob/main/Images/running_arpu_arppu_aov.png" width="500">



