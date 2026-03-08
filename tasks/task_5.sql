EXPLAIN ANALYSE SELECT v.vacancy_id          "ID Вакансии",
       v.position_name    as Заголовок,
       count(response_id) as Количество
FROM vacancy as v
         JOIN response r using (vacancy_id)
WHERE r.created_at BETWEEN v.created_at AND v.created_at + interval '1 week'
GROUP BY v.vacancy_id, v.position_name
HAVING count(response_id) > 5;
