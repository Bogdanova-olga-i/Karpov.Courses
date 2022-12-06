'Выведите идентификаторы устройств пользователей, 
которые совершили как минимум одну покупку за последний месяц (октябрь 2019). 
Используйте сортировку по возрастанию DeviceID и укажите минимальное значение.

Hint: для извлечения месяца из даты можно использовать toMonth() или  
toStartOfMonth(), предварительно приведя BuyDate к типу date.'

SELECT
    DISTINCT DeviceID
FROM 
    devices AS d 
    JOIN checks AS c 
    ON d.UserID = c.UserID
WHERE toStartOfMonth(toDate(BuyDate)) = '2019-10-01'
ORDER BY DeviceID
LIMIT 10
