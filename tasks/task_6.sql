-- используется в task_3 в JOIN
CREATE INDEX idx_vacancy_region_id
    ON vacancy (region_id);

-- по регионам нет смысла индекс делать, т.к. их всего 70

-- ускоряю группировку по EXTRACT(MONTH FROM created_at) в task_4
CREATE INDEX idx_vacancy_created_month
    ON vacancy (EXTRACT(MONTH FROM created_at));

CREATE INDEX idx_resume_created_month
    ON resume (EXTRACT(MONTH FROM created_at));

-- в task_5 для ускорения соединения по response.vacancy_id и дальнейшей фильтрации по response.created_at
CREATE INDEX idx_response_vacancy_created
    ON response (vacancy_id, created_at);
