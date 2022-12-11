'Представим, что вы планируете снять жилье в Берлине на 7 дней, 
используя более хитрые фильтры, чем предлагаются на сайте.

В этой задаче можно потренироваться в написании подзапросов, но задание можно решить и без них.

Отберите объявления из таблицы listings, которые:

- находятся на расстоянии от центра меньше среднего
- обойдутся дешевле 100$ в день (price с учетом cleaning_fee, 
который добавляется к общей сумме за неделю, т.е его нужно делить на кол-во дней)
- имеют последние отзывы (last_review), начиная с 1 сентября 2018 года
- имеют WiFi в списке удобств (amenities)

Отсортируйте полученные значения по убыванию review_scores_rating 
(не забудьте перевести строку к численному виду) и 
в качестве ответа укажите host_id из первой строки. '

WITH (
    SELECT AVG(geoDistance(13.4050, 52.5200, toFloat64OrNull(longitude), toFloat64OrNull(latitude)))
    FROM listings
) AS avg_distance
SELECT 
    host_id,
    id, 
    toFloat64OrNull(review_scores_rating) AS review_scores_rating,
    geoDistance(13.4050, 52.5200, toFloat64OrNull(longitude), toFloat64OrNull(latitude)) AS dictance,
    toFloat64OrNull(replaceRegexpAll(price, '[$,]', ''))+ toFloat64OrNull(replaceRegexpAll(cleaning_fee, '[$,]', ''))/7 AS weekly_price
FROM 
    listings
WHERE 
    geoDistance(13.4050, 52.5200, toFloat64OrNull(longitude), toFloat64OrNull(latitude)) < avg_distance
    AND
    toFloat64OrNull(replaceRegexpAll(price, '[$,]', ''))+ toFloat64OrNull(replaceRegexpAll(cleaning_fee, '[$,]', ''))/7 < 100
    AND
    last_review > '2018-09-01'
    AND
    multiSearchAnyCaseInsensitive(amenities, ['WiFi']) > 0
ORDER BY review_scores_rating DESC
LIMIT 20 

