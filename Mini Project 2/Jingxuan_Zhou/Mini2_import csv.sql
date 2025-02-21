-- Import csv file

-- Task: Create a table called `organizations` to store information about various organizations.
-- This table includes fields for organization details like ID, name, website, country, and more.

CREATE TABLE organizations (
  id INT AUTO_INCREMENT PRIMARY KEY,  -- MySQL uses AUTO_INCREMENT instead of SERIAL
  Organization_Id VARCHAR(255) NOT NULL,
  Name VARCHAR(255) NOT NULL,
  Website VARCHAR(255),
  Country VARCHAR(255),
  Description TEXT,
  Founded VARCHAR(5),
  Industry VARCHAR(255),
  Number_of_Employees INT
);

-- Task: Load data from a CSV file into the `organizations` table in MySQL.
-- This operation populates the table with rows from an external file.

LOAD DATA INFILE "C:\Users\jingx\OneDrive\Desktop\2024-2025\Spring 2025\ECON5200\mini_project_2\organizations-10000 (1).csv"
INTO TABLE organizations
FIELDS TERMINATED BY ','  -- Defines column separator
LINES TERMINATED BY '\n'  -- Defines row separator
IGNORE 1 ROWS  -- Ignores the first row (header)
(Organization_Id, Name, Website, Country, Description, Founded, Industry, Number_of_Employees);
