'Теперь выясним, сколько всего уникальных юзеров совершили покупки в нашем приложении.

Объедините нужные таблицы, 
посчитайте число уникальных UserID для каждого источника (Source), 
и в качестве ответа укажите число пользователей, пришедших из Source_7.

Hint: checks – покупки, devices – соответствие, installs – информация об источнике.'

SELECT i.Source,
    COUNT(c.UserID) AS count_uniq_userid
FROM 
    installs AS i
    JOIN devices AS d 
    ON i.DeviceID = d.DeviceID
    JOIN (
        SELECT DISTINCT UserID
        FROM checks
    ) AS c 
    ON d.UserID = c.UserID
WHERE Source = 'Source_7'
GROUP BY Source
LIMIT 10