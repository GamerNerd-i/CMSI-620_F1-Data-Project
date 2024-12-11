-- for each driver, find the constructor they have driven for most.
create temporary table most_common_team as
select driverId, constructorId
from race_results
group by driverId, constructorId
having count(*) = (
    select max(team_count)
    from (
        select driverId, constructorId, count(*) as team_count
        from race_results
        group by driverId, constructorId
    ) team_counts
    where team_counts.driverId = race_results.driverId
);

select 
    concat(driver_details.forename, ' ', driver_details.surname) as driverName, 
    team_details.name as teamName
from most_common_team
left join driver_details on driver_details.driverId = most_common_team.driverId
left join team_details on team_details.constructorId = most_common_team.constructorId;
drop table most_common_team;