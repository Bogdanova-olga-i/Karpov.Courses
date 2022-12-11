'Сначала оставьте только те объявления, 
в которых оценка на основе отзывов выше среднего, 
а число отзывов в месяц составляет строго меньше трёх. 
Затем отсортируйте по убыванию две колонки: сначала по числу отзывов в месяц, потом по оценке. 
В качестве ответа укажите id объявления из первой строки.

review_scores_rating – оценка на основе отзывов
reviews_per_month – число отзывов в месяц
id – идентификатор объявления
Таблица – listings'

SELECT 
    id, 
    reviews_per_month, 
    review_scores_rating
FROM 
    listings
WHERE 
    toFloat32OrNull(review_scores_rating) > (
        SELECT AVG(toFloat32OrNull(review_scores_rating))
        FROM listings
    ) 
    AND
    reviews_per_month < 3
ORDER BY reviews_per_month DESC, 
    toFloat32OrNull(review_scores_rating) DESC
LIMIT 20

