-- 1. Selisih kenaikan posisi EN ke MI per tahun
with ds_1 as
(
select work_year, avg(salary_in_usd) avg_sal_usd
from ds_salaries
where job_title like "%data scientist%"
	and experience_level = "MI"
    and employment_type = "FT"
group by work_year
), ds_2 as (
select work_year, avg(salary_in_usd) avg_sal_usd
from ds_salaries
where job_title like "%data scientist%"
	and experience_level = "SE"
    and employment_type = "FT"
group by work_year
), ds_year as (
select distinct work_year from ds_salaries
)

select ds_year.work_year,
	ds_1.avg_sal_usd, ds_2.avg_sal_usd,
    abs(ds_1.avg_sal_usd - ds_2.avg_sal_usd) as selisih
from ds_year
left join ds_1
on ds_year.work_year = ds_1.work_year
left join ds_2
on ds_year.work_year = ds_2.work_year
;

-- 2. Rata-rata gaji job_title tertinggi per tahun
with ds_year as
(
select distinct work_year
from ds_salaries
), 
ds_1 as 
(
select work_year, job_title, avg(salary_in_usd) avg_sal_usd
from ds_salaries
where work_year = "2020"
group by work_year, job_title
order by avg_sal_usd desc
limit 1
), 
ds_2 as
(
select work_year, job_title, avg(salary_in_usd) avg_sal_usd
from ds_salaries
where work_year = "2021"
group by work_year, job_title
order by avg_sal_usd desc
limit 1
), 
ds_3 as 
(
select work_year, job_title, avg(salary_in_usd) avg_sal_usd
from ds_salaries
where work_year = "2022"
group by work_year, job_title
order by avg_sal_usd desc
limit 1
)
select 
	ds_year.work_year,
	ds_1.job_title, ds_1.avg_sal_usd, 
    ds_2.job_title, ds_2.avg_sal_usd,
    ds_3.job_title, ds_3.avg_sal_usd
from ds_year
	left join ds_1
		on ds_year.work_year = ds_1.work_year
	left join ds_2
		on ds_year.work_year = ds_2.work_year
	left join ds_3
		on ds_year.work_year = ds_3.work_year;
        

-- 3. Negara yang rata2 gajinya lebih tinggi dari rata2 gaji keseluruhan
select company_location, avg(salary_in_usd) as avg_sal_per_country
from ds_salaries
group by company_location
having avg_sal_per_country > (select avg(salary_in_usd) from ds_salaries)
order by avg_sal_per_country desc;

-- 4. Gaji tertinggi pertahun untuk posisi %data analyst% and FT
with ds_year as
(
select distinct work_year
from ds_salaries
),
ds_1 as
(
select work_year, job_title, max(salary_in_usd) as max_sal_usd
from ds_salaries
where work_year in (2020) and job_title like "%data analyst%" and employment_type = "ft"
group by work_year, job_title
order by max_sal_usd desc
limit 1
),
ds_2 as
(
select work_year, job_title, max(salary_in_usd) as max_sal_usd
from ds_salaries
where work_year = 2021 and job_title like "%data analyst%" and employment_type = "ft"
group by work_year, job_title
order by max_sal_usd desc
limit 1
),
ds_3 as
(
select work_year, job_title, max(salary_in_usd) as max_sal_usd
from ds_salaries
where work_year = 2022 and job_title like "%data analyst%" and employment_type = "ft"
group by work_year, job_title
order by max_sal_usd desc
limit 1
)

select ds_year.work_year,
ds_1.job_title, ds_1.max_sal_usd,
ds_2.job_title, ds_2.max_sal_usd,
ds_3.job_title, ds_3.max_sal_usd
from ds_year
left join ds_1
on ds_year.work_year = ds_1.work_year
left join ds_2
on ds_year.work_year = ds_2.work_year
left join ds_3
on ds_year.work_year = ds_3.work_year;

-- 5. Rata2 gaji per jenis pekerjaan dalam Rupiah per bulan
select job_title, (avg(salary_in_usd) * 15000)/12 as avg_monthly_rp
from ds_salaries
where job_title like "%data analyst"
group by job_title
order by avg_monthly_rp desc;