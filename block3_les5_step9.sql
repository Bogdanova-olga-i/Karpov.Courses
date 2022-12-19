'Теперь задача! Используйте таблицу checks и разделите всех покупателей на сегменты:

NB! Правые границы берутся не включительно, например, чек в 10 рублей будет относиться к сегменту С

А — средний чек покупателя менее 5 ₽
B — средний чек покупателя от 5-10 ₽
C — средний чек покупателя от 10-20 ₽
D — средний чек покупателя от 20 ₽

Отсортируйте результирующую таблицу по возрастанию UserID 
и укажите сегмент четвертого пользователя.'

SELECT UserID,
    AVG(Rub) AS avg_check,
    CASE 
        WHEN AVG(Rub)<5 THEN 'A'
        WHEN AVG(Rub)>=5 AND AVG(Rub)<10 THEN 'B'
        WHEN AVG(Rub)>=10 AND AVG(Rub)<20 THEN 'C'
        WHEN AVG(Rub)>=20 THEN 'D'
    END AS segment
FROM checks
GROUP BY UserID
ORDER BY UserID
LIMIT 20
