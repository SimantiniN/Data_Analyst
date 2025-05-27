--1. List all customers and the products they ordered with the order date. (Inner join)
SELECT  * FROM products;
SELECT  * FROM customers;
SELECT  * FROM order_details;
SELECT  * FROM orders;
SELECT 
	c.company_name AS customer,
	o.order_id, 
	p.product_name AS product , 
	od.quantity,
	o.order_date
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON p.product_id = od.product_id;

--2. Show each order with customer, employee, shipper, and product info — even if some parts are missing. (Left Join)
SELECT  * FROM customers;
SELECT  * FROM orders;
SELECT  * FROM employees;
SELECT  * FROM shippers;
SELECT  * FROM products;
SELECT  * FROM order_details;
SELECT 
		o.order_id, c.company_name AS customer, 
		e.first_name || ' ' || e.last_name AS employeename, 
		s.company_name AS shipper, p.product_name, od.quantity
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN order_details od ON o.order_id = od.order_id
LEFT JOIN products p ON p.product_id = od.product_id
LEFT JOIN shippers s ON s.shipper_id = o.ship_via
LEFT JOIN employees e ON e.employee_id = o.employee_id;

--3. Show all order details and products (include all products even if they were never ordered). (Right Join)

SELECT p.product_id,
		p.product_name AS product,
		od.order_id, 
		od.quantity 		
FROM order_details od
RIGHT JOIN products p
ON p.product_id = od.product_id; 
 
--4. List all product categories and their products — including categories that have no products,
--and products that are not assigned to any category.(Outer Join)

SELECT 
		c.category_name AS category, 
		p.product_name AS product
FROM categories c
FULL OUTER JOIN products p
ON p.category_id = c.category_id;

--5. Show all possible product and category combinations (Cross join).

SELECT 
		c.category_name AS category, 
		p.product_name AS product
FROM products p
CROSS JOIN categories c;
 
--6. Show all employees who have the same manager(Self join)

SELECT  first_name|| ' ' ||last_name AS employee ,reports_to 
FROM employees ORDER BY employee_id;

SELECT
     e.first_name|| ' ' || e.last_name AS employee,
	  m.first_name|| ' ' || m.last_name AS manager
FROM employees e
INNER JOIN employees m ON e.reports_to = m.employee_id
ORDER BY e.employee_id;

--7. List all customers who have not selected a shipping method.
SELECT * FROM orders;
SELECT * FROM shippers;
SELECT * FROM customers;
SELECT 
	  c.customer_id,
	  c.company_name AS customer,
	  o.order_id AS orders
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE o.ship_via IS NULL;