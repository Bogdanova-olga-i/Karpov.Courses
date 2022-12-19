'InvoiceNo – номер транзакции
StockCode – код товара
Description – описание товара
Quantity – количество единиц товара, добавленных в заказ
InvoiceDate – дата транзакции 
UnitPrice – цена за единицу товара
CustomerID – id клиента
Country – страна, где проживает клиент'
-- step 11
'Построить дашборд для отдела продаж на основании таблицы retail'

"Допустим сегодня - дата последнего заказа в таблице (last date)"

-- 1) график: дневная выручка за последние 3 месяца
--(общая и по странам, у которых > 100 заказов в год от сегодняшней даты)
WITH 
-- определяем дату последнего заказа
( 
    SELECT 
        MAX(toStartOfDay(InvoiceDate)) AS last_date 
    FROM default.retail   
) AS last_date,
-- ранжируем страны по количеству заказов за последний год (>=1000, [100;1000), <100)
country_ranging AS (
    SELECT 
        Country,
        CASE
            WHEN uniqExact(InvoiceNo)>=1000 THEN 'frequent'
            WHEN uniqExact(InvoiceNo)>=100 AND uniqExact(InvoiceNo)<1000 THEN 'medium'
            ELSE 'rare'
        END AS frequency_range
    FROM 
        default.retail
    WHERE datediff('d',toStartOfDay(InvoiceDate), last_date) <= 365
    AND
       Quantity>0
    GROUP BY 
        Country
)
-- Таблица с общей дневной выручкой и по странам с рангом 'frequent' и 'medium'
SELECT 
    'All' AS Country,
    toStartOfDay(InvoiceDate) AS date,
    SUM (UnitPrice*Quantity) AS total_check
FROM
    default.retail
WHERE 
     datediff('d',toStartOfDay(InvoiceDate), last_date) <= 90
GROUP BY 
    toStartOfDay(InvoiceDate)
UNION ALL
SELECT 
    r.Country AS Country,
    toStartOfDay(r.InvoiceDate) AS date,
    SUM (r.UnitPrice*r.Quantity) AS total_check
FROM
    default.retail AS r
    JOIN country_ranging AS cr 
    USING(Country)
WHERE 
     frequency_range IN ['frequent', 'medium']
    AND
    datediff('d',toStartOfDay(InvoiceDate), last_date) <= 90
GROUP BY 
    r.Country,
    toStartOfDay(r.InvoiceDate)
ORDER BY date DESC
LIMIT 1000

-- 2) График: количество заказов в день за последние 3 месяца:
WITH 
-- определяем дату последнего заказа
( 
    SELECT 
        MAX(toStartOfDay(InvoiceDate)) AS last_date 
    FROM default.retail   
) AS last_date,
-- ранжируем страны по количеству заказов за последний год (>=1000, [100;1000), <100)
country_ranging AS (
    SELECT 
        Country,
        CASE
            WHEN uniqExact(InvoiceNo)>=1000 THEN 'frequent'
            WHEN uniqExact(InvoiceNo)>=100 AND uniqExact(InvoiceNo)<1000 THEN 'medium'
            ELSE 'rare'
        END AS frequency_range
    FROM 
        default.retail
    WHERE datediff('d',toStartOfDay(InvoiceDate), last_date) <= 365
        AND
        Quantity > 0
    GROUP BY 
        Country
)
-- Таблица с общим количеством заказов в день и по странам с рангом 'frequent' и 'medium'
-- !!! Здесь и далее считаем кол-во заказов при условии Quantity>0, чтобы не учитывать отмены
SELECT 
    'All' AS Country,
    toStartOfDay(InvoiceDate) AS date,
    uniqExact(InvoiceNo) AS total_invoices
FROM
    default.retail
WHERE 
    Quantity>0
    AND
    datediff('d',toStartOfDay(InvoiceDate), last_date) <= 90
GROUP BY 
    toStartOfDay(InvoiceDate)
UNION ALL
SELECT 
    r.Country AS Country,
    toStartOfDay(r.InvoiceDate) AS date,
    uniqExact(InvoiceNo) AS total_invoices
FROM
    default.retail AS r
    JOIN country_ranging AS cr 
    USING(Country)
WHERE 
    Quantity>0
    AND
    frequency_range IN ['frequent', 'medium']
    AND
    datediff('d',toStartOfDay(InvoiceDate), last_date) <= 90
GROUP BY 
    r.Country,
    toStartOfDay(r.InvoiceDate)
ORDER BY date DESC
LIMIT 1000

-- 3) График: Дневная выручка для стран с низкой частотой заказов в год (<100) 
-- в течение последней недели
WITH 
-- определяем дату последнего заказа
( 
    SELECT 
        MAX(toStartOfDay(InvoiceDate)) AS last_date 
    FROM default.retail   
) AS last_date,
-- ранжируем страны по количеству заказов за последний год (>=1000, [100;1000), <100)
country_ranging AS (
    SELECT 
        Country,
        CASE
            WHEN uniqExact(InvoiceNo)>=1000 THEN 'frequent'
            WHEN uniqExact(InvoiceNo)>=100 AND uniqExact(InvoiceNo)<1000 THEN 'medium'
            ELSE 'rare'
        END AS frequency_range
    FROM 
        default.retail
    WHERE 
        datediff('d',toStartOfDay(InvoiceDate), last_date) <= 365
        AND
        Quantity > 0
    GROUP BY 
        Country
)
-- Считаем дневную выручку для стран с низкой частотой заказов в год
SELECT 
    r.Country AS Country,
    toStartOfDay(r.InvoiceDate) AS date,
    SUM (r.UnitPrice*r.Quantity) AS total_check
FROM
    default.retail AS r
    JOIN country_ranging AS cr 
    USING(Country)
WHERE 
    frequency_range = 'rare'
    AND
    datediff('d',toStartOfDay(InvoiceDate), last_date) <= 7
GROUP BY 
    r.Country,
    toStartOfDay(r.InvoiceDate)
ORDER BY date DESC

-- 4)График: Количество заказов в день для стран с низкой частотой заказов в год (<100)
WITH 
-- определяем дату последнего заказа
( 
    SELECT 
        MAX(toStartOfDay(InvoiceDate)) AS last_date 
    FROM default.retail   
) AS last_date,
-- ранжируем страны по количеству заказов за последний год (>=1000, [100;1000), <100)
country_ranging AS (
    SELECT 
        Country,
        CASE
            WHEN uniqExact(InvoiceNo)>=1000 THEN 'frequent'
            WHEN uniqExact(InvoiceNo)>=100 AND uniqExact(InvoiceNo)<1000 THEN 'medium'
            ELSE 'rare'
        END AS frequency_range
    FROM 
        default.retail
    WHERE 
        datediff('d',toStartOfDay(InvoiceDate), last_date) <= 365
        AND
        Quantity > 0
    GROUP BY 
        Country
)
-- Считаем количество заказов в день для стран с низкой частотой заказов в год
SELECT 
    r.Country AS Country,
    toStartOfDay(r.InvoiceDate) AS date,
    uniqExact(InvoiceNo) AS total_invoices
FROM
    default.retail AS r
    JOIN country_ranging AS cr 
    USING(Country)
WHERE 
    Quantity>0
    AND
    frequency_range = 'rare'
    AND
    datediff('d',toStartOfDay(InvoiceDate), last_date) <= 7
GROUP BY 
    r.Country,
    toStartOfDay(r.InvoiceDate)
ORDER BY date DESC


-- 5)Таблица: Создаем "Alert" по общей дневной выручке и количеству заказов в день, 
-- а также странам с рангом 'frequent' и 'medium', 
-- который показывает что последняя выручка вышла за пределы 2 сигмы от средней выручки за месяц
-- учитываем недельную периодичность (будни и выходные)

WITH 
-- определяем дату последнего заказа
( 
    SELECT 
        MAX(toStartOfDay(InvoiceDate)) AS last_date 
    FROM default.retail   
) AS last_date,
-- ранжируем страны по количеству заказов за последний год (>=1000, [100;1000), <100)
country_ranging AS (
    SELECT 
        Country,
        CASE
            WHEN uniqExact(InvoiceNo)>=1000 THEN 'frequent'
            WHEN uniqExact(InvoiceNo)>=100 AND uniqExact(InvoiceNo)<1000 THEN 'medium'
            ELSE 'rare'
        END AS frequency_range
    FROM 
        default.retail
    WHERE datediff('d',toStartOfDay(InvoiceDate), last_date) <= 365
        AND
        Quantity > 0
    GROUP BY 
        Country
),
-- считаем дневную выручку и количество заказов в день за каждый день последнего месяца, 
-- кроме последнего дня
all_day_revenue_30_days AS (
    -- общую дневную выручку и количество заказов в день
    SELECT
        'All' AS Country, 
        toStartOfDay(InvoiceDate) AS date,
        SUM (UnitPrice*Quantity) AS total_check,
        uniqExactIf(InvoiceNo, Quantity>0) AS total_invoices
    FROM
        default.retail
    WHERE     
        datediff('d',toStartOfDay(InvoiceDate), last_date) IN range(1,32)
    GROUP BY 
        toStartOfDay(InvoiceDate)
    -- объединяем с дневной выручкой по странам с высокой частотой заказов в год
    UNION ALL
    SELECT
        r.Country AS Country, 
        toStartOfDay(r.InvoiceDate) AS date,
        SUM (r.UnitPrice*r.Quantity) AS total_check,
        uniqExactIf(InvoiceNo, Quantity>0) AS total_invoices
    FROM
        default.retail AS r
        JOIN country_ranging AS cr 
        USING(Country)
    WHERE 
        datediff('d',toStartOfDay(r.InvoiceDate), last_date) IN range(1,32)
        AND
        cr.frequency_range = 'frequent'
    GROUP BY 
        r.Country,
        toStartOfDay(r.InvoiceDate)
),
-- сортируем дни на выходные и будни
sort_weekend_weekday AS (
    SELECT 
        Country,
        date,
        total_check,
        total_invoices,
        CASE 
            WHEN toDayOfWeek(date)<=5 THEN 'weekday'
            ELSE 'weekend'
        END AS day_type
    FROM 
        all_day_revenue_30_days
),
-- считаем среднее и стандартное отклонение для общей дневной выручки аггрегируя по типу дня и стране
all_stdev_mean AS (
    SELECT 
        Country,
        day_type,
        AVG(total_check) AS mean_30_day_check,
        stddevPop(total_check) AS st_dev_check,
        AVG(total_invoices) AS mean_30_day_invoices,
        stddevPop(total_invoices) AS st_dev_invoices
    FROM 
        sort_weekend_weekday
    GROUP BY 
        Country,
        day_type
),
-- считаем выручку и количество заказов в последний день и определяем тип дня
revenue_last_day_type AS (
    -- считаем общую выручку и количество заказов в последний день
    SELECT 
        'All' AS Country, 
        toStartOfDay(InvoiceDate) AS date,
        SUM (UnitPrice*Quantity) AS last_day_total_check,
        uniqExactIf(InvoiceNo, Quantity>0) AS last_day_total_invoices,
        CASE 
            WHEN toDayOfWeek(date)<=5 THEN 'weekday'
            ELSE 'weekend'
        END AS day_type
    FROM
        default.retail
    WHERE        
        toStartOfDay(InvoiceDate) = last_date
    GROUP BY 
        toStartOfDay(InvoiceDate),
        day_type
    -- объединяем с дневной выручкой и количеством заказов в день по странам с высокой частотой заказов в год
    UNION ALL
    SELECT
        r.Country AS Country, 
        toStartOfDay(r.InvoiceDate) AS date,
        SUM (r.UnitPrice*r.Quantity) AS total_check,
        uniqExactIf(InvoiceNo, Quantity>0) AS last_day_total_invoices,
        CASE 
            WHEN toDayOfWeek(date)<=5 THEN 'weekday'
            ELSE 'weekend'
        END AS day_type
    FROM
        default.retail AS r
        JOIN country_ranging AS cr 
        USING(Country)
    WHERE         
        toStartOfDay(r.InvoiceDate) = last_date
        AND
        cr.frequency_range = 'frequent'
    GROUP BY 
        r.Country,
        toStartOfDay(r.InvoiceDate) 
)
-- создаем таблицу Alert
SELECT
    rld.Country AS Country,
    CASE
        WHEN toFloat64(last_day_total_check) > (mean_30_day_check + 2* st_dev_check) THEN CONCAT('Превышение!!!', ' +', toString(toInt64(toFloat64(last_day_total_check)- mean_30_day_check)))
        WHEN toFloat64(last_day_total_check) < (mean_30_day_check - 2* st_dev_check) THEN CONCAT('Падение!!!' , ' -', toString(toInt64(mean_30_day_check-toFloat64(last_day_total_check))))
        ELSE 'Да нормально!'
    END AS alert_revenue,
    CASE
        WHEN toFloat64(last_day_total_invoices) > (mean_30_day_invoices + 2* st_dev_invoices) THEN CONCAT('Превышение!!!', ' +', toString(toInt64(toFloat64(last_day_total_invoices)- mean_30_day_invoices)))
        WHEN toFloat64(last_day_total_invoices) < (mean_30_day_invoices - 2* st_dev_invoices) THEN CONCAT('Падение!!!' , ' -', toString(toInt64(mean_30_day_invoices-toFloat64(last_day_total_invoices))))
        ELSE 'Да нормально!'
    END AS alert_invoices
FROM 
    revenue_last_day_type AS rld 
    JOIN all_stdev_mean AS astd 
    ON rld.Country = astd.Country AND rld.day_type = astd.day_type

-- 6)Таблица: Собираем данные за последний день: принесшие наибольшую выручку: товары, заказчики, страны
WITH 
-- определяем дату последнего заказа
( 
    SELECT 
        MAX(toStartOfDay(InvoiceDate)) AS last_date 
    FROM default.retail   
) AS last_date
-- товар больше всего проданный по количеству
SELECT
    'item with max quantity' AS metrika, 
    Description AS name,
    toFloat64(SUM(Quantity)) AS parametr,
    toStartOfDay(InvoiceDate) AS date
FROM 
    default.retail
WHERE 
    toStartOfDay(InvoiceDate) = last_date 
GROUP BY 
    Description,
    toStartOfDay(InvoiceDate)
ORDER BY 
    parametr DESC
LIMIT 1    
UNION ALL
-- товар больше всего проданный по выручке
SELECT
    'item with max revenue' AS metrika, 
    Description AS name,
    toFloat64(SUM(Quantity*UnitPrice)) AS parametr,
    toStartOfDay(InvoiceDate) AS date
FROM 
    default.retail
WHERE 
    toStartOfDay(InvoiceDate) = last_date 
GROUP BY 
    Description,
    toStartOfDay(InvoiceDate)
ORDER BY parametr DESC
LIMIT 1
UNION ALL
-- покупатель купивший больше всего товара (по кол-ву)
SELECT
    'customer_ID with max quantity items' AS metrika, 
    concat(toString(CustomerID), ' ', Country) AS name,
    toFloat64(SUM(Quantity)) AS parametr,
    toStartOfDay(InvoiceDate) AS date
FROM 
    default.retail
WHERE 
    toStartOfDay(InvoiceDate) = last_date 
GROUP BY 
    concat(toString(CustomerID), ' ', Country),
    toStartOfDay(InvoiceDate)
ORDER BY parametr DESC
LIMIT 1
UNION ALL
-- покупатель принесший больше всего выручки
SELECT
    'customer_ID with max revenue' AS metrika, 
    concat(toString(CustomerID), ' ', Country) AS name,
    toFloat64(SUM(Quantity*UnitPrice)) AS parametr,
    toStartOfDay(InvoiceDate) AS date
FROM 
    default.retail
WHERE 
    toStartOfDay(InvoiceDate) = last_date 
GROUP BY 
    concat(toString(CustomerID), ' ', Country),
    toStartOfDay(InvoiceDate)
ORDER BY parametr DESC
LIMIT 1
UNION ALL
-- среднее значение выручки с заказа
SELECT
    'mean revenue per invoice' AS metrika,
    NULL AS name,
    toFloat64(AVG(total_check)) AS parametr,
    date
FROM (SELECT 
        toStartOfDay(InvoiceDate) AS date,
        InvoiceNo,
        SUM(Quantity*UnitPrice) AS total_check
    FROM 
        default.retail
    WHERE 
        toStartOfDay(InvoiceDate) = last_date 
    GROUP BY 
        toStartOfDay(InvoiceDate),
        InvoiceNo
    ) AS temp_table
GROUP BY date
UNION ALL
-- медианное значение выручки с заказа
SELECT
    'median revenue per invoice' AS metrika,
    NULL AS name,
    toFloat64(quantile(total_check)) AS parametr,
    date
FROM (SELECT 
        toStartOfDay(InvoiceDate) AS date,
        InvoiceNo,
        SUM(Quantity*UnitPrice) AS total_check
    FROM 
        default.retail
    WHERE 
        toStartOfDay(InvoiceDate) = last_date 
    GROUP BY 
        toStartOfDay(InvoiceDate),
        InvoiceNo
    ) AS temp_table
GROUP BY date
UNION ALL
-- среднее значение количества товаров в заказе
SELECT
    'mean item quantity per invoice' AS metrika,
    NULL AS name,
    toFloat64(AVG(total_quantity)) AS parametr,
    date
FROM (SELECT 
        toStartOfDay(InvoiceDate) AS date,
        InvoiceNo,
        SUM(Quantity) AS total_quantity
    FROM 
        default.retail
    WHERE 
        toStartOfDay(InvoiceDate) = last_date 
     GROUP BY 
        toStartOfDay(InvoiceDate),
        InvoiceNo
    ) AS temp_table
GROUP BY date
UNION ALL
-- медианное количество товаров в заказе
SELECT
    'median item quantity per invoice' AS metrika,
    NULL AS name,
    toFloat64(quantile(total_quantity)) AS parametr,
    date
FROM (SELECT 
        toStartOfDay(InvoiceDate) AS date,
        InvoiceNo,
        SUM(Quantity) AS total_quantity
    FROM 
        default.retail
    WHERE 
        toStartOfDay(InvoiceDate) = last_date 
    GROUP BY 
        toStartOfDay(InvoiceDate),
        InvoiceNo
    ) AS temp_table
GROUP BY date
 
-- 7) Отмененные заказы за сегодня:
WITH 
-- определяем дату последнего заказа
( 
    SELECT 
        MAX(toStartOfDay(InvoiceDate)) AS last_date 
    FROM default.retail   
) AS last_date
SELECT
    InvoiceNo,
    concat(toString(CustomerID), ' ', Country) AS customer_country,
    SUM(Quantity) AS total_quantity,
    SUM(Quantity*UnitPrice) AS total_check
FROM 
    default.retail
WHERE 
    toStartOfDay(InvoiceDate) = last_date 
    AND
    Quantity < 0
GROUP BY 
    InvoiceNo,
    concat(toString(CustomerID), ' ', Country)
ORDER BY total_check


