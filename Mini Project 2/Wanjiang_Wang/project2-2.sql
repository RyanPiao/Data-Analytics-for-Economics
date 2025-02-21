-- step 1
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

-- step 2
-- import data, has permission issue

-- step 3
SELECT *
FROM organizations
LIMIT 20;

SELECT 
  Name,
  Country
FROM organizations
LIMIT 20;

-- step 4
INSERT INTO organizations (
  Index, Organization_Id, Name, Website, Country, Description, Founded, Industry, Number_of_Employees
)
VALUES (
  100001, 'bC0CEd48A8000E0', 'Velazquez-Odom', 'https://stokes.com/', 'Djibouti',
  'Streamlined 6th generation function', '2002', 'Alternative Dispute Resolution', 4044
);

-- check
SELECT *
FROM organizations
WHERE Index = '100001'

-- step 5
SELECT
    MIN(Number_of_Employees) AS min_Number_of_Employees,
    MAX(Number_of_Employees) AS max_Number_of_Employees
FROM organizations;

-- check empty cell
SELECT *
FROM organizations
WHERE
    Number_of_Employees IS NULL;

-- update a column
UPDATE organizations
SET Number_of_Employees = '3135'
WHERE Organization_Id = '6CDCcdE3D0b7b44';

-- check update
SELECT *
FROM organizations
WHERE Organization_Id = '6CDCcdE3D0b7b44'

-- step 6
SELECT DISTINCT Industry
FROM organizations;
-- 225 unique industries

-- count organizations by industry
SELECT
     Industry,
     COUNT(*) AS count_by_industry
FROM organizations
GROUP BY Industry
ORDER BY count_by_industry DESC;

-- count unique countries by industry
SELECT
    Industry,
    COUNT(DISTINCT Country) AS Number_of_Countries
FROM organizations
GROUP BY Industry
ORDER BY Number_of_Countries DESC;

-- step 7
SELECT
  LENGTH(Founded) AS years_founded
FROM organizations;

-- any found year more than 4 digits
SELECT
     Organization_Id, Country, Founded
FROM organizations
WHERE LENGTH(Founded) > 4; 

-- correct the cell value
UPDATE organizations
SET Founded = '1980'
WHERE Organization_Id = '74FAA2BF6f0E0ed';

-- change the length of column
ALTER TABLE public.organizations
ALTER COLUMN founded TYPE VARCHAR(4)
USING SUBSTRING(founded FROM 1 FOR 4);

-- step 8
-- find duplicates
SELECT
Organization_Id,
COUNT(*) AS Occurrences
FROM organizations
GROUP BY Organization_Id
HAVING COUNT(*) > 1;

-- create a new table w/o duplicates
CREATE TABLE organizations_clean AS
SELECT DISTINCT ON (Organization_Id) *
FROM organizations
ORDER BY Organization_Id, Index;

-- step 9
-- organization with the most employee
SELECT
    Country,
    Number_of_employees
FROM organizations_clean
ORDER BY Number_of_employees DESC;

-- step 10
-- filter date
SELECT
    Name,
    Country,
    to_date(Founded, 'YYYY') AS Founded_Date
FROM organizations_clean
WHERE to_date(Founded, 'YYYY') BETWEEN '1990-01-01' AND '2000-12-31';

-- categorize organization based on the size
SELECT
    CASE
        WHEN Number_of_Employees BETWEEN 0 AND 1000 THEN '0-1000'
        WHEN Number_of_Employees BETWEEN 1001 AND 2000 THEN '1001-2000'
        WHEN Number_of_Employees BETWEEN 2001 AND 3000 THEN '2001-3000'
        ELSE '3001+'
    END AS Employee_Range,
    COUNT(*) AS Count_of_Organizations
FROM organizations_clean
WHERE CAST(Founded AS INTEGER) BETWEEN 1990 AND 2000
GROUP BY Employee_Range
ORDER BY Employee_Range;

ALTER TABLE organizations_clean
ADD COLUMN firm_size VARCHAR(10);

UPDATE organizations_clean
SET firm_size = CASE
WHEN Number_of_Employees BETWEEN 0 AND 1000 THEN 'Small'
WHEN Number_of_Employees BETWEEN 1001 AND 2000 THEN 'Medium'
WHEN Number_of_Employees BETWEEN 2001 AND 3000 THEN 'Large'
ELSE 'Very Large'
END;

SELECT Name, Number_of_Employees, firm_size
FROM organizations_clean
LIMIT 20;

-- step 11
-- filter organizations based on the found length and size
SELECT
    CONCAT(Name, ' - ', Country) AS Firm_Details,
    Founded,
    Number_of_Employees
FROM organizations_clean
WHERE
    CAST(Founded AS INTEGER) <= EXTRACT(YEAR FROM CURRENT_DATE) - 20 -- Firms older than 20 years
    AND Number_of_Employees > 6000; -- Huge firms

-- step 12
-- extract the most common words used in organization description
SELECT
    TRIM(SUBSTRING(Description FROM '^[A-Za-z]+')) AS First_Word,
    COUNT(*) AS Frequency
FROM organizations_clean
GROUP BY First_Word
ORDER BY Frequency DESC
LIMIT 20;

-- step 13
-- loop through organization, to add 100 employees
DO $$
DECLARE
    org_id VARCHAR;
BEGIN
    -- Create a loop to iterate through all rows
    FOR org_id IN
        SELECT Organization_Id
        FROM organizations_clean
    LOOP
        -- Update each row's Number_of_Employees by adding 100
        UPDATE organizations_clean
        SET Number_of_Employees = COALESCE(Number_of_Employees, 0) + 100
        WHERE Organization_Id = org_id;
    END LOOP;
END $$;

UPDATE organizations_clean
SET Number_of_Employees = COALESCE(Number_of_Employees, 0) + 100;

-- step 14
-- create department and employee tables
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

-- step 15
-- inner join 2 tables
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

-- left join 2 tables
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

-- right join 2 tables
SELECT
    Employees.Employee_ID,
    Employees.Employee_Name,
    Departments.Department_Name
FROM
    Employees
RIGHT JOIN
    Departments
ON
    Employees.Department_ID = Departments.Department_ID;

-- full outer join 2 tables
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

-- step 16
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

-- step 17
-- calculate average and sum order amount by warehouse
SELECT 
    w.warehouse_id,
    w.warehouse_name,
    COUNT(o.order_id) AS total_orders,
    (SELECT SUM(amount) FROM Orders o2 WHERE o2.warehouse_id = w.warehouse_id) AS total_order_amount,
	(SELECT AVG(amount) FROM Orders o2 WHERE o2.warehouse_id = w.warehouse_id) AS avg_order_amount
FROM Warehouses w
LEFT JOIN Orders o ON w.warehouse_id = o.warehouse_id
GROUP BY w.warehouse_id, w.warehouse_name
ORDER BY w.warehouse_id;

-- use FROM subquery
SELECT
    W.warehouse_name,
    O.total_amount,
	O.num_orders
FROM
    Warehouses AS W
INNER JOIN (
    SELECT
        warehouse_id,
        SUM(amount) AS total_amount,
		COUNT(*) AS num_orders
    FROM
        Orders
    GROUP BY
        warehouse_id
) AS O
ON
    W.warehouse_id = O.warehouse_id;

-- use where subquery
SELECT warehouse_name
FROM warehouses
WHERE warehouse_id IN (
	SELECT DISTINCT warehouse_id
	FROM orders
	WHERE customer_id IN (
		SELECT customer_id
		FROM customers
		WHERE city NOT IN ('New York', 'Dallas')
	)
);

-- Aggregate function
SELECT W.warehouse_name,
	   COUNT(O.order_id) AS number_of_orders,
    CASE
        WHEN COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) <= 0.25 THEN '0-25% Orders'
        WHEN COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) > 0.25 AND COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) <= 0.50 THEN '26-50% Orders'
        WHEN COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) > 0.50 AND COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) <= 0.75 THEN '51-75% Orders'
		ELSE 'More than 75% Orders'
    END AS fulfillment_category
FROM warehouses as W
LEFT JOIN orders as O
ON W.warehouse_id = O.warehouse_id
GROUP BY W.warehouse_id, W.warehouse_name

-- step 18
-- create table if not exists
CREATE TABLE IF NOT EXISTS organizations (
  Index SERIAL PRIMARY KEY,
  Organization_Id VARCHAR(255),
  Name VARCHAR(255),
  Website VARCHAR(255),
  Country VARCHAR(255),
  Description TEXT,
  Founded VARCHAR(4),
  Industry VARCHAR(255),
  Number_of_Employees INT
);

-- drop table if exists
DROP TABLE IF EXISTS organizations;
