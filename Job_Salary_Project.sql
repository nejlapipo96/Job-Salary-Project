select *
from job_salary;

create table job_salary_workbook
like job_salary;

insert into job_salary_workbook
select *
from job_salary;

select *
from job_salary_workbook;

-- Remove duplicates (if exists)

with duplicates_cte as
(
select *, row_number() over(partition by work_year, experience_level, employment_type, job_title,
salary, salary_currency, salary_in_usd, employee_residence, remote_ratio,
company_location, company_size) as row_num
from job_salary_workbook
)
select *
from duplicates_cte
where row_num > 1;

CREATE TABLE `job_salary_workbook2` (
  `work_year` text,
  `experience_level` text,
  `employment_type` text,
  `job_title` text,
  `salary` int DEFAULT NULL,
  `salary_currency` text,
  `salary_in_usd` int DEFAULT NULL,
  `employee_residence` text,
  `remote_ratio` int DEFAULT NULL,
  `company_location` text,
  `company_size` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into job_salary_workbook2
select *, row_number() over(partition by work_year, experience_level, employment_type, job_title,
salary, salary_currency, salary_in_usd, employee_residence, remote_ratio,
company_location, company_size) as row_num
from job_salary_workbook;

select *
from job_salary_workbook2
where row_num > 1
;

delete
from job_salary_workbook2
where row_num > 1
;

-- Standardize the data

select distinct work_year
from job_salary_workbook2;

select work_year
from job_salary_workbook2
where work_year like "2021%";

update job_salary_workbook2
set work_year = 2021
where work_year like "2021%"
;

select *
from job_salary_workbook2;

select distinct experience_level
from job_salary_workbook2;

update job_salary_workbook2
set experience_level = "Entry-level/Junior"
where experience_level = "EN"
;

update job_salary_workbook2
set experience_level = "Mid-level/Intermediate"
where experience_level = "MI"
;

update job_salary_workbook2
set experience_level = "Senior-level/Expert"
where experience_level = "SE"
;

update job_salary_workbook2
set experience_level = "Executive-level/Director"
where experience_level = "EX"
;

select distinct employment_type
from job_salary_workbook2;

update job_salary_workbook2
set employment_type = "Part-time"
where employment_type = "PT"
;

update job_salary_workbook2
set employment_type = "Full-time"
where employment_type = "FT"
;

update job_salary_workbook2
set employment_type = "Contract"
where employment_type = "CT"
;

update job_salary_workbook2
set employment_type = "Freelance"
where employment_type = "FL"
;

select distinct job_title
from job_salary_workbook2
order by job_title;

update job_salary_workbook2
set job_title = "Machine Learning Engineer"
where job_title = "ML Engineer"
;

-- Null values or blank values

select *
from job_salary_workbook2
where employment_type is null
or employment_type = '';
-- NO NULL VALUES OR BLANK VALUES

-- Remove any column or row

alter table job_salary_workbook2
drop column row_num;

select *
from job_salary_workbook2;

-- Exploratory Data

select *
from job_salary_workbook2;

select distinct job_title
from job_salary_workbook2
where salary_in_usd >= 100000
;

select avg(salary_in_usd)
from job_salary_workbook2
where job_title = 'Financial Data Analyst'
;

select distinct job_title
from job_salary_workbook2
where salary_in_usd < 100000
;

select round(avg(salary_in_usd), 2) as avg_salary_fulltime
from job_salary_workbook2
where employment_type = 'Full-time'
;

select job_title, salary_in_usd
from job_salary_workbook2
where salary_in_usd >= (select round(avg(salary_in_usd), 2)
from job_salary_workbook2
where employment_type = 'Full-time') and employment_type = 'Full-time'
order by salary_in_usd
;

select job_title, salary_in_usd
from job_salary_workbook2
where salary_in_usd < (select round(avg(salary_in_usd), 2)
from job_salary_workbook2
where employment_type = 'Full-time') and employment_type = 'Full-time'
order by salary_in_usd
;

select round(avg(salary_in_usd), 2) as avg_salary_parttime
from job_salary_workbook2
where employment_type = 'Part-time'
;

select job_title, salary_in_usd
from job_salary_workbook2
where salary_in_usd >= (select round(avg(salary_in_usd), 2)
from job_salary_workbook2
where employment_type = 'Part-time') and employment_type = 'Part-time'
order by salary_in_usd
;

select job_title, salary_in_usd
from job_salary_workbook2
where salary_in_usd < (select round(avg(salary_in_usd), 2)
from job_salary_workbook2
where employment_type = 'Part-time') and employment_type = 'Part-time'
order by salary_in_usd
;

select count(*) as num_employee, employee_residence
from job_salary_workbook2
group by employee_residence
order by num_employee desc
;

select distinct job_title, count(*) as num_employee
from job_salary_workbook2
group by job_title
order by num_employee desc
;

select experience_level, count(*) as num_employee
from job_salary_workbook2
group by experience_level
order by num_employee desc
;

select remote_ratio, count(*) as num_employee
from job_salary_workbook2
group by remote_ratio
;

select employment_type, count(*) as num_employee
from job_salary_workbook2
group by employment_type
order by num_employee desc
;





