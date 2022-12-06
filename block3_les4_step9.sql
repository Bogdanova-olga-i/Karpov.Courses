'В каких частях города средняя стоимость за ночь является наиболее низкой? 

Сгруппируйте данные по neighbourhood_cleansed и посчитайте среднюю цену за ночь в каждом районе. 
В качестве ответа введите название места, где средняя стоимость за ночь ниже всего.

price – цена за ночь
neighbourhood_cleansed – район/округ города'

SELECT 
    neighbourhood_cleansed,
    AVG(toDecimal32OrNull(replaceRegexpAll(price, '[$,]', ''), 2)) AS avg_room_price
FROM 
    listings
GROUP BY 
    neighbourhood_cleansed
ORDER BY avg_room_price
LIMIT 20