(SELECT 'Месяц с наибольшим количеством вакансий' as Заголовок,
        EXTRACT(MONTH FROM created_at)            as Месяц,
        count(*)                                  as Количество
 FROM vacancy
 GROUP BY EXTRACT(MONTH FROM created_at)
 ORDER BY Количество desc
 LIMIT 1)
UNION ALL
(SELECT 'Месяц с наибольшим количеством резюме' as Заголовок,
        EXTRACT(MONTH FROM created_at)          as Месяц,
        count(*)                                as Количество
 FROM resume
 GROUP BY EXTRACT(MONTH FROM created_at)
 ORDER BY Количество desc
 LIMIT 1);