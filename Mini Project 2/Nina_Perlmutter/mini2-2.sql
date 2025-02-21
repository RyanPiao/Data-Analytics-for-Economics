-- step 1: create table
CREATE TABLE organizations (
	Index SERIAL PRIMARY KEY,
	Organization_Id VARCHAR(225),
	Name VARCHAR(255),
 	Website VARCHAR(255),
 	Country VARCHAR(255),
 	Description TEXT,
 	Founded VARCHAR(5),
 	Industry VARCHAR(255),
 	Number_of_Employees INT
);


-- step 2: import CSV file (I had permission issues so I think the code below is unnecessary)
copy public.organizations (Index,Organization_Id,Name,Website,Country,Description,Founded,Industry,Number_of_Employees)
FROM '/Users/ninaperlmutter/Library/Mobile Documents/com~apple~CloudDocs/Data Analytics/organizations-10000.csv'
DELIMITER ',' CSV HEADER;


--step 3: run queries

-- 3-1: select query
SELECT 
  Name,
  Country
FROM organizations
LIMIT 20;


-- 3-2: insert new data
INSERT INTO organizations (
  Index, Organization_Id, Name, Website, Country, Description, Founded, Industry, Number_of_Employees
)
VALUES (
  100001, 'bC0CEd48A8000E0', 'Velazquez-Odom', 'https://stokes.com/', 'Djibouti',
  'Streamlined 6th generation function', '2002', 'Alternative Dispute Resolution', 4044
);

-- 3-2: check 
SELECT *
FROM organizations
WHERE Index = '100001';

-- 3-3: update 
	-- check for missing data
SELECT *
FROM organizations
WHERE
    Number_of_Employees IS NULL;

	-- find min and max
SELECT
    MIN(Number_of_Employees) AS min_Number_of_Employees,
    MAX(Number_of_Employees) AS max_Number_of_Employees
FROM organizations;

	-- actual update
UPDATE organizations
SET Number_of_Employees = '3135'
WHERE Organization_Id = '6CDCcdE3D0b7b44';

	-- check update
SELECT *
FROM organizations
WHERE Organization_Id = '6CDCcdE3D0b7b44';


-- step 4: select distinct values
	-- identify distinct industries
SELECT DISTINCT Industry
FROM organizations;

	-- count number of orgs in each industry
SELECT
     Industry,
     COUNT(*) AS count_by_industry
FROM organizations
GROUP BY Industry
ORDER BY count_by_industry DESC;


-- step 5: check and filter strings
SELECT
  LENGTH(Founded) AS years_founded
FROM organizations;

SELECT
     Organization_Id, Country, Founded
FROM organizations
WHERE LENGTH(Founded) > 4; 


-- step 6: update and alter 'founded' column 
UPDATE organizations
SET Founded = '1980'
WHERE Organization_Id = '74FAA2BF6f0E0ed';

ALTER TABLE public.organizations
ALTER COLUMN founded TYPE VARCHAR(4)
USING SUBSTRING(founded FROM 1 FOR 4);

-- step 7: find and remove duplicates
	-- find duplicates
SELECT
Organization_Id,
COUNT(*) AS Occurrences
FROM organizations
GROUP BY Organization_Id
HAVING COUNT(*) > 1;

	-- delete duplicate by making new clean table
CREATE TABLE organizations_clean AS
SELECT DISTINCT ON (Organization_Id) *
FROM organizations
ORDER BY Organization_Id, Index;


-- step 8: select and order by number_of_employees
SELECT
    Country,
    Number_of_employees
FROM organizations
ORDER BY Number_of_employees DESC;

-- step 9: make founded into a date and filter
SELECT
     Name,
     Country,
     to_date(Founded, 'YYYY') AS Founded_Date
FROM organizations
WHERE CAST(Founded AS INTEGER) BETWEEN 1990 AND 2000;

-- step 9-2: group by firm size

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

	-- add new column for firm size
ALTER TABLE organizations
ADD COLUMN firm_size VARCHAR(10);

	-- lable each firm size
UPDATE organizations
SET firm_size = CASE
WHEN Number_of_Employees BETWEEN 0 AND 1000 THEN 'Small'
WHEN Number_of_Employees BETWEEN 1001 AND 2000 THEN 'Medium'
WHEN Number_of_Employees BETWEEN 2001 AND 3000 THEN 'Large'
ELSE 'Very Large'
END;

	-- check the changes
SELECT Name, Number_of_Employees, firm_size
FROM organizations
LIMIT 20;


-- step 10: identify 'huge' firms that are over 20 years old
SELECT
    CONCAT(Name, ' - ', Country) AS Firm_Details,
    Founded,
    Number_of_Employees
FROM organizations
WHERE
    CAST(Founded AS INTEGER) <= EXTRACT(YEAR FROM CURRENT_DATE) - 20 -- Firms older than 20 years
    AND Number_of_Employees > 6000; -- Huge firms

-- step 11: same as step 10, so i'll do it just for 'very large' firms
SELECT
    CONCAT(Name, ' - ', Country) AS Firm_Details,
    Founded,
    Number_of_Employees
FROM organizations
WHERE
    CAST(Founded AS INTEGER) <= EXTRACT(YEAR FROM CURRENT_DATE) - 20 -- Firms older than 20 years
    AND Number_of_Employees > 3000 AND Number_of_Employees < 6000; -- Very large firms


-- step 12: trim description and find most frequent word
SELECT
    TRIM(SUBSTRING(Description FROM '^[A-Za-z]+')) AS First_Word,
    COUNT(*) AS Frequency
FROM organizations
GROUP BY First_Word
ORDER BY Frequency DESC
LIMIT 20;


-- step 13: loop through organizations and add 100 to their number of employees
-- even though you don't need a loop to do this
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

-- step 13-2: create a new table and populate it with data
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

-- step 14: Inner join example - use deparment ID to join info from both tables
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

-- step 15: Left join exmaple - return all employees even if there is no match in departments
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

-- step 16: Right join example - return all departments even if there are no employees to match
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

-- step 17: full outer join example - combines results from both left and right join
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


-- new example to practice subqueries with warehouses, orders, and customers
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

-- step 18: find total and average number of orders 
SELECT
    warehouse_id,
    warehouse_name,
    (SELECT SUM(amount) FROM Orders) AS total_order_amount,
	(SELECT AVG(amount) FROM Orders) AS avg_order_amount
FROM
    Warehouses;

	
-- step 19: find total and average number of orders by warehouse
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
	
-- step 19-2 exercise - find count of orders
SELECT
    W.warehouse_name,
    O.total_amount
FROM
    Warehouses AS W
INNER JOIN (
    SELECT
        warehouse_id,
        COUNT(amount) AS total_amount
    FROM
        Orders
    GROUP BY
        warehouse_id
) AS O
ON
    W.warehouse_id = O.warehouse_id;

-- Step 20: find warehouses by customer city
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

-- step 21: Categorize warehouses based on the percentage of orders they fulfill,
-- compared to the total orders.
SELECT
    W.warehouse_name,
    COUNT(O.order_id) AS number_of_orders,
    CASE
        WHEN COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) <= 0.25 THEN '0-25% Orders'
        WHEN COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) > 0.25 AND COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) <= 0.50 THEN '25-50% Orders'
		WHEN COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) > 0.50 AND COUNT(O.order_id) * 1.0 / (SELECT COUNT(*) FROM Orders) <= 0.75 THEN '50-75% Orders'
        ELSE 'More than 75% Orders'
    END AS fulfillment_category
FROM
    Warehouses AS W
LEFT JOIN Orders AS O
ON W.warehouse_id = O.warehouse_id
GROUP BY
    W.warehouse_id, W.warehouse_name;


