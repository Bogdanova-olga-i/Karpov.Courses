'Представим, что в логирование DeviceID в событиях закралась ошибка 
- часть ID была записана в базу некорректно. 
Это привело к тому, что в таблице с событиями появились DeviceID, 
для которых нет инсталлов. 
Нам надо отобрать примеры DeviceID из таблицы event, 
которых нет в таблице installs, чтобы отправить их команде разработчиков на исправление. 

Выведите 10 уникальных DeviceID, которые присутствуют в таблице events, 
но отсутствуют в installs, отсортировав их в порядке убывания. 
В качестве ответа введите первый DeviceID из списка.  '

SELECT 
    e.DeviceID
FROM 
    events AS e
    LEFT ANTI JOIN installs AS i 
    ON e.DeviceID = i.DeviceID
GROUP BY 
    e.DeviceID
ORDER BY 
    e.DeviceID DESC
LIMIT 10