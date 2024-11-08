-- Exploratory Data Analysis -- 

select * 
from layoffs3; 
-- lets look at our data’s coverage -- 
select min(`date`), max(`date`) 
from layoffs3; 

select count(distinct company) 
from layoffs3;

select count(distinct industry) 
from layoffs3; 

select count(distinct country) 
from layoffs3;
/* so our data covers almost 3 years of 1628 companies of running in 30 different industries that are in 51 countries. 
   This is a data of 1628 companies lay off by days. 
*/

select *
from layoffs3 
order by total_laid_off desc; 
-- Google is the highest amount of lay off in january 20th, 2023 --

select company, sum(total_laid_off) 
from layoffs3
group by company 
order by 2 desc ;
-- in 3 years, Amazon made the highest amount of lay offs. --

select industry, sum(total_laid_off) 
from layoffs3
group by industry 
order by 2 desc ; 
-- most laid offs are in Consumer, Retail and Other industries. -- 

select country, sum(total_laid_off) 
from layoffs3
group by country 
order by 2 desc ; 
-- most laid offs are in US, India and Netherlands. --

select year(`date`), sum(total_laid_off) 
from layoffs3
group by year(`date`) 
order by 1 desc ; 
-- according to yearly total, most laid offs occurred in 2022  --

select stage, sum(total_laid_off) 
from layoffs3
group by stage
order by 2 desc ; 

select company, max(total_laid_off), max(percentage_laid_off)
from layoffs3
group by company 
order by max(percentage_laid_off) desc; 
-- meaning of percentage laid off equals to 1 is company shut down --

select count(distinct company) 
from layoffs3 
where percentage_laid_off = 1; 
--  in 3 years 115 company shut down -- 

select industry, count(distinct company) 
from layoffs3 
where percentage_laid_off = 1 
group by industry 
order by count(distinct company) desc ; 
-- Most these companies shut dowm are in food, retail and finance industries. --

with Rolling_Total as 
(
select substring(`date`, 1, 7) as `month`, sum(total_laid_off) as total_off
from layoffs3 
where substring(`date`, 1, 7) is not null
group by `month` 
order by 1
) 
select `month`, total_off,
sum(total_off) over(order by `month`) as rolling_total
from Rolling_Total
; 
-- This show each month how many people had been laid off -- 

with Company_Year (company, years, total_laid_off)as 
(
select company, year(`date`), sum(total_laid_off) 
from layoffs3
group by company, year(`date`)
order by 3 desc
), Company_Year_Ranking as 
(
select * , 
dense_rank() over(partition by years order by total_laid_off desc) as ranking
from Company_Year 
where years is not null
)
select * 
from Company_Year_Ranking 
where ranking <= 5
;
/* Uber is the most laid off company in 2020,
   in 2021 its Bytedance,
   in 2022 its Meta, 
   the last in 2023 its Google.
*/

 







