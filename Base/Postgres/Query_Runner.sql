do
$$
declare 
  i record;
begin
  for i in 1..1000 loop

  
PERFORM ti.name, count(circuitId) as num_of_races from track_information as ti
join race_schedule using(circuitId)
group by ti.name
order by num_of_races desc;


  end loop;
end;
$$
;