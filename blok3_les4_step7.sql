'Немного усложним предыдущую задачу, и посчитаем разницу между максимальной 
и минимальной установленной ценой у каждого хозяина. 
В качестве ответа укажите идентификатор хоста, у которого разница оказалась наибольшей.'

SELECT 
    host_id,
    MAX(toDecimal32OrNull(replaceRegexpAll(price, '[$,]', ''), 2))-MIN (toDecimal32OrNull(replaceRegexpAll(price, '[$,]', ''), 2)) AS diff_price,
    groupArray(id)
FROM
   listings
GROUP BY 
    host_id
ORDER BY 
    diff_price DESC
LIMIT 20