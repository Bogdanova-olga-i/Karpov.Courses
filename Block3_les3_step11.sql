'Давайте теперь посчитаем конверсию из инсталла в просмотр с разбивкой по платформе инсталла – 
в данном случае это доля DeviceID, для которых есть просмотры, от всех DeviceID в инсталлах. 

Для этого нужно объединить таблицы installs и events так, 
чтобы получить все DeviceID инсталлов и соответствующие им DeviceID из events, 
посчитать число уникальных DeviceID инсталлов (1) и соответствующих DeviceID из events (2) и 
вычислить долю (2) от (1). 
В качестве ответа укажите значение конверсии из инсталла в просмотр на платформе ios. 

Внимание: ответ указать не в процентах, а именно в виде доли 
(т.е. не нужно домножать полученный ответ на 100). '

SELECT 
    i.Platform AS Platform,
    COUNT(DISTINCT e.DeviceID)/COUNT(DISTINCT i.DeviceID) AS conversion
FROM 
    installs AS i
    LEFT JOIN events AS e ON i.DeviceID = e.DeviceID
GROUP BY i.Platform