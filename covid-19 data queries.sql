-- Query 1: Count the number of rows in the CovidDeaths table
select count(*) as Covid_Death_row_count from CovidDeaths;

-- Query 2: Count the number of rows in the CovidVaccinations table
select count(*) as Covid_Vaccinations_row_count from CovidVaccinations;

-- Query 3: Retrieve specific columns from CovidDeaths where continent is not null, ordered by location and date
Select Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
Where continent is not null 
order by 1,2;

-- Query 4: Calculate death percentage in each country based on total deaths and total cases
SELECT Location, date, total_deaths, total_cases,
    CASE
        WHEN total_cases > 0 THEN (total_deaths * 100.0 / total_cases)
        ELSE NULL 
    END AS Death_percentage
FROM CovidDeaths
WHERE total_cases > 0 and continent is not Null
ORDER BY 1, 2;

-- Query 5: Calculate infection rate in each country based on new cases and total cases
SELECT Location, date, new_cases, total_cases,
    CASE
        WHEN total_cases > 0 THEN (new_cases * 100.0 / total_cases)
        ELSE NULL 
    END AS Infected_Rate
FROM CovidDeaths
WHERE total_cases > 0 and continent is not Null
ORDER BY 1;

-- Query 6: Calculate percentage of population infected in each country for a specific location and date
Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From CovidDeaths
Where location like '%india%' and continent is not Null
order by 1,2

-- Query 7: Find countries with the highest infection rate compared to population
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  
       Max((total_cases/population))*100 as Percent_Population_Infected
From CovidDeaths
where continent is not Null
Group by Location, Population
order by Percent_Population_Infected desc

-- Query 8: Find countries with the highest death rates compared to population
Select Location, MAX(total_deaths) as Total_Deaths_Count
From CovidDeaths
where continent is not Null
Group by Location
order by Total_Deaths_Count desc

-- Query 9: Calculate the overall death percentage worldwide
SELECT 
    SUM(new_cases) as total_cases,
    SUM(new_deaths) as total_deaths,
    CASE
        WHEN SUM(new_cases) > 0 
        THEN SUM(new_deaths) * 100.0 / SUM(new_cases)
        ELSE 0
    END AS DeathPercentage
FROM 
    CovidDeaths;

-- Query 10: Calculate death percentage globally for each date
Select date, SUM(new_cases) as total_cases, 
       SUM(new_deaths) as total_deaths, 
	   case 
		   when sum(new_cases)>0 then round(SUM(new_deaths)*100 /SUM(New_Cases),2)
	       else 0
	end as DeathPercentage
From CovidDeaths
group by date
order by 1;

-- Query 11: Calculate the percentage of people vaccinated in each country
select  d.continent, d.location, d.date, d.population, v.new_vaccinations,
       SUM(CONVERT(int,v.new_vaccinations)) OVER (Partition by d.Location Order by d.location, d.Date) as PeopleVaccinated 
from CovidDeaths as d
join CovidVaccinations as v
on d.location = v.location and v.date = d.date
where d.continent is not null 
order by 2,3

-- Query 12: Display top 1000 rows from CovidVaccinations
select top 1000 * from CovidVaccinations

-- Query 13: Display top 1000 rows from CovidDeaths
select top 1000 * from CovidDeaths

-- Query 14: Calculate the percentage of people vaccinated in each country and create a view
create view percentage_people_vaccinated as
SELECT
    v.location,
    SUM(COALESCE(CAST(v.people_vaccinated AS BIGINT), 0)) AS people_vaccinated,
    sum(d.population) AS population,
    CASE
        WHEN MAX(d.population) > 0 THEN (SUM(COALESCE(CAST(v.people_vaccinated AS FLOAT), 0.0)) * 100.0 / sum(d.population))
        ELSE NULL
    END AS Percentage_People_Vaccinated
FROM
    CovidVaccinations AS v
JOIN
    CovidDeaths AS d ON v.date = d.date AND v.location = d.location
--where d.continent is Null
GROUP BY
    v.location
order by 4 desc;

-- Query 15: Calculate rolling people vaccinated in each country and create a view
create view RollingPeopleVaccinated as
Select d.continent, d.location, d.date, d.population, v.new_vaccinations,
       SUM(CONVERT(int,v.new_vaccinations)) OVER (Partition by d.Location Order by d.location, d.Date) as RollingPeopleVaccinated
From CovidDeaths d
Join CovidVaccinations v
	On d.location = v.location
	and d.date = v.date
where d.continent is not null;

-- Query 16: Calculate the percentage of people vaccinated in each country using a temporary table
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

-- Query 17: Calculate the percentage of people vaccinated in each country using a view
create view percentage_people_vaccinated as
Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

-- Cleanup: Drop the temporary table
drop table if exists #PercentPopulationVaccinated;
