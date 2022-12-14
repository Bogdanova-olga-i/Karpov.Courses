'На Airbnb есть две основные группы пользователей:

Хозяева (хосты, hosts) – сдают жилье
Путешественники (travelers) – снимают
Начнем с анализа характеристик хозяев в таблице listings! 

Пользователи, сдающие квартиры на Airbnb, зарегистрировались в разное время. 
Кто-то – очень давно, а кто-то совсем недавно. 
Давайте проверим, в какой месяц и год зарегистрировалось наибольшее количество новых хостов. 
В качестве ответа введите дату следующего формата: 2010-12

host_id – идентификатор хозяина
host_since – дата регистрации как хост
Note: Сам хост может встретиться в таблице несколько раз, если сдает несколько помещений, 
поэтому не забудьте оставить уникальные значения host_id. 
Также обратите внимание на тип данных в host_since, 
возможно вам пригодится toStartOfMonth() для извлечения части даты и 
toDateOrNull() для обработки пустых значений.'

SELECT
    toStartOfMonth(toDateOrNull(host_since)) AS registration_date,
    COUNT(DISTINCT host_id) AS host_quantity
FROM listings
GROUP BY toStartOfMonth(toDateOrNull(host_since))
ORDER BY host_quantity DESC
LIMIT 50
