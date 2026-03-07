SELECT region.name                                        as "Название региона",
       trunc(avg(compensation_from), 2)                   as "Среднее по начальной ставке",
       trunc(avg(compensation_to), 2)                     as "Среднее по конечной ставке",
       trunc(avg(compensation_to - compensation_from), 2) as "Среднее разницы начальной и конечной ставок"
FROM vacancy
         JOIN region using (region_id)
GROUP BY region.name
ORDER BY region.name
