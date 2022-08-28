SELECT 
*
FROM 
[COVID DEATH]
ORDER BY 3,4

SELECT 
*
FROM 
[COVID VACCINATION]
ORDER BY 3,4

--SELECTING DATA TO BE USED 
SELECT 
location,date,total_cases,new_cases,total_deaths,population
FROM 
[COVID DEATH]
ORDER BY 1,2


--LOOKING AT TOTAL DEATHS AGAINST TOTAL CASES 
SELECT 
location,date,total_cases,total_deaths,population,(total_deaths/total_cases)*100 AS  death_percentage 
FROM 
[COVID DEATH]
ORDER BY 1,2

--LOOKING AT TOTAL CASES AGAINST  POPULATION 
SELECT 
location,date,total_cases,population,(total_cases/population)*100 AS  case_percentage 
FROM 
[COVID DEATH]
ORDER BY 1,2

--COUNTRY WITH  THE  HIGHEST INFECTION RATE AGAINST POPULATION
SELECT 
location,MAX(total_cases) as highest_infectioncount  ,population,max((total_cases/population))*100 AS percentegepopulationinfected 
FROM
[COVID DEATH]
GROUP BY location,population
ORDER BY percentegepopulationinfected DESC


--COUNTRIES WUTH THE HIGHEST DEATH COUNT PER LOCATION
SELECT 
location, max(cast(total_deaths as int)) as tptal_death_count
from
[COVID DEATH]
where continent is not  null
GROUP BY location
ORDER BY  max(total_deaths) DESC

--HIGHEST DEATH COUNT BY CONTINENT 
SELECT 
continent, max(cast(total_deaths as int)) as tptal_death_count
from
[COVID DEATH]
where continent is not null
GROUP BY continent
ORDER BY  max(total_deaths) DESC

--GLOBAL NUMBERS
SELECT 
sum (new_cases) as total_cases,sum(cast (new_deaths as int))as total_deaths ,sum(cast (new_deaths as int)) / sum(new_cases)*100  as deathpercentage 
FROM 
[COVID DEATH]
where continent is not null 
ORDER BY 1,2


--EXTRACTING  VACCINATION DATA 
SELECT
*
from 
[COVID VACCINATION]

--JOINING THE COVID VACCINATION DATABASE AND THAT OF DEATH
select * from [COVID DEATH] dea
join [COVID VACCINATION] vac
on dea.location = vac.location
and dea.date = vac.date

--TOTAL POPULATION AGAINST VACCINATION
SELECT dea.continent, dea.date, dea.location,dea.population,vac.new_vaccinations,
SUM(convert(numeric,vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as rollingcountpeoplevaccinated 
FROM [COVID DEATH] dea
JOIN [COVID VACCINATION] vac
ON dea.location =vac.location
AND dea.date =vac.date
where [dea].continent is not nulL
ORDER BY 1,3


--CREATE TEMP TABLE 

create table #percentagepopulationvaccinated 
(continent nvarchar(225),
date datetime,
location nvarchar(225),
population numeric,
new_vaccinations numeric,
rollingcountpeoplevaccinated numeric)
insert into #percentagepopulationvaccinated 
SELECT dea.continent, dea.date, dea.location,dea.population,vac.new_vaccinations,
SUM(convert(numeric,vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as rollingcountpeoplevaccinated 
FROM [COVID DEATH] dea
JOIN [COVID VACCINATION] vac
ON dea.location =vac.location
AND dea.date =vac.date
where [dea].continent is not nulL


--NEW TABLE CREATED 
SELECT * FROM #percentagepopulationvaccinated

--CREATING VIEWS
create view percentagepopulationvaccinated as
SELECT dea.continent, dea.date, dea.location,dea.population,vac.new_vaccinations,
SUM(convert(numeric,vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as rollingcountpeoplevaccinated 
FROM [COVID DEATH] dea
JOIN [COVID VACCINATION] vac
ON dea.location =vac.location
AND dea.date =vac.date
where [dea].continent is not nulL


create view globalnumber as
SELECT 
sum (new_cases) as total_cases,sum(cast (new_deaths as int))as total_deaths ,sum(cast (new_deaths as int)) / sum(new_cases)*100  as deathpercentage 
FROM 
[COVID DEATH]
where continent is not null 
--ORDER BY 1,2


create view total_death as
SELECT 
location, max(cast(total_deaths as int)) as tptal_death_count
from
[COVID DEATH]
where continent is not  null
GROUP BY location
--ORDER BY  max(total_deaths) DESC

