'Давайте проверим, пользователи пришедшие из какого источника 
совершили наибольшее число покупок. 
В качестве ответа выберите название Source, 
юзеры которого совершили больше всего покупок.

Hint: Для этого используйте UserID, DeviceID и Source 
из соответствующих таблиц. 
Считать уникальные значения здесь не нужно. 
Также заметьте, что покупки со стоимостью 0 рублей всё ещё 
считаются покупками.'

SELECT i.Source,
    SUM(c.num_buys) AS count_buys
FROM 
    installs AS i
    JOIN devices AS d 
    ON i.DeviceID = d.DeviceID
    JOIN (
        SELECT UserID,
            COUNT(Rub) AS num_buys
        FROM checks
        GROUP BY UserID
    ) AS c 
    ON d.UserID = c.UserID
GROUP BY Source
ORDER BY count_buys DESC 
LIMIT 10