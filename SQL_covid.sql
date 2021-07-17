
--Looking CovidDeath table 
select * from CovidDeath;

select * from CovidDeath 
where continent is not null 
order by 3,4 ;

--Select location,date,population, total_cases, new_case, total_deaths
select location, date, population, new_cases, total_cases, total_deaths from CovidDeath
where continent is not null
order by 1,2;

--calculate CovidPercentage  in population by location
select location, date, population, total_cases, (total_cases/population) *100 as CovidPercentage 
from CovidDeath
where location like '%states%';

select location, date, population, total_cases, (total_cases/population) *100 as CovidPercentage 
from CovidDeath
order by 1,2; 

--calculate DeathPercentage in population by location 
select location, date, population, total_deaths, (total_deaths/population) * 100 as DeathPercentage 
from CovidDeath 
where location like '%states%';

select location, date, population, total_deaths, (total_deaths/population) * 100 as DeathPercentage 
from CovidDeath 
order by 1,2;

--calculate Highest Infection Rate per Population
select location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population) * 100 as HighestInfectionRate 
from CovidDeath
group by location, population
order by HighestInfectionRate desc;

--Calcuate Highest death count by location 
select location,  
MAX(CONVERT(int,total_deaths)) as HighestDeathCount
from CovidDeath
where continent is not null
group by location
order by HighestDeathCount desc;

-- calculate HighestDeathCount by Continent 
select Continent, MAX(CAST(total_deaths as int)) as HighestDeathCount from CovidDeath
where continent is not null 
Group By continent
Order By HighestDeathCount  desc;

--Global Numbers
select SUM(new_cases) as total_cases,
SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as DeathPercentage
from CovidDeath
where continent is not null
order by 1,2;


--vaccination vs population
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition By dea.location Order By dea.location, dea.date) as RollingPeopleVaccinated 
from CovidDeath dea
join CovidVaccination vac
on dea.location=vac.location 
and dea.date = vac.date
where dea.continent is not null
order by 2,3;

-- use CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeath dea
Join CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--use temp table 
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
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeath dea
Join CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

--VIEW
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeath dea
Join CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

--For Tableau project
-- calculate death percentage 
select SUM(new_cases) as total_cases, SUM(cast(new_deaths as  int)) as Total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases) * 100 DeathPercentage 
from CovidDeath 
where continent is not null
order by 1,2 

--calculate death count
select location,SUM(CONVERT(int,new_deaths)) as TotalDeathCount
from CovidDeath
where continent is null and location not in('World', 'European Union', 'International')
group by location
order by TotalDeathCount desc;


--calculate percentagepopulationinfected
select location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentagePopulationInfected
from CovidDeath
group by location,population
order by PercentagePopulationInfected desc;

select location,population,date, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentagePopulationInfected
from CovidDeath
group by location,population,date
order by PercentagePopulationInfected desc;
