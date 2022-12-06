'Теперь сгруппируйте данные по типу жилья и 
выведите средние значения цены за ночь, 
размера депозита и 
цены уборки. 

Обратите внимание на тип данных, 
наличие значка $ и запятых в больших суммах. 
Для какого типа жилья среднее значение залога наибольшее?

room_type – тип сдаваемого жилья 
price – цена за ночь
security_deposit – залог за сохранность имущества
cleaning_fee – плата за уборку'

SELECT 
    room_type,
    AVG(toDecimal32OrNull(replaceRegexpAll(price, '[$,]', ''), 2)) AS avg_room_price,
    AVG(toDecimal32OrNull(replaceRegexpAll(security_deposit, '[$,]', ''), 2)) AS avg_secur_dep,
    AVG(toDecimal32OrNull(replaceRegexpAll(cleaning_fee, '[$,]', ''), 2)) AS avg_cleaning_fee
FROM 
    listings
GROUP BY 
    room_type
ORDER BY avg_secur_dep DESC