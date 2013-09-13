# Relationships

## I have many eclectic musical instruments
- ME
	-id ~ serial
	-gender ~ string
	-skills ~ string
	-name ~ string
	-birthday ~ timestamp

- SKILLS
	-genre ~ string
	-level ~ integer

- ECLECTIC_INSTRUMENT
	-genre ~ string
	-name ~ string
	-accessories ~ string
	-playability_level ~ integer
	-date_purchased ~ timestamp

## An orchestra has many musicians

- ORCHESTRA
	-location ~ string
	-number_of_players ~ integer
	-conductor_name ~ string

- MUSICIAN
	-instrument ~ string
	-chair ~ integer
	-name ~ string