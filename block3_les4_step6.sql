'Сгруппируйте данные из listings по хозяевам (host_id) и посчитайте, 
какую цену за ночь в среднем каждый из них устанавливает 
(у одного хоста может быть несколько объявлений). 
Идентификаторы сдаваемого жилья объедините в отдельный массив. 
Таблицу отсортируйте по убыванию средней цены и убыванию host_id (в таком порядке). 
В качестве ответа укажите первый массив в результирующей таблице, 
состоящий более чем из двух id.'

SELECT 
    host_id,
    AVG(toDecimal32OrNull(replaceRegexpAll(price, '[$,]', ''), 2)) AS avg_price,
    groupArray(id)
FROM
   listings
GROUP BY 
    host_id
ORDER BY 
    avg_price DESC,
    host_id DESC
LIMIT 20