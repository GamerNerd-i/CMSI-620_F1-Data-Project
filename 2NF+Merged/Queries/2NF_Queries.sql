-- BASIC QUERIES

-- Which F1 driver has the most first-place finishes?
select concat(driver_details.forename, ' ', driver_details.surname) as driver_name, 
       count(driver_rankings.currentPosition) as first_places
from driver_rankings
left join driver_details on driver_details.driverId = driver_rankings.driverId
where driver_rankings.currentPosition = 1
group by driver_details.driverId, driver_details.forename, driver_details.surname
order by first_places desc
limit 1;

-- Which F1 driver has the most podiums (1st, 2nd, 3rd)?
select concat(driver_details.forename, ' ', driver_details.surname) as driver_name, 
       count(driver_rankings.currentPosition) as podiums
from driver_rankings
left join driver_details on driver_details.driverId = driver_rankings.driverId
where driver_rankings.currentPosition <= 3
group by driver_details.driverId, driver_details.forename, driver_details.surname
order by podiums desc
limit 1;

-- Which circuit has held the most races?
select c.circuitName, count(race_schedule.circuitId) as num_of_races
from circuits as c
join race_schedule on race_schedule.circuitId = c.circuitId
group by c.circuitId, c.circuitName
order by num_of_races desc;

-- How many drivers are named Andrew?
select count(*) 
from driver_details 
where forename = 'Andrew';

-- ADVANCED QUERIES

-- What's the fastest lap time of each driver?
select concat(driver_details.forename, ' ', driver_details.surname) as driver_name, 
       min(lap_times.milliseconds) / 1000 as fastest_lap_time
from lap_times
left join driver_details on driver_details.driverId = lap_times.driverId
group by driver_details.driverId, driver_details.forename, driver_details.surname
order by fastest_lap_time asc;

-- For each driver, find the constructor they have driven for most.
create temporary table most_common_team as
select driverId, constructorId
from race_results
group by driverId, constructorId
having count(*) = (
    select max(team_count)
    from (
        select count(*) as team_count
        from race_results
        where driverId = race_results.driverId
        group by constructorId
    ) subquery
);

select concat(driver_details.forename, ' ', driver_details.surname) as driver_name, 
       constructors.name as team_name
from most_common_team
left join driver_details on driver_details.driverId = most_common_team.driverId
left join constructors on constructors.constructorId = most_common_team.constructorId;

drop table most_common_team;

-- On which circuit have the most fatalities occurred during a race?
select distinct 
    c.circuitName,
    c.location,
    c.country,
    count(rr.statusId) over (partition by c.circuitName, c.location, c.country) as fatalities
from circuits as c
join race_schedule as rs on c.circuitId = rs.circuitId
join race_results as rr on rs.raceId = rr.raceId
join status as rst on rr.statusId = rst.statusId
where rst.statusId = 104
order by fatalities desc;