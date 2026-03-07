CREATE TABLE region
(
    region_id integer generated always as identity primary key,
    name      text not null
);

CREATE TABLE employer
(
    employer_id  integer generated always as identity primary key,
    name         text        not null,
    phone_number varchar(16) not null,
    created_at   timestamp default now(),
    region_id    integer references region (region_id)
);
CREATE TABLE applicant
(
    applicant_id integer generated always as identity primary key,
    first_name   text        not null,
    second_name  text        not null,
    middle_name  text        not null,
    birth_date   date,
    phone_number varchar(16) not null,
    created_at   timestamp default now(),
    region_id    integer references region (region_id)
);

CREATE TABLE vacancy
(
    vacancy_id        integer generated always as identity primary key,
    position_name     text not null,
    compensation_from integer,
    compensation_to   integer,
    created_at        timestamp default now(),
    employer_id       integer references employer (employer_id),
    region_id         integer references region (region_id)
);

CREATE TABLE resume
(
    resume_id         integer generated always as identity primary key,
    position_name     text not null,
    compensation_from integer,
    compensation_to   integer,
    created_at        timestamp default now(),
    applicant_id      integer references applicant (applicant_id),
    region_id         integer references region (region_id)
);
CREATE TYPE response_status AS ENUM ('pending', 'submitted', 'reviewed', 'accepted', 'rejected');

CREATE TABLE response
(
    response_id integer generated always as identity primary key,
    status      text      default 'submitted',
    created_at  timestamp default now(),
    vacancy_id  integer references vacancy (vacancy_id),
    resume_id   integer references resume (resume_id)
);

CREATE TABLE industry
(
    industry_id integer generated always as identity primary key,
    name        text not null
);

CREATE TABLE specialization
(
    specialization_id integer generated always as identity primary key,
    name              text not null,
    industry_id       integer references industry (industry_id)
);

CREATE TABLE resume_specializations
(
    resume_id         integer not null references resume (resume_id),
    specialization_id integer not null references specialization (specialization_id),
    PRIMARY KEY (resume_id, specialization_id)
);


