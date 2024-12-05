ALTER TABLE circuits
RENAME COLUMN name TO circuitName;

ALTER TABLE circuits
RENAME COLUMN url TO circuitUrl;

ALTER TABLE race_schedule
RENAME COLUMN name TO raceName;

ALTER TABLE race_schedule
RENAME COLUMN url TO raceUrl;

ALTER TABLE season_summaries
RENAME COLUMN url to seasonUrl;