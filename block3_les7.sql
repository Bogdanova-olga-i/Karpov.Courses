" следующих шагах используется default.retail – данные о транзакциях британского интернет-магазина в период с 1 декабря 2010 по 9 декабря 2011, где:

InvoiceNo – номер транзакции
StockCode – код товара
Description – описание товара
Quantity – количество единиц товара, добавленных в заказ
InvoiceDate – дата транзакции 
UnitPrice – цена за единицу товара
CustomerID – id клиента
Country – страна, где проживает клиент"

-- step 4
'Следующая задача – посмотреть на динамику изменения числа активных пользователей в месяц 
в Великобритании, Австралии и Нидерландах. 
Полученная вами результирующая таблица должна иметь вид: 
страна - число уникальных пользователей за определённый месяц.

MAU (monthly active users) – число уникальных пользователей за месяц. 
Активные пользователи – те, кто сделал хотя бы один заказ за выбранный промежуток времени (месяц).
В качестве ответа укажите наименьшее число пользователей за февраль 2011. '

SELECT 
    Country,
    toStartOfMonth(InvoiceDate) AS date,
    uniqExact(CustomerID) AS uniq_users_per_month
FROM 
    default.retail
WHERE Country IN ['United Kingdom', 'Netherlands', 'Australia']
GROUP BY Country,
    toStartOfMonth(InvoiceDate)

-- step 5
'Давайте посмотрим на динамику изменения 
числа активных пользователей в месяц уже для всех стран, кроме Великобритании. '

SELECT 
    Country,
    toStartOfMonth(InvoiceDate) AS date,
    uniqExact(CustomerID) AS uniq_users_per_month
FROM 
    default.retail
WHERE Country <> 'United Kingdom'
GROUP BY Country,
    toStartOfMonth(InvoiceDate)

-- step 6
'Теперь проанализируем сами заказы. 
Посчитайте среднюю сумму заказа (AOV – average order value) в каждой из стран.'

SELECT 
    Country,
    AVG(total_check) AS mean_check
FROM 
    (
    SELECT 
        Country,
        InvoiceNo,
        SUM (UnitPrice*Quantity) AS total_check
    FROM
        default.retail
    WHERE Quantity>0
    GROUP BY 
        Country,
        InvoiceNo
)
GROUP BY Country
ORDER BY mean_check DESC

-- step 7
'Как изменялась средняя сумма заказа в разных странах по месяцам?

Предположим, нас интересует динамика в следующих странах: 
United Kingdom, Germany, France, Spain, Netherlands, Belgium, Switzerland, Portugal, Australia, USA. 
Визуализируйте результат и выберите верные утверждения.'


SELECT 
    Country,
    toStartOfMonth(InvoiceDate) AS date,
    AVG(total_check) AS mean_check
FROM 
    (
    SELECT 
        Country,
        InvoiceNo,
        InvoiceDate,
        SUM (UnitPrice*Quantity) AS total_check
    FROM
        default.retail
    WHERE Quantity>0
        AND 
        Country IN ['United Kingdom', 'Germany', 'France', 'Spain', 'Netherlands', 'Belgium', 'Switzerland', 'Portugal', 'Australia', 'USA']
    GROUP BY 
        Country,
        InvoiceNo,
        InvoiceDate
)
GROUP BY Country, toStartOfMonth(InvoiceDate)
ORDER BY date

-- step 8
'Сколько товаров пользователи обычно добавляют в корзину? 
Посчитайте среднее количество товаров, добавленных в корзину, с разбивкой по странам. '

SELECT 
    Country,
    AVG(total_quant) AS mean_quant
FROM 
    (
    SELECT 
        Country,
        InvoiceNo,
        SUM (Quantity) AS total_quant
    FROM
        default.retail
    WHERE Quantity>0
    GROUP BY 
        Country,
        InvoiceNo
)
GROUP BY Country
ORDER BY mean_quant DESC

-- step 9
'Возможно, результат на предыдущем шаге показался вам странным, 
особенно если соотнести средний размер корзины с числом уникальных пользователей 
в некоторых странах. 

Посмотрим на Нидерланды (Netherlands) более подробно. 
Сгруппируйте данные по пользователям и посмотрите, кто купил наибольшее число товаров. 
В ответе укажите идентификатор данного пользователя. '

SELECT
    CustomerID,
    SUM(Quantity) AS sum_quant
FROM 
    default.retail
WHERE 
    Country = 'Netherlands'
    AND 
    Quantity>0
GROUP BY 
    CustomerID
ORDER BY 
    sum_quant DESC

-- step 10
'Один из пользователей (CustomerID = 14646) добавил к себе в корзину почти 200 тысяч товаров. 
Не кажется ли это подозрительным? 
Изучите, что именно он покупает, посмотрите на количество товаров в каждом заказе, итоговые суммы. 
Подумайте, кто или что это может быть
'
SELECT
    StockCode,
    Description,
    SUM(Quantity) AS sum_quant
FROM
    default.retail
WHERE 
    CustomerID = 14646
GROUP BY 
    StockCode,
    Description
ORDER BY 
    sum_quant DESC

