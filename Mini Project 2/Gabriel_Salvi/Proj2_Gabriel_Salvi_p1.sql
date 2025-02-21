-------------
-- TASK 1 --
-------------
-- CREATE TABLE organizations (
  Index SERIAL PRIMARY KEY,
  Organization_Id VARCHAR(255),
  Name VARCHAR(255),
  Website VARCHAR(255),
  Country VARCHAR(255),
  Description TEXT,
  Founded VARCHAR(5),
  Industry VARCHAR(255),
  Number_of_Employees INT
);
-------------
-- TASK 2 --
-------------
--copy public.organizations (Index,Organization_Id,Name,Website,Country,Description,Founded,Industry,Number_of_Employees)
FROM '/Users/gabesalvi/downloads/organizations-10000.csv'
DELIMITER ',' CSV HEADER;
