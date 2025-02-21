-- Task: Create a table called `organizations` to store information about various organizations. 
-- This table includes fields for organization details like ID, name, website, country, and more.
-- Explanation of Code: `CREATE TABLE organizations`: Creates a new table named `organizations`.
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
-- Explanation of Code: 
-- 1. `COPY public.organizations`: Specifies the `organizations` table in the `public` schema where the data will be inserted. 
-- 2. `FROM 'G:/organizations-10000.csv'`: Provides the path to the CSV file that contains the data to be imported. 
-- 3. `DELIMITER ','`: Specifies that columns in the CSV file are separated by commas. 
-- 4. `CSV HEADER`: Indicates that the first row in the CSV file contains column names (headers), not data.
copy public.organizations (Index,Organization_Id,Name,Website,Country,Description,Founded,Industry,Number_of_Employees)
FROM 'F:/sql/organizations-10000.csv'
DELIMITER ',' CSV HEADER;


-- Task: Retrieve the first 20 rows of `Name` and `Country` from the `organizations` table.

-- Explanation of Code:
-- 1. `SELECT Name, Country`: Fetches the `Name` and `Country` columns from the table.
-- 2. `FROM organizations`: Specifies the source table.
-- 3. `LIMIT 20`: Restricts the result to the first 20 rows.
SELECT 
  Name,
  Country
FROM organizations
LIMIT 20;


-- Task: Insert a new row into the `organizations` table with specific details about an organization.
-- `INSERT INTO organizations`: Specifies the target table where the new row will be added.
-- Lists the columns into which the values will be inserted.
INSERT INTO organizations (
  Index, Organization_Id, Name, Website, Country, Description, Founded, Industry, Number_of_Employees
)
VALUES (
  100001, 'bC0CEd48A8000E0', 'Velazquez-Odom', 'https://stokes.com/', 'Djibouti',
  'Streamlined 6th generation function', '2002', 'Alternative Dispute Resolution', 4044
);


-- Task: Retrieve all details of the organization with the specific `Index` value of 100001.
-- `WHERE Index = '100001'`: Filters the results to only include the row where the `Index` column equals 100001.
SELECT *
FROM organizations
WHERE Index = '100001'


-- Task: Find the minimum and maximum number of employees across all organizations.
-- 1. `MIN(Number_of_Employees) AS min_Number_of_Employees`: Calculates the smallest number of employees.
-- Ans: the minimum number of employee is 1.
-- 2. `MAX(Number_of_Employees) AS max_Number_of_Employees`: Calculates the largest number of employees.
-- Ans: the maximum number of employee is 9999. 

SELECT
    MIN(Number_of_Employees) AS min_Number_of_Employees,
    MAX(Number_of_Employees) AS max_Number_of_Employees
FROM organizations;


-- Task: Retrieve all rows from the `organizations` table where the number of employees is not specified (NULL).
-- `WHERE Number_of_Employees IS NULL`: Filters rows where the `Number_of_Employees` column has no value (NULL).
-- Ans: There are no columns containing null values.
SELECT *
FROM organizations
WHERE
    Number_of_Employees IS NULL;


-- Task: Update the number of employees for a specific organization in the `organizations` table.
-- `UPDATE organizations`: Specifies the table to update.
UPDATE organizations
SET Number_of_Employees = '3135'
WHERE Organization_Id = '6CDCcdE3D0b7b44';


-- Task: Retrieve all details of the organization with a specific `Organization_Id`.
-- `SELECT *`: Fetches all columns from the table.
-- Ans: The number of employees has been updated as 3135.

SELECT *
FROM organizations
WHERE Organization_Id = '6CDCcdE3D0b7b44'


-- Task: Retrieve a list of unique industries from the `organizations` table. 
-- `SELECT DISTINCT Industry`: Ensures that only distinct (unique) values from the `Industry` column are retrieved. 
SELECT DISTINCT Industry
FROM organizations;


-- Task: Count the number of organizations in each industry and list them in descending order of count.
-- 1. `SELECT Industry, COUNT(*) AS count_by_industry`: Retrieves the industry name and the number of organizations in each industry.

-- 2. `FROM organizations`: Specifies the table to query.

-- 3. `GROUP BY Industry`: Groups the rows by the `Industry` column to calculate counts for each industry.

-- 4. `ORDER BY count_by_industry DESC`: Sorts the results by the count in descending order, showing the most represented industries first.

SELECT
     Industry,
     COUNT(*) AS count_by_industry
FROM organizations
GROUP BY Industry
ORDER BY count_by_industry DESC;


-- Task: Count the number of distinct countries represented in each industry and sort them by the number of countries in descending order. 

-- `SELECT Industry, COUNT(DISTINCT Country) AS Number_of_Countries`: Retrieves the industry name and the count of unique countries in each industry. 

SELECT
    Industry,
    COUNT(DISTINCT Country) AS Number_of_Countries
FROM organizations
GROUP BY Industry
ORDER BY Number_of_Countries DESC;


-- Task: Calculate the length of the `Founded` column values for each organization. -- Explanation of Code: 
-- `SELECT LENGTH(Founded) AS years_founded`: Computes the number of characters in the `Founded` column for each row and labels it as `years_founded`. 
SELECT
  LENGTH(Founded) AS years_founded
FROM organizations;


-- Task: Retrieve the `Organization_Id`, `Country`, and `Founded` values for organizations where the `Founded` column has more than 4 characters. 
-- `WHERE LENGTH(Founded) > 4`: Filters rows to include only those where the `Founded` column contains more than 4 characters.
SELECT
     Organization_Id, Country, Founded
FROM organizations
WHERE LENGTH(Founded) > 4; 


-- Task: Update the `Founded` year for a specific organization in the `organizations` table.
-- 1. `UPDATE organizations`: Specifies the table to update.
-- 2. `SET Founded = '1980'`: Sets the `Founded` column to '1980' for the specified row.
-- 3. `WHERE Organization_Id = '74FAA2BF6f0E0ed'`: Ensures only the row with the matching `Organization_Id` is updated.
UPDATE organizations
SET Founded = '1980'
WHERE Organization_Id = '74FAA2BF6f0E0ed';


-- Task: Change the data type of the `Founded` column to `VARCHAR(4)` while ensuring existing data fits within the new type.
-- 1. `ALTER TABLE public.organizations`: Specifies the `organizations` table in the `public` schema to be modified.
-- 2. `ALTER COLUMN founded TYPE VARCHAR(4)`: Changes the data type of the `Founded` column to allow only 4 characters.
-- 3. `USING SUBSTRING(founded FROM 1 FOR 4)`: Truncates any existing values in the `Founded` column to their first 4 characters to ensure they fit the new type.

ALTER TABLE public.organizations
ALTER COLUMN founded TYPE VARCHAR(4)
USING SUBSTRING(founded FROM 1 FOR 4);


-- Task: Identify duplicate `Organization_Id` values and count how many times they occur.
-- 1. `SELECT Organization_Id, COUNT(*) AS Occurrences`: Retrieves the `Organization_Id` and the count of how often each ID appears, labeled as `Occurrences`.
-- 2. `FROM organizations`: Specifies the table to query.
-- 3. `GROUP BY Organization_Id`: Groups rows by the `Organization_Id` to aggregate counts for each unique ID.
-- 4. `HAVING COUNT(*) > 1`: Filters the results to include only `Organization_Id` values that appear more than once.
SELECT
Organization_Id,
COUNT(*) AS Occurrences
FROM organizations
GROUP BY Organization_Id
HAVING COUNT(*) > 1;



-- Task: Remove duplicate rows based on `Organization_Id`, keeping only the first occurrence, and optionally replace the original table.
-- `SELECT DISTINCT ON (Organization_Id) *`: Ensures only one row per unique `Organization_Id` is selected. 
-- `DROP TABLE organizations;`: Deletes the original table if it is no longer needed.
-- `ALTER TABLE organizations_clean RENAME TO organizations;`: Renames the cleaned table to replace the original table name.
CREATE TABLE organizations_clean AS
SELECT DISTINCT ON (Organization_Id) *
FROM organizations
ORDER BY Organization_Id, Index;

-- ⚠️Optional: Drop the original table and rename the new one
DROP TABLE organizations;
ALTER TABLE organizations_clean RENAME TO organizations;


-- Task: Retrieve the `Country` and `Number_of_Employees` for all organizations, sorted by the number of employees in descending order.
-- 1. `SELECT Country, Number_of_Employees`: Retrieves the country and the number of employees for each organization.
-- 2. `FROM organizations`: Specifies the table to query.
-- 3. `ORDER BY Number_of_Employees DESC`: Sorts the results in descending order based on the number of employees, showing the largest values first.
SELECT
    Country,
    Number_of_employees
FROM organizations
ORDER BY Number_of_employees DESC;


-- Task: Retrieve the `Name`, `Country`, and formatted founding date of organizations founded between 1990 and 2000.
-- 1. `SELECT Name, Country, to_date(Founded, 'YYYY') AS Founded_Date`: Retrieves the organization's name, country, and converts the `Founded` column to a date format, labeled as `Founded_Date`.
-- 2. `FROM organizations`: Specifies the table to query.
-- 3. `WHERE to_date(Founded, 'YYYY') BETWEEN '1990-01-01' AND '2000-12-31'`: Filters rows where the `Founded` date falls between January 1, 1990, and December 31, 2000, inclusive.
SELECT
    Name,
    Country,
    to_date(Founded, 'YYYY') AS Founded_Date
FROM organizations
WHERE to_date(Founded, 'YYYY') BETWEEN '1990-01-01' AND '2000-12-31';


-- Task: Use the WHERE and CAST clause filters dates between January 1, 1990, and December 31, 2000.
SELECT
     Name,
     Country,
     to_date(Founded, 'YYYY') AS Founded_Date
FROM organizations
WHERE CAST(Founded AS INTEGER) BETWEEN 1990 AND 2000;


-- Task: Use the WHERE and CAST clause filters dates between January 1, 1990, and December 31, 2000 and also filters by the number of employees being between 2,000 and 3,000.
SELECT
     Name,
     Country,
     to_date(Founded, 'YYYY') AS Founded_Date,
     Number_of_Employees
FROM organizations
WHERE CAST(Founded AS INTEGER) BETWEEN 1990 AND 2000
     AND Number_of_Employees BETWEEN 2000 AND 3000;

-- Task: To group the counts of organizations by categories of Number_of_Employees and return exactly four rows, you can use a CASE statement along with GROUP BY
SELECT
    CASE
        WHEN Number_of_Employees BETWEEN 0 AND 1000 THEN '0-1000'
        WHEN Number_of_Employees BETWEEN 1001 AND 2000 THEN '1001-2000'
        WHEN Number_of_Employees BETWEEN 2001 AND 3000 THEN '2001-3000'
        ELSE '3001+'
    END AS Employee_Range,
    COUNT(*) AS Count_of_Organizations
FROM organizations
WHERE CAST(Founded AS INTEGER) BETWEEN 1990 AND 2000
GROUP BY Employee_Range
ORDER BY Employee_Range;

-- Step 1: Add the New Column firm_size
ALTER TABLE organizations
ADD COLUMN firm_size VARCHAR(10);
-- Step 2: Populate the firm_size Column
UPDATE organizations
SET firm_size = CASE
    WHEN Number_of_Employees BETWEEN 0 AND 1000 THEN 'Small'
    WHEN Number_of_Employees BETWEEN 1001 AND 2000 THEN 'Medium'
    WHEN Number_of_Employees BETWEEN 2001 AND 3000 THEN 'Large'
    ELSE 'Very Large'
END;
-- Step 3: Verify the Changes
SELECT Name, Number_of_Employees, firm_size
FROM organizations
LIMIT 20;


-- Task: Identify firms that are more than 20 years old and classified as "Very Large" (employees > 3000). 
-- Combine the firm's name and country into a single column for easy readability. -- Explanation of Code: 
-- 1. `CONCAT(Name, ' - ', Country) AS Firm_Details`: Combines the `Name` and `Country` columns into a single string, separated by " - ". 
-- 2. `CAST(Founded AS INTEGER) <= EXTRACT(YEAR FROM CURRENT_DATE) - 20`:
SELECT
    CONCAT(Name, ' - ', Country) AS Firm_Details,
    Founded,
    Number_of_Employees
FROM organizations
WHERE
    CAST(Founded AS INTEGER) <= EXTRACT(YEAR FROM CURRENT_DATE) - 20 -- Firms older than 20 years
    AND Number_of_Employees > 6000; -- Huge firms


-- Task: Identify firms that are more than 20 years old and classified as "Very Large" (employees > 3000).
-- Handle potential NULL values in `Number_of_Employees` and `Founded` columns using `COALESCE`.
SELECT 
    CONCAT(Name, ' - ', Country) AS Firm_Details,
    COALESCE(CAST(Founded AS INTEGER), 0) AS Founded_Year, -- Replace NULL in `Founded` with 0
    COALESCE(Number_of_Employees, 0) AS Employee_Count -- Replace NULL in `Number_of_Employees` with 0
FROM organizations
WHERE 
    COALESCE(CAST(Founded AS INTEGER), 0) <= EXTRACT(YEAR FROM CURRENT_DATE) - 20 -- Firms older than 20 years
    AND COALESCE(Number_of_Employees, 0) > 3000; -- Very Large firms


-- Task: Identify firms that are more than 20 years old and classified as "Very Large" (employees > 3000). 
-- Combine the firm's name and country into a single column for easy readability. -- Explanation of Code: 
-- 1. `CONCAT(Name, ' - ', Country) AS Firm_Details`: Combines the `Name` and `Country` columns into a single string, separated by " - ". 
-- 2. `CAST(Founded AS INTEGER) <= EXTRACT(YEAR FROM CURRENT_DATE) - 20`:
SELECT
    CONCAT(Name, ' - ', Country) AS Firm_Details,
    Founded,
    Number_of_Employees
FROM organizations
WHERE
    CAST(Founded AS INTEGER) <= EXTRACT(YEAR FROM CURRENT_DATE) - 20 -- Firms older than 20 years
    AND Number_of_Employees > 6000; -- Huge firms


-- Task: Extract the first word (most frequent) from the `Description` column after trimming unnecessary spaces.
SELECT
    TRIM(SUBSTRING(Description FROM '^[A-Za-z]+')) AS First_Word,
    COUNT(*) AS Frequency
FROM organizations
GROUP BY First_Word
ORDER BY Frequency DESC
LIMIT 20;


-- Use this when you want to ensure the table is deleted before recreating it
DROP TABLE IF EXISTS organizations;


-- Task: Increment the `Number_of_Employees` for each organization by 100 using a loop.
DO $$
DECLARE
    org_id VARCHAR;
BEGIN
    -- Create a loop to iterate through all rows
    FOR org_id IN
        SELECT Organization_Id
        FROM organizations
    LOOP
        -- Update each row's Number_of_Employees by adding 100
        UPDATE organizations
        SET Number_of_Employees = COALESCE(Number_of_Employees, 0) + 100
        WHERE Organization_Id = org_id;
    END LOOP;
END $$;

-- Create the Departments table
CREATE TABLE Departments (
    Department_ID INT PRIMARY KEY,
    Department_Name VARCHAR(50)
);

-- Insert data into the Departments table
INSERT INTO Departments (Department_ID, Department_Name) VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'Engineering'),
(4, 'Sales'),
(5, 'Service');

-- Create the Employees table
CREATE TABLE Employees (
    Employee_ID INT PRIMARY KEY,
    Employee_Name VARCHAR(50),
    Department_ID INT
);

-- Insert data into the Employees table
INSERT INTO Employees (Employee_ID, Employee_Name, Department_ID) VALUES
(101, 'Alice', 1),
(102, 'Bob', 2),
(103, 'Charlie', 3),
(104, 'Diana', NULL),
(105, 'Eve', 4);

-- Task 14: Retrieve employees and their department names
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

-- Task 15: Retrieve all employees and their department names
SELECT
    Employees.Employee_ID,
    Employees.Employee_Name,
    Departments.Department_Name
FROM
    Employees
LEFT JOIN
    Departments
ON
    Employees.Department_ID = Departments.Department_ID;

-- Task 16: Retrieve all departments and their employees
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


-- Task 17: Retrieve all employees and departments
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


-- SQL Practice with Subqueries: Create tables and Populate data
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

-- Task 18
SELECT
    warehouse_id,
    warehouse_name,
    (SELECT SUM(amount) FROM Orders) AS total_order_amount
FROM
    Warehouses;

-- Exercise
SELECT
    warehouse_id,
    warehouse_name,
    (SELECT AVG(amount) FROM Orders) AS average_order_amount
FROM
    Warehouses;

-- Task 19
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

--Exercise:
SELECT
    W.warehouse_name,
    O.total_orders
FROM
    Warehouses AS W
INNER JOIN (
    SELECT
        warehouse_id,
        COUNT(*) AS total_orders
    FROM
        Orders
    GROUP BY
        warehouse_id
) AS O
ON
    W.warehouse_id = O.warehouse_id;

-- Task 20: 
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

-- Exercise:
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
            WHERE city NOT IN ('New York', 'Dallas')
        )
    );    

--TASK 21:
SELECT
    W.warehouse_name,
    COUNT(O.order_id) AS number_of_orders,
    CASE
        WHEN COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) <= 0.20 THEN '0-20% Orders'
        WHEN COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) > 0.20 AND COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) <= 0.60 THEN '21-60% Orders'
        ELSE 'More than 60% Orders'
    END AS fulfillment_category
FROM
    Warehouses AS W
LEFT JOIN Orders AS O
ON W.warehouse_id = O.warehouse_id
GROUP BY
    W.warehouse_id, W.warehouse_name;

-- Exercise:
SELECT
    W.warehouse_name,
    COUNT(O.order_id) AS number_of_orders,
    CASE
        WHEN COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) <= 0.25 THEN '0-25% Orders'
        WHEN COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) > 0.25 AND COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) <= 0.50 THEN '26-50% Orders'
        ELSE 'More than 50% Orders'
    END AS fulfillment_category
FROM
    Warehouses AS W
LEFT JOIN Orders AS O
ON W.warehouse_id = O.warehouse_id
GROUP BY
    W.warehouse_id, W.warehouse_name;

