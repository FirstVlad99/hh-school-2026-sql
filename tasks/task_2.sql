WITH test_data(name) AS (SELECT md5(random()::text) as name
                         FROM generate_series(1, 70))
INSERT
INTO region(name)
SELECT name
FROM test_data;

WITH test_data(name,
               phone_number,
               created_at,
               region_id) AS (SELECT DISTINCT md5(random()::text)                                           as name,
                                              to_char(random() * 10000000000, 'FM"7("000") "000"-"00"-"00') as phone_number,
                                              timestamp '2023-01-01' + (random() * interval '3 years')      as created_at,
                                              -- получаю случайные id из отрезка [min,min + idsCount]
                                              -- могу позволить такое, потому что id для регионов сгенерированы последовательно, без пропусков
                                              (SELECT min(region_id) FROM region) +
                                              trunc(random() * (SELECT count(region_id) FROM region))::int  as region_id
                              FROM generate_series(1, 1000))
INSERT
INTO employer(name, phone_number, created_at, region_id)
SELECT name, phone_number, created_at, region_id
FROM test_data;

WITH test_data(first_name,
               second_name,
               middle_name,
               birth_date,
               phone_number,
               created_at,
               region_id) AS (SELECT md5(random()::text)                                           as first_name,
                                     md5(random()::text)                                           as second_name,
                                     md5(random()::text)                                           as middle_name,
                                     -- до 2008 года (от 17 лет)
                                     date '1956-01-01' + (random() * interval '52 years')          as birth_date,
                                     to_char(random() * 10000000000, 'FM"7("000") "000"-"00"-"00') as phone_number,
                                     timestamp '2023-01-01' + (random() * interval '3 years')      as created_at,
                                     -- получаю случайные id из отрезка [min,min + idsCount]
                                     -- могу позволить такое, потому что id для регионов сгенерированы последовательно, без пропусков
                                     (SELECT min(region_id) FROM region) +
                                     trunc(random() * (SELECT count(region_id) FROM region))::int  as region_id
                              FROM generate_series(1, 1000))
INSERT
INTO applicant(first_name, second_name, middle_name, birth_date, phone_number, created_at, region_id)
SELECT first_name, second_name, middle_name, birth_date, phone_number, created_at, region_id
FROM test_data;

WITH test_data(position_name,
               compensation_from,
               created_at,
               employer_id,
               region_id) AS (SELECT md5(random()::text)                                              as position_name,
                                     30000 + trunc(random() * 100000)                                 as compensation_from,
                                     timestamp '2023-01-01' + (random() * interval '3 years')         as created_at,
                                     -- получаю случайные id из отрезка [min,min + idsCount]
                                     -- могу позволить такое, потому что id для работадателей сгенерированы последовательно, без пропусков
                                     (SELECT min(employer_id) FROM employer) +
                                     trunc(random() * (SELECT count(employer_id) FROM employer))::int as employer_id,
                                     (SELECT min(region_id) FROM region) +
                                     trunc(random() * (SELECT count(region_id) FROM region))::int     as region_id
                              FROM generate_series(1, 10000))
INSERT
INTO vacancy(position_name, compensation_from, compensation_to, created_at, employer_id, region_id)
SELECT position_name,
       compensation_from,
       -- compensation_to гарантированно больше compensation_from на число из отрезка: [1000,10000]
       (compensation_from + 1000 + trunc(random() * (10000 - 1000 + 1)))::int as compensation_to,
       created_at,
       employer_id,
       region_id
FROM test_data;

WITH test_data(position_name,
               compensation_from,
               created_at,
               applicant_id,
               region_id) AS (SELECT md5(random()::text)                                                as position_name,
                                     30000 + trunc(random() * 100000)                                   as compensation_from,
                                     timestamp '2023-01-01' + (random() * interval '3 years')           as created_at,
                                     -- получаю случайные id из отрезка [min,min + idsCount]
                                     -- могу позволить такое, потому что id для соискателей сгенерированы последовательно, без пропусков
                                     (SELECT min(applicant_id) FROM applicant) +
                                     trunc(random() * (SELECT count(applicant_id) FROM applicant))::int as applicant_id,
                                     (SELECT min(region_id) FROM region) +
                                     trunc(random() * (SELECT count(region_id) FROM region))::int       as region_id
                              FROM generate_series(1, 100000))
INSERT
INTO resume(position_name, compensation_from, compensation_to, created_at, applicant_id, region_id)
SELECT position_name,
       compensation_from,
       -- compensation_to гарантированно больше compensation_from на число из отрезка: [1000,10000]
       (compensation_from + 1000 + trunc(random() * (10000 - 1000 + 1)))::int as compensation_to,
       created_at,
       applicant_id,
       region_id
FROM test_data;

WITH preload AS (SELECT (enum_range(null::response_status))[
                            1 + trunc(random() * array_length(enum_range(null::response_status), 1))::int
                            ]::text                                           AS status,

                        (SELECT min(vacancy_id) FROM vacancy) +
                        trunc(random() * (SELECT count(*) FROM vacancy))::int AS vacancy_id,

                        (SELECT min(resume_id) FROM resume) +
                        trunc(random() * (SELECT count(*) FROM resume))::int  AS resume_id

                 FROM generate_series(1, 1000000)),

     test_data AS (SELECT preload.status,
                          preload.vacancy_id,
                          preload.resume_id,
                          v.created_at
                              + interval '1 minute'
                              + random() * interval '3 months' AS created_at
                   FROM preload
                            JOIN vacancy v USING (vacancy_id))

INSERT
INTO response(status, created_at, vacancy_id, resume_id)
SELECT status, created_at, vacancy_id, resume_id
FROM test_data;


WITH test_data(name) AS (SELECT md5(random()::text) as name
                         FROM generate_series(1, 20))
INSERT
INTO industry(name)
SELECT name
FROM test_data;

WITH test_data(name, industry_id) AS (SELECT md5(random()::text)                                              as name,
                                             -- получаю случайные id из отрезка [min,min + idsCount]
                                             -- могу позволить такое, потому что id для отраслей сгенерированы последовательно, без пропусков
                                             (SELECT min(industry_id) FROM industry) +
                                             trunc(random() * (SELECT count(industry_id) FROM industry))::int as industry_id
                                      FROM generate_series(1, 200))
INSERT
INTO specialization(name, industry_id)
SELECT name, industry_id
FROM test_data;

WITH test_data(resume_id, specialization_id) AS (SELECT
                                                     -- получаю случайные id из отрезка [min,min + idsCount]
                                                     -- могу позволить такое, потому что id для специализаций и резюме сгенерированы последовательно, без пропусков
                                                     (SELECT min(resume_id) FROM resume) +
                                                     trunc(random() * (SELECT count(resume_id) FROM resume))::int                 as resume_id,

                                                     (SELECT min(specialization_id) FROM specialization) +
                                                     trunc(random() * (SELECT count(specialization_id) FROM specialization))::int as specialization_id
                                                 FROM generate_series(1, 500000))
INSERT
INTO resume_specializations(resume_id, specialization_id)
SELECT resume_id, specialization_id
FROM test_data
ON CONFLICT DO NOTHING;
