-- CREATE TABLE merged.race_info AS
-- SELECT * FROM
-- 	public.race_schedule
-- 	NATURAL LEFT JOIN public.season_summaries
-- 	NATURAL LEFT JOIN public.circuits;

-- CREATE TABLE merged.driver_info AS
-- SELECT * FROM
-- 	public.driver_rankings
-- 	NATURAL LEFT JOIN public.driver_details;

-- CREATE TABLE merged.constructor_info AS
-- SELECT * FROM
-- 	public.constructor_performance
-- 	NATURAL LEFT JOIN public.constructors;

-- CREATE TABLE merged.race_results AS
-- SELECT * FROM
-- 	public.race_results
-- 	NATURAL LEFT JOIN public.status;

-- CREATE TABLE merged.sprint_results AS
-- SELECT * FROM
-- 	public.race_results
-- 	NATURAL LEFT JOIN public.status;

CREATE TABLE merged.lap_times AS
SELECT * FROM
	public.lap_times
	NATURAL LEFT JOIN merged.race_info;

select * from merged.lap_times;