'Посчитайте среднее расстояние до центра города и 
выведите идентификаторы объявлений о сдаче отдельных комнат, 
для которых расстояние оказалось меньше среднего. 
Результат отсортируйте по убыванию, тем самым выбрав комнату, 
которая является наиболее удаленной от центра, 
но при этом расположена ближе, чем остальные комнаты в среднем. 

id – идентификатор объявления
host_id – идентификатор хозяина
room_type – тип жилья (Private room)
latitude – широта
longitude – долгота
52.5200 с.ш., 13.4050 в.д – координаты центра Берлина
В качестве ответа укажите идентификатор хозяина (host_id), сдающего данную комнату.'

SELECT 
    host_id,
    id,
    geoDistance(13.4050, 52.5200, toFloat32OrNull(longitude), toFloat32OrNull(latitude)) AS distance
FROM    listings
WHERE geoDistance(13.4050, 52.5200, toFloat32OrNull(longitude), toFloat32OrNull(latitude)) < (
        SELECT AVG(geoDistance(13.4050, 52.5200, toFloat32OrNull(longitude), toFloat32OrNull(latitude)))
        FROM listings
        WHERE room_type == 'Private room'
        )
    AND
    room_type == 'Private room'
ORDER BY distance DESC 
LIMIT 20

