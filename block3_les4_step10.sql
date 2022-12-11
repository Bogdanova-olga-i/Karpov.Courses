'В каких районах Берлина средняя площадь жилья, 
которое сдаётся целиком, 
является наибольшей? 
Отсортируйте по среднему и выберите топ-3. 

neighbourhood_cleansed – район
square_feet – площадь
room_type – тип (нужный – Entire home/apt)'

SELECT 
    neighbourhood_cleansed,
    AVG(toDecimal32OrNull(square_feet, 2)) AS avg_area
FROM 
    listings
WHERE room_type = 'Entire home/apt' AND city = 'Berlin'
GROUP BY 
    neighbourhood_cleansed
ORDER BY avg_area DESC
LIMIT 20