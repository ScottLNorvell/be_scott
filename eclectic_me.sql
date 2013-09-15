CREATE DATABASE be_scott;

CREATE TABLE scotts (
	id serial primary key,
	name varchar(50) DEFAULT 'Scott',
	gender varchar(5),
	type_of_scott varchar(50),
	password varchar(64) NOT NULL
	
);

CREATE TABLE mad_skills (
	id serial primary key,
	skill varchar(50) NOT NULL,
	genre varchar(50),
	scott_id serial,
	level smallint,
	FOREIGN KEY (scott_id)
	  REFERENCES scotts(id)
);

CREATE TABLE eclectic_instruments (
	id serial primary key,
	genre varchar(50),
	name varchar(50),
	playability_level smallint,
	scott_id serial,
	FOREIGN KEY (scott_id)
	  REFERENCES scotts(id)
);

-- ALTER TABLE scotts
-- ADD password varchar(64) not null;

-- ALTER TABLE scotts
-- DROP COLUMN birthday;

-- ALTER TABLE mad_skills
-- ADD skill varchar(50) NOT NULL;

-- ALTER TABLE eclectic_instruments
-- DROP COLUMN date_purchased;

-- CREATE TABLE orchestra (
-- 	id serial primary key,
-- 	location varchar(50),
-- 	number_of_players smallint,
-- 	conductor_name varchar(50)
-- );

-- CREATE TABLE musician (
-- 	id serial primary key,
-- 	instrument varchar(50),
-- 	chair smallint,
-- 	name varchar(50)
-- );