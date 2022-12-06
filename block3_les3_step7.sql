'Самое время посмотреть 
- на общую выручку, а также 
- минимальный, 
- максимальный и 
- средний чек по источникам. 
Рассчитайте нужные показатели и соотнесите полученные значения:'

SELECT i.Source AS Source,
    SUM(Rub) AS revenue,
    MIN(Rub) AS min_check,
    MAX(Rub) AS max_check,
    AVG(Rub) AS avg_check

FROM 
    installs AS i
    JOIN devices AS d 
    ON i.DeviceID = d.DeviceID
    JOIN checks AS c 
    ON d.UserID = c.UserID
GROUP BY Source
ORDER BY Source
LIMIT 100