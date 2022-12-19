'Давайте найдем в таблице calendar_summary те доступные (available='t') объявления, 
у которых число отзывов от уникальных пользователей в таблице reviews выше среднего.

NB! Для простоты будем считать, что отзыв — это уникальный посетитель на уникальное жилье, 
не учитывая возможные повторные отзывы от того же посетителя.

Для этого с помощью конструкции WITH посчитайте среднее число уникальных reviewer_id 
из таблицы reviews на каждое жильё, 
потом проведите джойн таблиц calendar_summary и reviews по полю listing_id 
(при этом из таблицы calendar_summary должны быть отобраны уникальные listing_id, 
отфильтрованные по правилу available='t'). 
Результат отфильтруйте так, чтобы остались только записи, 
у которых число отзывов от уникальных людей выше среднего.

Отсортируйте результат по возрастанию listing_id и 
в качестве ответа впишите количество отзывов от уникальных пользователей из первой строки.

Hint: для решения проблем со вложенными агрегационными функциями 
(и агрегационными функциями там, где их не ждут) как раз очень помогут подзапросы.'

WITH (
    SELECT AVG(count_reviews)AS avg_rev
    FROM (
        SELECT listing_id, COUNT(DISTINCT reviewer_id) AS count_reviews
        FROM reviews
        GROUP BY listing_id
    )
) AS avg_reviews
SELECT c.listing_id AS listing_id,
    COUNT(DISTINCT reviewer_id) AS count_reviews
FROM 
    calendar_summary AS c
    JOIN reviews AS r
    USING (listing_id)
WHERE available='t'
GROUP BY c.listing_id
HAVING COUNT(DISTINCT reviewer_id)>avg_reviews
ORDER BY listing_id
LIMIT 20
