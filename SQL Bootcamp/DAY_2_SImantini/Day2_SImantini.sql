--  Add a new column linkedin_profile to employees table to store LinkedIn URLs as varchar.

ALTER TABLE employees
ADD COLUMN linkedin_profile VARCHAR(50);
SELECT *  FROM employees;

-- Change the linkedin_profile column data type from VARCHAR to TEXT.

ALTER TABLE employees 
ALTER COLUMN linkedin_profile TYPE text

SELECT *  FROM employees;

--  Add unique, not null constraint to linkedin_profile

ALTER TABLE employees 
ADD CONSTRAINT unique_constraints 
UNIQUE (linkedin_profile);

SELECT *  FROM employees;

ALTER TABLE employees
ALTER COLUMN linkedin_profile SET NOT NULL;

-- Drop column linkedin_profile

ALTER TABLE employees
DROP COLUMN linkedin_profile;

SELECT *  FROM employees;

-- Retrieve the first name, last name, and title of all employees

 SELECT SPLIT_PART(employeeName, ' ', 1 ) AS First_Name, 
	    SPLIT_PART(employeeName, ' ', 2 ) AS Last_Name,
	    title
	    FROM employees;
		
 -- Find all unique unit prices of products
 
SELECT *  FROM products;
SELECT  DISTINCT on (unitprice)productname, 
		unitprice
	    FROM products;
		
 -- List all customers sorted by company name in ascending order
 
 SELECT *  FROM customers 
 order by companyname asc ;
 
 -- Display product name and unit price, but rename the unit_price column as price_in_usd
 
SELECT *  FROM products;

ALTER TABLE products 
RENAME COLUMN unitprice TO price_in_usd;

SELECT productname,price_in_usd  FROM products;

-- Get all customers from Germany.

SELECT *  FROM customers where country = 'Germany';

-- Find all customers from France or Spain

SELECT *  FROM customers where country in('France' ,'Spain');
SELECT *  FROM customers where country = 'France' or  country = 'Spain';

/*  Retrieve all orders placed in 1997 (based on order_date), 
    and either have freight greater than 50 
	or the shipped date available (i.e., non-NULL) 
    (Hint: EXTRACT(YEAR FROM order_date)) */
	
SELECT * FROM orders 
WHERE EXTRACT(YEAR FROM orderDate)=  1997    -- 2015
AND (freight > 50 OR shippedDate IS NOT NULL);

/* Retrieve the product_id, product_name, and unit_price of products
   where the unit_price is greater than 15.*/
   
SELECT 	productid,
		productname,
		price_in_usd  
FROM products
WHERE price_in_usd > 15;

-- List all employees who are located in the USA and have the title "Sales Representative".

SELECT *  FROM employees;
SELECT *  FROM employees
WHERE COUNTRY = 'USA' AND title='Sales Representative';

-- Retrieve all products that are not discontinued and priced greater than 30.

SELECT * FROM products;

SELECT * FROM products
WHERE discontinued = 0 and price_in_usd > 30;

-- Retrieve the first 10 orders from the orders table.

SELECT * FROM orders limit 10;

-- Retrieve orders starting from the 11th order, fetching 10 rows (i.e., fetch rows 11-20).

SELECT * FROM orders limit 20;  -- For reference

SELECT * FROM orders
ORDER BY orderid 
OFFSET 10
FETCH FIRST 10 ROW ONLY;

-- List all customers who are either Sales Representative, Owner

SELECT *  FROM employees
WHERE title IN('Sales Representative','Owner');

SELECT *  FROM employees
WHERE title = 'Sales Representative'or title = 'Owner';

-- Retrieve orders placed between January 1, 2013, and December 31, 2013.

SELECT * FROM orders
WHERE orderdate BETWEEN '2013-01-01' AND '2013-12-31'
ORDER BY orderdate 

SELECT * FROM orders
WHERE orderdate >= '2013-01-01' AND orderdate < '2014-01-01'
ORDER BY orderdate

-- List all products whose category_id is not 1, 2, or 3.

SELECT * FROM products
WHERE categoryid NOT IN(1,2,3);

-- Find customers whose company name starts with "A".

SELECT *  FROM customers WHERE companyname LIKE 'A%' ;

/* INSERT into orders table:
Task: Add a new order to the orders table with the following details:
Order ID: 11078
Customer ID: ALFKI
Employee ID: 5
Order Date: 2025-04-23
Required Date: 2025-04-30
Shipped Date: 2025-04-25
shipperID:2 
Freight: 45.50
*/

INSERT INTO orders 
VALUES(11078,'ALFKI',5,'2025-04-23','2025-04-30','2025-04-25',2,45.50 );
SELECT * FROM orders
WHERE orderid =  11078;
 
/* Increase(Update)  the unit price of all products in category_id =2 by 10%.
(HINT: unit_price =unit_price * 1.10) */

UPDATE products
SET price_in_usd = ROUND(price_in_usd :: numeric * 1.10, 2)
WHERE categoryid =2;

SELECT * FROM products
WHERE categoryid = 2;
 
/* 10) Sample Northwind database:
 		Download northwind.sql from below link into your local. 
			Sign in to Git first https://github.com/pthom/northwind_psql
 		Manually Create the database using pgAdmin:
 			Right-click on "Databases" → Create → Database
			Give name as ‘northwind’ (all small letters)
			Click ‘Save’
		Import database:
 			Open pgAdmin and connect to your server          	
  			Select the database  ‘northwind’
  			Right Click-> Query tool.
  			Click the folder icon to open your northwind.sql file
 			Press F5 or click the Execute button.
  			You will see total 14 tables loaded
  			Databases → your database → Schemas → public → Tables  */
 

