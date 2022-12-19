'Используйте предыдущий запрос как подзапрос и посчитайте, 
сколько клиентов приходится на каждый сегмент и 
сколько доходов он приносит. 
Отсортируйте результат по убыванию суммы доходов на сегмент и 
в качестве ответа укажите наибольшую сумму.'

SELECT 
    segment,
    SUM(sum_check) AS segment_revenue
FROM 
    (
    SELECT 
        UserID,
        SUM(Rub) AS sum_check,
        CASE 
            WHEN AVG(Rub)<5 THEN 'A'
            WHEN AVG(Rub)>=5 AND AVG(Rub)<10 THEN 'B'
            WHEN AVG(Rub)>=10 AND AVG(Rub)<20 THEN 'C'
            WHEN AVG(Rub)>=20 THEN 'D'
        END AS segment
    FROM checks
    GROUP BY UserID
    )
GROUP BY segment
ORDER BY segment_revenue DESC
LIMIT 20