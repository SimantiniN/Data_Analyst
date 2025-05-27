/* 1.Categorize products by stock status. 
	(Display product_name, 
	a new column stock_status whose values are based on a condition below: 
	units_in_stock = 0  is 'Out of Stock’,units_in_stock < 20  is 'Low Stock').*/
	
SELECT * FROM products -- WHERE units_in_stock; is NULL;
ALTER TABLE products
DROP COLUMN stock_status;
ALTER TABLE products
ADD COLUMN stock_status TEXT;
UPDATE products
SET stock_status =
CASE
    WHEN units_in_stock = 0 THEN 'Out of Stock'
    WHEN units_in_stock < 20 THEN 'Low Stock'
    ELSE 'In Stock'
END;
ALTER TABLE products
ALTER COLUMN stock_status SET NOT NULL;

SELECT product_id ,product_name,stock_status FROM products;
 
/*2.Find All Products in the Beverages Category(Subquery, Display product_name,unitprice)*/

SELECT * FROM categories;
SELECT * FROM products;
SELECT 
	   product_name,
	   unit_price
FROM products
WHERE category_id = (SELECT 
							category_id
					FROM categories 
					WHERE category_name = 'Beverages')
					ORDER BY product_name;
 
/*3.Find Orders by Employee with the Most Sales 
(Display order_id,   order_date,  freight, employee_id.
Employee with the Most Sales = Get the total number of orders for each employee, 
then order by DESC and limit to 1. Use Subquery)*/

SELECT * FROM orders;
SELECT * FROM employees;
SELECT 
	order_id,   
	order_date,  
	freight, 
	employee_id 
FROM orders
WHERE employee_id=(SELECT employee_id
					FROM orders
					GROUP BY employee_id
					ORDER BY count(order_id) DESC
					LIMIT 1);
					
-- SELECT employee_id,count(order_id)
-- FROM orders
-- GROUP BY employee_id
-- ORDER BY count(order_id) DESC
-- LIMIT 5;

/*4.Find orders for the country!= ‘USA’ with freight costs higher than any order from the USA. 
(Subquery, Try with ANY, ALL operators)*/
SELECT MAX(freight) FROM orders WHERE ship_country IN ('USA')

-- SELECT order_id ,ship_country FROM orders  
-- WHERE ship_country NOT IN ('USA') 
-- 	  and order_id IN (SELECT order_id 
-- 						  FROM orders
-- 					      WHERE freight > (SELECT MAX(freight) 
-- 					                       FROM orders 
-- 					                       WHERE ship_country IN ('USA')));
										   
SELECT order_id ,ship_country,freight FROM orders  
WHERE ship_country NOT IN ('USA') 
	  and freight > ALL(SELECT freight
						  FROM orders
					      WHERE ship_country IN ('USA') order by order_id)	

-- SELECT order_id ,ship_country,freight FROM orders  
-- WHERE ship_country NOT IN ('USA') 
-- 	  and freight > ANY(SELECT freight
-- 						  FROM orders
-- 					      WHERE ship_country IN ('USA') order by order_id)	