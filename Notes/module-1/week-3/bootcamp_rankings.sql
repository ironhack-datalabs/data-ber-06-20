CREATE DATABASE bootcamp_rankings;

USE bootcamp_rankings;

CREATE TABLE coding (
    date_id DATE,
    `rank` INT,
    name TEXT,
    rating FLOAT,
    stars FLOAT,
    reviews INT,
    locations TEXT,
    description TEXT);

CREATE TABLE data_science (
    date_id DATE,
    `rank` INT,
    name TEXT,
    rating FLOAT,
    stars FLOAT,
    reviews INT,
    locations TEXT,
    description TEXT);

CREATE TABLE online (
    date_id DATE,
    `rank` INT,
    name TEXT,
    rating FLOAT,
    stars FLOAT,
    reviews INT,
    locations TEXT,
    description TEXT);

-- INSERTING ROWS INTO A TABLE

INSERT INTO coding VALUES
    ('2020-06-15',
     1,
     'Flatiron School',
     4.69,
     4.5,
     445,
     'Brooklyn|Washington|Houston',
     'I am a description'),
    ('2020-06-15',
     1,
     'Flatiron School',
     4.69,
     4.5,
     445,
     'Brooklyn|Washington|Houston',
     'I am a description'),
    ('2020-06-15',
     1,
     'Flatiron School',
     4.69,
     4.5,
     445,
     'Brooklyn|Washington|Houston',
     'I am a description');

SELECT * FROM coding;
SELECT * FROM data_science;
SELECT * FROM online;

TRUNCATE data_science;

DELETE FROM coding;
-- WHERE [...];

DROP TABLE coding;

SELECT *
FROM coding
WHERE `rank` < 10;


ALTER TABLE coding RENAME TO coding_wrong;

INSERT INTO coding (
    SELECT DISTINCT *
    FROM coding_wrong
);

DROP TABLE coding_wrong;