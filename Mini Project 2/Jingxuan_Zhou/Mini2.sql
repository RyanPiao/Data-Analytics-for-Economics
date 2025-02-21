USE data;
SELECT * FROM organizations;

-- Task 1
-- Task: Retrieve the first 20 rows of `Name` and `Country` from the `organizations` table.
-- 1. `SELECT Name, Country`: Fetches the `Name` and `Country` columns from the table.
-- 2. `FROM organizations`: Specifies the source table.
-- 3. `LIMIT 20`: Restricts the result to the first 20 rows.
SELECT Name, Country
FROM organizations
LIMIT 20;


-- Task 2
-- Task: Insert a new row into the `organizations` table with specific details about an organization.
-- `INSERT INTO organizations`: Specifies the target table where the new row will be added.
-- Lists the columns into which the values will be inserted.
INSERT INTO organizations (
  Organization_Id, Name, Website, Country, Description, Founded, Industry, Number_of_Employees
)
VALUES (
  'bC0CEd48A8000E0', 'Velazquez-Odom', 'https://stokes.com/', 'Djibouti',
  'Streamlined 6th generation function', '2002', 'Alternative Dispute Resolution', 4044
);

-- Explanation of New Code:
-- `WHERE Index = '100001'`: ( In My_SQL, we cannot apply index for filter, so I directly use the Name)
--  - Filters the rows in the `organizations` table to return only the row where the `Index` column equals `'100001'`.
--  - Ensures the query retrieves a specific organization based on its unique `Index` value.
SELECT *
FROM organizations
WHERE Name = 'Velazquez-Odom';


-- Task 3
-- Task: Find the minimum and maximum number of employees across all organizations.
-- 1. `MIN(Number_of_Employees) AS min_Number_of_Employees`: Calculates the smallest number of employees.
-- 2. `MAX(Number_of_Employees) AS max_Number_of_Employees`: Calculates the largest number of employees.

SELECT
    MIN(Number_of_Employees) AS min_Number_of_Employees,
    MAX(Number_of_Employees) AS max_Number_of_Employees
FROM organizations;

-- Task: Retrieve all rows from the `organizations` table where the number of employees is not specified (NULL).
-- `WHERE Number_of_Employees IS NULL`: Filters rows where the `Number_of_Employees` column has no value (NULL).

SELECT *
FROM organizations
WHERE
    Number_of_Employees IS NULL;
    
-- Task: Update the number of employees for a specific organization in the `organizations` table.
-- `UPDATE organizations`: Specifies the table to update.

SET SQL_SAFE_UPDATES = 0;
UPDATE organizations
SET Number_of_Employees = 3135
WHERE Organization_Id = '6CDCcdE3D0b7b44';
SET SQL_SAFE_UPDATES = 1; -- Re-enable safe update mode

-- Quick Check: 
SELECT Number_of_Employees
FROM organizations
WHERE Organization_Id = '6CDCcdE3D0b7b44';


-- Task 4
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


-- Task 5
-- Task: Calculate the length of the `Founded` column values for each organization. -- Explanation of Code: 
-- `SELECT LENGTH(Founded) AS years_founded`: Computes the number of characters in the `Founded` column for each row and labels it as `years_founded`. 

SELECT LENGTH(Founded) AS years_founded
FROM organizations;

-- Task: Retrieve the `Organization_Id`, `Country`, and `Founded` values for organizations where the `Founded` column has more than 4 characters. 
-- `WHERE LENGTH(Founded) > 4`: Filters rows to include only those where the `Founded` column contains more than 4 characters.

SELECT Organization_Id, Country, Founded
FROM organizations
WHERE LENGTH(Founded) > 4; 


-- Task 6
-- Task: Update the `Founded` year for a specific organization in the `organizations` table.
-- 1. `UPDATE organizations`: Specifies the table to update.
-- 2. `SET Founded = '1980'`: Sets the `Founded` column to '1980' for the specified row.
-- 3. `WHERE Organization_Id = '74FAA2BF6f0E0ed'`: Ensures only the row with the matching `Organization_Id` is updated.

SET SQL_SAFE_UPDATES = 0;
UPDATE organizations
SET Founded = '1980'
WHERE Organization_Id = '74FAA2BF6f0E0ed';
SET SQL_SAFE_UPDATES = 1; -- Re-enable safe update mode

-- Quick Check
SELECT Founded
FROM organizations
WHERE Organization_Id = '74FAA2BF6f0E0ed';

-- Task: Change the data type of the `Founded` column to `VARCHAR(4)` while ensuring existing data fits within the new type.
-- 1. `ALTER TABLE public.organizations`: Specifies the `organizations` table in the `public` schema to be modified.
-- 2. `ALTER COLUMN founded TYPE VARCHAR(4)`: Changes the data type of the `Founded` column to allow only 4 characters.
-- 3. `USING SUBSTRING(founded FROM 1 FOR 4)`: Truncates any existing values in the `Founded` column to their first 4 characters to ensure they fit the new type.

SET SQL_SAFE_UPDATES = 0;
UPDATE organizations
SET Founded = LEFT(Founded, 4);
ALTER TABLE organizations
MODIFY COLUMN Founded VARCHAR(4);
SET SQL_SAFE_UPDATES = 1;

-- Quick Check:
SELECT Founded FROM organizations;


-- Task 7
-- Task: Identify duplicate `Organization_Id` values and count how many times they occur.
-- 1. `SELECT Organization_Id, COUNT(*) AS Occurrences`: Retrieves the `Organization_Id` and the count of how often each ID appears, labeled as `Occurrences`.
-- 2. `FROM organizations`: Specifies the table to query.
-- 3. `GROUP BY Organization_Id`: Groups rows by the `Organization_Id` to aggregate counts for each unique ID.
-- 4. `HAVING COUNT(*) > 1`: Filters the results to include only `Organization_Id` values that appear more than once.

SELECT Organization_Id, COUNT(*) AS Occurrences
FROM organizations
GROUP BY Organization_Id
HAVING COUNT(*) > 1;


-- Task 8
-- Task: Retrieve the `Country` and `Number_of_Employees` for all organizations, sorted by the number of employees in descending order.
-- 1. `SELECT Country, Number_of_Employees`: Retrieves the country and the number of employees for each organization.
-- 2. `FROM organizations`: Specifies the table to query.
-- 3. `ORDER BY Number_of_Employees DESC`: Sorts the results in descending order based on the number of employees, showing the largest values first.

SELECT Country, Number_of_employees
FROM organizations
ORDER BY Number_of_employees DESC;


-- Task 9
-- Task: Retrieve the `Name`, `Country`, and formatted founding date of organizations founded between 1990 and 2000.
-- 1. `SELECT Name, Country, to_date(Founded, 'YYYY') AS Founded_Date`: Retrieves the organization's name, country, and converts the `Founded` column to a date format, labeled as `Founded_Date`.
-- 2. `FROM organizations`: Specifies the table to query.
-- 3. `WHERE to_date(Founded, 'YYYY') BETWEEN '1990-01-01' AND '2000-12-31'`: Filters rows where the `Founded` date falls between January 1, 1990, and December 31, 2000, inclusive.

SELECT Name, Country, STR_TO_DATE(Founded, '%Y') AS Founded_Date
FROM organizations
WHERE Founded REGEXP '^[0-9]{4}$' AND CAST(Founded AS UNSIGNED) BETWEEN 1990 AND 2000;

-- Alternative
-- CAST(Founded AS DATE) converts the Founded column into a DATE type.
-- The WHERE clause filters dates between January 1, 1990, and December 31, 2000.

SELECT Name, Country, STR_TO_DATE(Founded, '%Y') AS Founded_Date
FROM organizations
WHERE Founded REGEXP '^[0-9]{4}$' -- Ensure the Founded column has a valid 4-digit year
      AND CAST(Founded AS UNSIGNED) BETWEEN 1990 AND 2000;

-- Here is an example SQL query that also filters by the number of employees being between 2,000 and 3,000:
SELECT Name, Country, STR_TO_DATE(Founded, '%Y') AS Founded_Date, Number_of_Employees
FROM organizations
WHERE Founded REGEXP '^[0-9]{4}$' -- Ensure Founded contains valid 4-digit year values
      AND CAST(Founded AS UNSIGNED) BETWEEN 1990 AND 2000
	  AND Number_of_Employees BETWEEN 2000 AND 3000;

-- To group the counts of organizations by categories of Number_of_Employees and return exactly four rows, 
-- you can use a CASE statement along with GROUP BY. Here's how the query would look:      
SELECT
    CASE
        WHEN Number_of_Employees BETWEEN 0 AND 1000 THEN '0-1000'
        WHEN Number_of_Employees BETWEEN 1001 AND 2000 THEN '1001-2000'
        WHEN Number_of_Employees BETWEEN 2001 AND 3000 THEN '2001-3000'
        ELSE '3001+'
    END AS Employee_Range,
    COUNT(*) AS Count_of_Organizations
FROM organizations
WHERE Founded REGEXP '^[0-9]{4}$' -- Ensure Founded contains valid 4-digit year values
  AND CAST(Founded AS UNSIGNED) BETWEEN 1990 AND 2000
GROUP BY Employee_Range
ORDER BY Employee_Range;

-- To create a new column (firm_size) based on the employee ranges (0-1000, 1001-2000, etc.), 
-- you can use the ALTER TABLE command to add the column, 
-- followed by an UPDATE statement with a CASE statement to assign the values.
-- Step 1: Add the New Column firm_size

-- ALTER TABLE organizations
-- ADD COLUMN firm_size VARCHAR(10);

-- Step 2: Populate the firm_size Column

SET SQL_SAFE_UPDATES = 0;
UPDATE organizations
SET firm_size = CASE
WHEN Number_of_Employees BETWEEN 0 AND 1000 THEN 'Small'
WHEN Number_of_Employees BETWEEN 1001 AND 2000 THEN 'Medium'
WHEN Number_of_Employees BETWEEN 2001 AND 3000 THEN 'Large'
ELSE 'Very Large'
END;
SET SQL_SAFE_UPDATES = 1;

-- Step 3: Verify the Changes

SELECT Name, Number_of_Employees, firm_size
FROM organizations
LIMIT 20;

-- Task 10:  Turn Founded (CAST AS INTEGER) to a Date and Filter
-- use the CONCAT function along with a WHERE clause to find firms that are both more than 20 years old and classified as "Huge" (based on a threshold like Number_of_Employees > 6000).

-- Task: Identify firms that are more than 20 years old and classified as "Very Large" (employees > 3000). 
-- Combine the firm's name and country into a single column for easy readability. -- Explanation of Code: 
-- 1. `CONCAT(Name, ' - ', Country) AS Firm_Details`: Combines the `Name` and `Country` columns into a single string, separated by " - ". 
-- 2. `CAST(Founded AS INTEGER) <= EXTRACT(YEAR FROM CURRENT_DATE) - 20`:

SELECT CONCAT(Name, ' - ', Country) AS Firm_Details, Founded, Number_of_Employees
FROM organizations
WHERE Founded <= YEAR(CURDATE()) - 20 AND Number_of_Employees > 6000;  


-- Task 11
-- Task: Identify firms that are more than 20 years old and classified as "Very Large" (employees > 3000).
-- Combine the firm's name and country into a single column for easy readability.

SELECT CONCAT(Name, ' - ', Country) AS Firm_Details, Founded, Number_of_Employees
FROM organizations
WHERE Founded <= YEAR(CURDATE()) - 20  AND Number_of_Employees > 3000;


-- Task 12
-- Task: Extract the first word (most frequent) from the `Description` column after trimming unnecessary spaces.

SELECT TRIM(SUBSTRING(Description FROM '^[A-Za-z]+')) AS First_Word, COUNT(*) AS Frequency
FROM organizations
GROUP BY First_Word
ORDER BY Frequency DESC
LIMIT 20;


-- Task 13
-- Task: Increment the `Number_of_Employees` for each organization by 100
-- we can achieve the same goal without a loop using a single UPDATE statement

SET SQL_SAFE_UPDATES = 0;

UPDATE organizations
SET Number_of_Employees = COALESCE(Number_of_Employees, 0) + 100;

SET SQL_SAFE_UPDATES = 1;

/*
-- SQL Commands to Create the Tables and Insert Data
-- Create the Departments table
CREATE TABLE Departments (
    Department_ID INT PRIMARY KEY AUTO_INCREMENT,
    Department_Name VARCHAR(50) NOT NULL
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
    Employee_ID INT PRIMARY KEY AUTO_INCREMENT,
    Employee_Name VARCHAR(50) NOT NULL,
    Department_ID INT,
    FOREIGN KEY (Department_ID) REFERENCES Departments(Department_ID) ON DELETE SET NULL
);

-- Insert data into the Employees table
INSERT INTO Employees (Employee_ID, Employee_Name, Department_ID) VALUES
(101, 'Alice', 1),
(102, 'Bob', 2),
(103, 'Charlie', 3),
(104, 'Diana', NULL),  -- Employee without a department
(105, 'Eve', 4);
*/

-- Task 14
-- Task: Retrieve employees and their department names

SELECT Employees.Employee_ID, Employees.Employee_Name, Departments.Department_Name
FROM Employees
INNER JOIN Departments
ON Employees.Department_ID = Departments.Department_ID;


-- Task 15
-- Task: Retrieve all employees and their department names

SELECT Employees.Employee_ID, Employees.Employee_Name, Departments.Department_Name
FROM Employees
LEFT JOIN Departments
ON Employees.Department_ID = Departments.Department_ID;


-- Task 16
-- Task: Retrieve all departments and their employees

SELECT Departments.Department_ID, Departments.Department_Name, Employees.Employee_Name
FROM Employees
RIGHT JOIN Departments
ON Employees.Department_ID = Departments.Department_ID;
	

-- Task 17
-- Task: Retrieve all employees and departments
-- MySQL does not support FULL OUTER JOIN. Instead, you need to use a combination of LEFT JOIN and RIGHT JOIN with UNION to achieve the same result.

SELECT Employees.Employee_ID, Employees.Employee_Name, Departments.Department_Name
FROM Employees
LEFT JOIN Departments ON Employees.Department_ID = Departments.Department_ID
UNION
SELECT Employees.Employee_ID, Employees.Employee_Name, Departments.Department_Name
FROM Employees
RIGHT JOIN Departments ON Employees.Department_ID = Departments.Department_ID;

/*
-- Create tables and Populate data
-- Create the Warehouses table
CREATE TABLE Warehouses (
    warehouse_id INT PRIMARY KEY AUTO_INCREMENT,
    warehouse_name VARCHAR(50) NOT NULL,
    state CHAR(2) NOT NULL
);

-- Insert data into the Warehouses table
INSERT INTO Warehouses (warehouse_id, warehouse_name, state) VALUES
(1, 'Warehouse A', 'NY'),
(2, 'Warehouse B', 'CA'),
(3, 'Warehouse C', 'TX'),
(4, 'Warehouse D', 'FL');

-- Create the Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL
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

-- Create the Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    warehouse_id INT,
    customer_id INT,
    order_date DATE NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
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
*/


-- Task 18
-- Find the total number of orders placed by each warehouse using subquery.

SELECT warehouse_id, warehouse_name, (SELECT SUM(amount) FROM Orders) AS total_order_amount
FROM Warehouses;


-- Task 19
-- Calculate the total amount of orders for each warehouse, and then use the results as a table in the outer query.

SELECT W.warehouse_name, O.total_amount
FROM Warehouses AS W
INNER JOIN ( SELECT warehouse_id, SUM(amount) AS total_amount FROM Orders GROUP BY warehouse_id) AS O
ON W.warehouse_id = O.warehouse_id;


-- Task 20
-- Find the warehouses that processed orders for customers from specific cities (e.g., 'New York' or 'Dallas').

SELECT warehouse_name
FROM Warehouses
WHERE warehouse_id IN (SELECT DISTINCT warehouse_id FROM Orders WHERE customer_id 
						IN (SELECT customer_id FROM Customers WHERE city IN ('New York', 'Dallas')));
    

-- Task 21
-- Categorize warehouses based on the percentage of orders they fulfill, compared to the total orders.

SELECT W.warehouse_name, COUNT(O.order_id) AS number_of_orders,
CASE WHEN COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) <= 0.20 THEN '0-20% Orders' 
     WHEN COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) > 0.20 AND COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) <= 0.60 THEN '21-60% Orders'
	 ELSE 'More than 60% Orders'
     END AS fulfillment_category
FROM Warehouses AS W
LEFT JOIN Orders AS O
ON W.warehouse_id = O.warehouse_id
GROUP BY W.warehouse_id, W.warehouse_name;
