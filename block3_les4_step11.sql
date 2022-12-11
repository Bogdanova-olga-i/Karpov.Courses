'давайте посмотрим, какая из представленных комнат расположена ближе всего к центру города. В качестве ответа укажите id объявления.

id – идентификатор жилья (объявления)
room_type – тип жилья (Private room)
latitude – широта
longitude – долгота
52.5200 с.ш., 13.4050 в.д – координаты центра Берлина'

SELECT 
    id,
    geoDistance(13.4050, 52.5200, toFloat64OrNull(longitude), toFloat64OrNull(latitude)) AS distance 
FROM
    listings
WHERE 
    room_type = 'Private room'
ORDER BY 
    distance
