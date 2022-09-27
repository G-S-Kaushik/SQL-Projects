create database covid;
use covid;
select * from coviddeath where continent != '' ;
select * from covidvacination; 




select location, date, total_cases, new_cases, total_deaths, hosp_patients, population from coviddeath ;

# Total Cases vs Total Deaths

select location, sum(total_cases) Total_cases, sum(total_deaths) Total_deaths, round((sum(total_deaths)/sum(total_cases))*100,2) as Death_Percentage 
from coviddeath 
group by location 
order by Death_Percentage desc;

# total cases vs total deaths india

select location, date ,total_cases, total_deaths, round((total_deaths/total_cases)*100,2) as Death_Percentage from coviddeath 
where location = "india";

# total of presentage of population got covid

select location, date ,total_cases, population, round((total_cases/population)*100,2) as covid_Percentage from coviddeath where location = "india";

# countries with heighst infection rate compared to population 

select location, population, max(total_cases) as HeighstInfectionCount, round(Max((total_cases/population)*100),2) as Percentage_of_pop_infected from coviddeath group by location, population order by Percentage_of_pop_infected desc;

# showing countries with highest death count per population

select location,continent, max(total_deaths) as Total_Death_Count from coviddeath 
where continent != ''   
group by location
order by Total_Death_Count desc;

# Drill up by continent 

# showing continents with highest death count per population

select continent, max(total_deaths) as Total_Death_Count from coviddeath 
where continent != ''   
group by continent
order by Total_Death_Count desc;

# Global Numbers

select sum(new_cases) as Total_cases, sum(new_deaths) as Total_deaths,
 round(sum(new_deaths)/sum(new_cases)*100,2) as Death_Percentage from coviddeath 
where continent != ''  order by 1,2 ;

# joining 2 tables

select * from covidvacination as cv join coviddeath as cd on cv.location=cd.location and 
cv.date=cd.date;

#location at total population vs vacination

select distinct cd.continent, cd.location, str_to_date(cd.date,'%d-%m-%y') as date, cd.population, cv.new_vaccinations,
 sum(cv.new_vaccinations) over (partition by cd.location order by cd.location, str_to_date(cd.date,'%d-%m-%y')) as Rolling_ppl_Vacination 
 from covidvacination as cv join coviddeath as cd 
on cv.location=cd.location 
and 
cv.date=cd.date
where  cd.continent != '' 
order by 2;

# Use VIEW

CREATE VIEW POPVSVAC AS
select distinct cd.continent, cd.location, str_to_date(cd.date,'%d-%m-%y') as date, cd.population, cv.new_vaccinations,
 sum(cv.new_vaccinations) over (partition by cd.location order by cd.location, str_to_date(cd.date,'%d-%m-%y')) as Rolling_ppl_Vacination 
 from covidvacination as cv join coviddeath as cd 
on cv.location=cd.location 
and 
cv.date=cd.date
where  cd.continent != '' 
order by 2;
;

SELECT *,ROUND((Rolling_ppl_Vacination/POPULATION)*100,2) VACIVATED_POP_PERENTAGE FROM POPVSVAC



