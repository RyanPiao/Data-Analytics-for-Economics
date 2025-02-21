--IF CREATE TABLE IF NOT EXISTS organizations 

CREATE TABLE organizations (
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

-- Task: Load data from a CSV file into the `organizations` table in the database. 
-- This operation populates the table with rows from an external file. 
-- 1. `COPY public.organizations`: Specifies the `organizations` table in the `public` schema where the data will be inserted. 
-- 2. `FROM 'G:/organizations-10000.csv'`: Provides the path to the CSV file that contains the data to be imported. 
-- 3. `DELIMITER ','`: Specifies that columns in the CSV file are separated by commas. 
-- 4. `CSV HEADER`: Indicates that the first row in the CSV file contains column names (headers), not data.

copy public.organizations (Index,Organization_Id,Name,Website,Country,Description,Founded,Industry,Number_of_Employees)
FROM '/tmp/organizations-10000.csv'
DELIMITER ',' CSV HEADER;

-- Task 1, Retrieves first 20 rows
SELECT 
  Name,
  Country
FROM organizations
LIMIT 20;

-- Task 2, Inserts new data
INSERT INTO organizations (
  Index, Organization_Id, Name, Website, Country, Description, Founded, Industry, Number_of_Employees
)
VALUES (
  100001, 'bC0CEd48A8000E0', 'Velazquez-Odom', 'https://stokes.com/', 'Djibouti',
  'Streamlined 6th generation function', '2002', 'Alternative Dispute Resolution', 4044
);

-- Task 2, Checks that a specific organization can be retrieved by index
SELECT *
FROM organizations
WHERE Index = '100001';

-- Task 3, Checks largest and smallest number of employees
SELECT
    MIN(Number_of_Employees) AS min_Number_of_Employees,
    MAX(Number_of_Employees) AS max_Number_of_Employees
FROM organizations;

-- Task 3, Checks for null values in Number_of_Employees
SELECT *
FROM organizations
WHERE
    Number_of_Employees IS NULL;

-- Task 3, Updates employee count for a specific organization
UPDATE organizations
SET Number_of_Employees = '3135'
WHERE Organization_Id = '6CDCcdE3D0b7b44';

-- Task 3, Fetches all columns
SELECT *
FROM organizations
WHERE Organization_Id = '6CDCcdE3D0b7b44';

-- Task 4, Retrieves unique values in "Industry"
SELECT DISTINCT Industry
FROM organizations;

-- Task 4, Counts rows by industry
SELECT
     Industry,
     COUNT(*) AS count_by_industry
FROM organizations
GROUP BY Industry
ORDER BY count_by_industry DESC;

-- Task 4, Counts unique countries represented in each industry

SELECT
    Industry,
    COUNT(DISTINCT Country) AS Number_of_Countries
FROM organizations
GROUP BY Industry
ORDER BY Number_of_Countries DESC;

-- Task 5, Checks length of "Founded" column for all organizations
SELECT
  LENGTH(Founded) AS years_founded
FROM organizations;

-- Task 5, Returns countries where "Founded" is longer than 4 characters.
SELECT
     Organization_Id, Country, Founded
FROM organizations
WHERE LENGTH(Founded) > 4; 

-- Task 6, Updates Rows and datatypes
UPDATE organizations
SET Founded = '1980'
WHERE Organization_Id = '74FAA2BF6f0E0ed';

-- Task 6, Changes column to only allow 4 characters
ALTER TABLE public.organizations
ALTER COLUMN founded TYPE VARCHAR(4)
USING SUBSTRING(founded FROM 1 FOR 4);

-- Task 7, Find duplicates
SELECT
Organization_Id,
COUNT(*) AS Occurrences
FROM organizations
GROUP BY Organization_Id
HAVING COUNT(*) > 1;

-- Task 7, Cleans rows (without optional dropping of old table)
DROP TABLE IF EXISTS organizations_clean;
CREATE TABLE organizations_clean AS
SELECT DISTINCT ON (Organization_Id) *
FROM organizations
ORDER BY Organization_Id, Index;

-- Task 8, Number of employees by organizations' workforce
SELECT
    Country,
    Number_of_employees
FROM organizations
ORDER BY Number_of_employees DESC;

-- Task 9, Convert the founded column to a "date" type and filter between 1990 and 2000
SELECT
    Name,
    Country,
    to_date(Founded, 'YYYY') AS Founded_Date
FROM organizations
WHERE to_date(Founded, 'YYYY') BETWEEN '1990-01-01' AND '2000-12-31';

-- Optional Alternate Method

-- Filter between 1990 and 2000
-- SELECT
--     Name,
--     Country,
--     to_date(Founded, 'YYYY') AS Founded_Date
--FROM organizations
--WHERE CAST(Founded AS INTEGER) BETWEEN 1990 AND 2000;

-- Filters by employees between 2000 and 3000
--SELECT
--     Name,
--     Country,
--     to_date(Founded, 'YYYY') AS Founded_Date,
--     Number_of_Employees
--FROM organizations
--WHERE CAST(Founded AS INTEGER) BETWEEN 1990 AND 2000
--    AND Number_of_Employees BETWEEN 2000 AND 3000;

-- Groups counts of organizations by categories of number of employee ranges
--SELECT
--    CASE
--        WHEN Number_of_Employees BETWEEN 0 AND 1000 THEN '0-1000'
--        WHEN Number_of_Employees BETWEEN 1001 AND 2000 THEN '1001-2000'
--        WHEN Number_of_Employees BETWEEN 2001 AND 3000 THEN '2001-3000'
--        ELSE '3001+'
--    END AS Employee_Range,
--    COUNT(*) AS Count_of_Organizations
--FROM organizations
--WHERE CAST(Founded AS INTEGER) BETWEEN 1990 AND 2000
--GROUP BY Employee_Range
--ORDER BY Employee_Range;

-- Creates new column representing firm size
--ALTER TABLE organizations
--ADD COLUMN firm_size VARCHAR(10);

--UPDATE organizations
--SET firm_size = CASE
--WHEN Number_of_Employees BETWEEN 0 AND 1000 THEN 'Small'
--WHEN Number_of_Employees BETWEEN 1001 AND 2000 THEN 'Medium'
--WHEN Number_of_Employees BETWEEN 2001 AND 3000 THEN 'Large'
--ELSE 'Very Large'
--END;

-- SELECT Name, Number_of_Employees, firm_size
-- FROM organizations
-- LIMIT 20;

-- Task 10, Finds where firms are > 20 years old and "huge"

SELECT
    CONCAT(Name, ' - ', Country) AS Firm_Details,
    Founded,
    Number_of_Employees
FROM organizations
WHERE
    CAST(Founded AS INTEGER) <= EXTRACT(YEAR FROM CURRENT_DATE) - 20 -- Firms older than 20 years
    AND Number_of_Employees > 6000; -- Huge firms

-- Task 11,(REPEAT OF STEP 10) Finds firms > 20 years old and huge
--SELECT
--    CONCAT(Name, ' - ', Country) AS Firm_Details,
--    Founded,
--    Number_of_Employees
--FROM organizations
--WHERE
--    CAST(Founded AS INTEGER) <= EXTRACT(YEAR FROM CURRENT_DATE) - 20 -- Firms older than 20 years
--    AND Number_of_Employees > 6000; -- Huge firms

-- Task 12, Find most frequent word in description column after trimming
SELECT
    TRIM(SUBSTRING(Description FROM '^[A-Za-z]+')) AS First_Word,
    COUNT(*) AS Frequency
FROM organizations
GROUP BY First_Word
ORDER BY Frequency DESC
LIMIT 20;

-- Task 13, Increments number of employees by 100 for each organization
-- THIS QUERY OCCASIONALLY THROWS THE FOLLOWING ERROR AND IS WILDLY INEFFICIENT AND SO
-- HAS BEEN COMMENETED OUT
--: ERROR:  unterminated dollar-quoted string at or near "$$;"


--DO $$
--DECLARE
--    org_id VARCHAR;
--BEGIN
    -- Create a loop to iterate through all rows
--    FOR org_id IN
--        SELECT Organization_Id
--        FROM organizations
--    LOOP
--        -- Update each row's Number_of_Employees by adding 100
--       UPDATE organizations
--        SET Number_of_Employees = COALESCE(Number_of_Employees, 0) + 100
--        WHERE Organization_Id = org_id;
--    END LOOP;
--END $$;

-- EFFICIENT LOOP REPLACEMENT
UPDATE organizations
SET Number_of_Employees = COALESCE(Number_of_Employees, 0) + 100;

-- Creates and populates departments and employees tables
CREATE TABLE Departments (
    Department_ID INT PRIMARY KEY,
    Department_Name VARCHAR(50)
);

INSERT INTO Departments (Department_ID, Department_Name) VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'Engineering'),
(4, 'Sales'),
(5, 'Service');
CREATE TABLE Employees (
    Employee_ID INT PRIMARY KEY,
    Employee_Name VARCHAR(50),
    Department_ID INT
);
INSERT INTO Employees (Employee_ID, Employee_Name, Department_ID) VALUES
(101, 'Alice', 1),
(102, 'Bob', 2),
(103, 'Charlie', 3),
(104, 'Diana', NULL),
(105, 'Eve', 4);

-- Task 14, Combines employees and departments
SELECT
    Employees.Employee_ID,
    Employees.Employee_Name,
    Departments.Department_Name
FROM
    Employees
INNER JOIN
    Departments
ON
    Employees.Department_ID = Departments.Department_ID;

-- Task 15, Uses right join to return all departments
	SELECT
    Departments.Department_ID,
    Departments.Department_Name,
    Employees.Employee_Name
FROM
    Employees
RIGHT JOIN
    Departments
ON
    Employees.Department_ID = Departments.Department_ID;

	-- Task 17, Inner join to return employees and departments
SELECT
    Employees.Employee_ID,
    Employees.Employee_Name,
    Departments.Department_Name
FROM
    Employees
FULL OUTER JOIN
    Departments
ON
    Employees.Department_ID = Departments.Department_ID;


-- PRACTICE WITH SUB-QUERIES
-- Create the Warehouses table
CREATE TABLE Warehouses (
    warehouse_id INT PRIMARY KEY,
    warehouse_name VARCHAR(50),
    state VARCHAR(2)
);

-- Insert data into the Warehouses table
INSERT INTO Warehouses (warehouse_id, warehouse_name, state) VALUES
(1, 'Warehouse A', 'NY'),
(2, 'Warehouse B', 'CA'),
(3, 'Warehouse C', 'TX'),
(4, 'Warehouse D', 'FL');

-- Create the Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    warehouse_id INT,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10, 2)
);

-- Insert data into the Orders table
INSERT INTO Orders (order_id, warehouse_id, customer_id, order_date, amount) VALUES
(101, 1, 201, '2025-01-01', 500.00),
(102, 1, 202, '2025-01-02', 300.00),
(103, 2, 203, '2025-01-01', 700.00),
(104, 3, 204, '2025-01-03', 200.00),
(105, 4, 205, '2025-01-04', 100.00),
(106, 2, 206, '2025-01-04', 400.00),
(107, 3, 207, '2025-01-05', 250.00);

-- Create the Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50)
);

-- Insert data into the Customers table
INSERT INTO Customers (customer_id, customer_name, city) VALUES
(201, 'Alice', 'New York'),
(202, 'Bob', 'San Francisco'),
(203, 'Charlie', 'Los Angeles'),
(204, 'Diana', 'Houston'),
(205, 'Eve', 'Miami'),
(206, 'Frank', 'Sacramento'),
(207, 'Grace', 'Dallas');

-- Task 18, Total orders placed by warehouse using subquery
SELECT
    warehouse_id,
    warehouse_name,
    (SELECT SUM(amount) FROM Orders) AS total_order_amount
FROM
    Warehouses;

-- Task 19, Subquery to calculate total orders from each warehouse
SELECT
    W.warehouse_name,
    O.total_amount
FROM
    Warehouses AS W
INNER JOIN (
    SELECT
        warehouse_id,
        SUM(amount) AS total_amount
    FROM
        Orders
    GROUP BY
        warehouse_id
) AS O
ON
    W.warehouse_id = O.warehouse_id;

-- 20, Subquery to find warehouses that processed orders from certain cities
SELECT
    warehouse_name
FROM
    Warehouses
WHERE
    warehouse_id IN (
        SELECT DISTINCT warehouse_id
        FROM Orders
        WHERE customer_id IN (
            SELECT customer_id
            FROM Customers
            WHERE city IN ('New York', 'Dallas')
        )
    );

-- Task 21, Categorizes warehourses by percentage of orders they have fulfilled
SELECT
    W.warehouse_name,
    COUNT(O.order_id) AS number_of_orders,
    CASE
        WHEN COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) <= 0.25 THEN '0-25% Orders'
        WHEN COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) > 0.26 AND COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) <= 0.50 THEN '26-50% Orders'
        WHEN COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) > 0.26 AND COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) <= 0.75 THEN '51-75% Orders'        
		ELSE 'More than 75% of Orders'
    END AS fulfillment_category
FROM
    Warehouses AS W
LEFT JOIN Orders AS O
ON W.warehouse_id = O.warehouse_id
GROUP BY
    W.warehouse_id, W.warehouse_name;



