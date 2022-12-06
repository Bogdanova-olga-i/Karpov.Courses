'Проверим, сколько товаров (events) в среднем за весь период просматривают пользователи 
с разных платформ (Platform), и пришедшие из разных источников  (Source). 
Для этого объедините таблицы events и installs, и посчитайте, 
сколько просмотров в среднем приходится на каждую пару платформа-канал привлечения.

Отсортируйте полученную табличку по убыванию среднего числа просмотров. 
В качестве ответа укажите платформу и источник, 
пользователи которого в среднем просматривали товары бóльшее число раз.'


SELECT 
    i.Platform AS Platform,
    i.Source AS Source,
    AVG(events) AS avg_events

FROM 
    events AS e
    JOIN installs AS i
    ON e.DeviceID = i.DeviceID

GROUP BY i.Platform, i.Source

ORDER BY avg_events DESC
LIMIT 10