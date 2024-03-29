# Модуль 2: Базы данных и SQL


## Загрузка данных в БД

Данные загружены через DBeaver - использовал готовые скрипты, таблицы [orders](https://github.com/yanov2708/DE-101/blob/502cb789f45ef2ea207d473c8d36fc9b2b835917/Module2/DBeaver%20scripts/Create_orders.sql), [people](https://github.com/yanov2708/DE-101/blob/502cb789f45ef2ea207d473c8d36fc9b2b835917/Module2/DBeaver%20scripts/Create_people.sql), [returns](https://github.com/yanov2708/DE-101/blob/502cb789f45ef2ea207d473c8d36fc9b2b835917/Module2/DBeaver%20scripts/Create_returns.sql).

Другие способы загрузки файла superstore.xls:
 
- Вариант 1 - вкладки из файла сохранить в CSV и импортировать его через функцию `Импорт данных` в DBeaver 

- Вариант 2 - через Python и модули: pandas, sqlalchemy.

## SQL запросы

1. Profit per Order
```sql
select o.order_id, sum(o.profit) as order_profit 
from orders o 
group by 1
order by 2 desc
```

2. Monthly Sales by Segment
```sql
select DATE_TRUNC('month', o.order_date) AS date_to_month,
	   o.segment,
       sum(o.sales) AS sales_sum
FROM orders o 
GROUP BY DATE_TRUNC('month', o.order_date), o.segment 
order by 1, 3 desc
```

3. Sales and Profit by Customer
```sql
select p.person, sum(o.sales) as sales_per_customer, sum(o.profit) as profit_per_customer  
from orders o 
left join people p on o.region = p.region 
group by p.person 
order by 3 desc 
```

4. Сumulative amount of sales by month for each category
```sql
select distinct DATE_TRUNC('month', o.order_date) AS date_to_month,
	   o.category,
	   sum(o.sales) over(partition by o.category order by DATE_TRUNC('month', o.order_date))   
from orders o 
order by 1,2	
```

## Нарисовать модель данных в SQLdbm

* Концептуальная модель

![image](https://user-images.githubusercontent.com/98317081/220677412-fde2e0a0-c227-413a-a669-ae3b80a77119.png)

* Логическая модель

![image](https://user-images.githubusercontent.com/98317081/220660251-65aed5e3-9a39-4e3a-b272-32541c3a49e0.png)

 

## Создать базу данных в облаке

Создал базу данных через AWS RDS, помог этот [туториал](https://github.com/Data-Learn/data-engineering/blob/4d4d30ecfac25e5fc9d45bc00cbf5a99e25df049/how-to/how_to_amazon_rds.md)

Далее подключился к ней через DBeaver, залил данные и сделал тестовый запрос:

![image](https://user-images.githubusercontent.com/98317081/220681818-c852c8ad-2a39-4ea9-a60a-d3980cfaba76.png)


## Подключиться к облачной базе данных через Data studio (lookerstudio)

Сначала добавил в настройках приватности базы данных пару актуальных на 2023 год ip [Data studio](https://support.google.com/looker-studio/answer/7288010?hl=en&ref_topic=7332343#zippy=%2Cin-this-article)

![image](https://user-images.githubusercontent.com/98317081/221028088-47349d0d-525c-41e0-a384-7f6722fdbe66.png)
![image](https://user-images.githubusercontent.com/98317081/221028137-425e9b70-a5a4-4c98-a4ff-e4fbacf100f8.png)

Запросом обьединил таблицы из dw schema
```sql
select * from dw.sales_fact sf
 inner join dw.shipping_dim s  on sf.ship_id = s.ship_id
 inner join dw.geo_dim g       on sf.geo_id  = g.geo_id
 inner join dw.product_dim p   on sf.prod_id = p.prod_id
 inner join dw.customer_dim cd on sf.cust_id = cd.cust_id
```

Преобразовал order_date_id в order_date и постороил дашборд + сводную таблицу
```sql
PARSE_DATE("%Y%m%d", CAST(order_date_id  AS TEXT))
```
![image](https://user-images.githubusercontent.com/98317081/230920377-22e3867c-8399-4b92-9c50-53eded457167.png)

![image](https://user-images.githubusercontent.com/98317081/221156249-6f6df192-504f-4e84-b35e-c273e11b4e5b.png)

