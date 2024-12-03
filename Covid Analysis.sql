SELECT * 
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4;

--SELECT * 
--FROM CovidVaccinations
--ORDER BY 3,4;

-- Select Data that we will be using

--SELECT location, date, total_cases, new_cases, total_deaths, population
--FROM CovidDeaths
--WHERE continent IS NOT NULL
--ORDER BY 1,2;

--Looking at total cases vs total deaths
--Shows likelyhood of eath if you contract covid in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_perc
FROM CovidDeaths
WHERE location LIKE '%United Kingdom%'
AND continent IS NOT NULL
ORDER BY 1,2;

-- Total cases vs Population
--Shows percent population that got covid

SELECT location, date, population, total_cases, (total_cases/population)*100 AS Percent_pop_infected
FROM CovidDeaths
WHERE location LIKE '%United Kingdom%'
AND continent IS NOT NULL
ORDER BY 1,2;

--Countries with hihest infection rates compared to population

SELECT location, population, MAX(total_cases) AS Highest_infection_count, MAX((total_cases/population))*100 AS Percent_pop_infected
FROM CovidDeaths
--WHERE location LIKE '%United Kingdom%'
-- AND continent IS NOT NULL
GROUP BY location, population
ORDER BY Percent_pop_infected DESC;

--Showing countries with highest death count per population

SELECT location, MAX(cast(total_deaths AS int)) AS Highest_death_count
FROM CovidDeaths
--WHERE location LIKE '%United Kingdom%'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY Highest_death_count DESC;

--Breakdown by continent with incorrect numbers

SELECT continent, MAX(cast(total_deaths AS int)) AS Highest_death_count
FROM CovidDeaths
--WHERE location LIKE '%United Kingdom%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Highest_death_count DESC;

-- breakdown with continent with correct numbers highest death count

SELECT location, MAX(cast(total_deaths AS int)) AS Highest_death_count
FROM ProjectTrial..CovidDeaths
--WHERE location LIKE '%United Kingdom%'
WHERE continent IS NULL
GROUP BY location
ORDER BY Highest_death_count DESC;

--Showing global figures

--SELECT date, SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS int)) AS total_deaths, SUM(cast(new_deaths AS int))/ SUM(new_cases)*100 AS death_perc
--FROM CovidDeaths
----WHERE location LIKE '%United Kingdom%'
--WHERE continent IS NOT NULL
--GROUP BY date
--ORDER BY 1,2;

--Gives overall figures

SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS int)) AS total_deaths, SUM(cast(new_deaths AS int))/ SUM(new_cases)*100 AS death_perc
FROM ProjectTrial..CovidDeaths
--WHERE location LIKE '%United Kingdom%'
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2;

--Looking at total popuation vs vaccinations
--USe CTE
WITH Popvsvac (Continent, Loation, Date, Population, New_Vaccinations, Rolling_people_vaccinated)
AS
(
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) OVER(PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) AS rolling_people_vaccinated
--(rolling_people_vaccinated/population)*100 
FROM ProjectTrial..CovidDeaths deaths
JOIN ProjectTrial..CovidVaccinations vac
ON deaths.location = vac.location
AND deaths.date = vac.date
WHERE deaths.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *, (rolling_people_vaccinated/population)*100 AS perc_vacc
FROM Popvsvac

--TEMP TABLE and add drop table to ensure table updates with changes made to query

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rolling_people_vaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) OVER(PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) AS rolling_people_vaccinated
--(rolling_people_vaccinated/population)*100 
FROM ProjectTrial..CovidDeaths deaths
JOIN ProjectTrial..CovidVaccinations vac
ON deaths.location = vac.location
AND deaths.date = vac.date
WHERE deaths.continent IS NOT NULL
--ORDER BY 2,3

SELECT *, (rolling_people_vaccinated/population)*100 AS perc_vacc
FROM #PercentPopulationVaccinated


--Creating views to store data for later vis

CREATE VIEW PercentPopulationVaccinated AS
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) OVER(PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) AS rolling_people_vaccinated
--(rolling_people_vaccinated/population)*100 
FROM ProjectTrial..CovidDeaths deaths
JOIN ProjectTrial..CovidVaccinations vac
ON deaths.location = vac.location
AND deaths.date = vac.date
WHERE deaths.continent IS NOT NULL
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated

CREATE VIEW GlobalFigures AS
SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS int)) AS total_deaths, SUM(cast(new_deaths AS int))/ SUM(new_cases)*100 AS death_perc
FROM ProjectTrial..CovidDeaths
--WHERE location LIKE '%United Kingdom%'
WHERE continent IS NOT NULL
--GROUP BY date
--ORDER BY 1,2;

CREATE VIEW HighestDeathCount AS
SELECT location, MAX(cast(total_deaths AS int)) AS Highest_death_count
FROM ProjectTrial..CovidDeaths
--WHERE location LIKE '%United Kingdom%'
WHERE continent IS NULL
GROUP BY location
--ORDER BY Highest_death_count DESC;
