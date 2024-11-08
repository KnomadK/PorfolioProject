-- DATA CLEANING --
SELECT * 
FROM world_layoff.layoffs
;

-- Removing Duplicates -- 
-- Standardizing -- 
-- Null/Blank Values -- 
-- Delete Columns / Rows -- 

-- Removing Duplicates -- 
create table layoffs2 
like layoffs; 

insert into layoffs2
select * 
from layoffs;

select * 
from layoffs2;

with cte_layoffs2 as (
select *, 
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) as row_num
from layoffs2
) 
select *
from cte_layoffs2
where row_num > 1
;

CREATE TABLE `layoffs3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` double DEFAULT NULL,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL, 
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * 
from layoffs3
;

insert into layoffs3
select *, 
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) as row_num
from layoffs2;

delete
from layoffs3 
where row_num > 1
;

select * 
from layoffs3
;

-- Standardizing -- 
select company, trim(company)
from layoffs3
;

update layoffs3 
set company = trim(company)
;

select distinct country
from layoffs3
order by 1
;

select * 
from layoffs3;

update layoffs3 
set 
	location = case 
		when location like '%sseldorf'  then 'Düsseldorf'
        when location like 'Florian%' then 'Florianópolis'
        when location like 'Malm%' then 'Malmö'
        else location 
    end,
    industry = case 
		when industry like 'Crypto%' then 'Crypto' 
        else industry
    end, 
    country = case 
		when country like 'United States%' then 'United States'
        else country
    end 
;

update layoffs3 
set `date` = str_to_date(`date`, '%m/%d/%Y')
;

alter table layoffs3 
modify column `date` date
;

-- Null/Blank Values --  
select *
from layoffs3 
where industry is null 
or industry = ''
; 

select * 
from layoffs3 
where company like 'Bally%'
;

update layoffs3 
set industry = null 
where industry = ''
;

select t1.industry, t2.industry
from layoffs3 t1 
join layoffs3 t2 
	on t1.company = t2.company 
	where t1.industry is null 
    and t2.industry is not null
;

update layoffs3 t1 
join layoffs3 t2 
	on t1.company = t2.company
set t1.industry = t2.industry 
where t1.industry is null 
and t2.industry is not null
;

select * 
from layoffs3 
where total_laid_off is null 
and percentage_laid_off is null 
; 

delete
from layoffs3 
where total_laid_off is null 
and percentage_laid_off is null 
; 

-- Removing Columns or Rows -- 
select * 
from layoffs3
;

alter table layoffs3 
drop column row_num 
;














