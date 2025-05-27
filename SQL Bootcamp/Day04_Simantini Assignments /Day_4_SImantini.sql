
-- 1. List all customers and the products they ordered with the order date. (Inner join)
SELECT  * FROM products;
SELECT  * FROM customers;
SELECT  * FROM order_details;
SELECT  * FROM orders;

SELECT 	c.companyname AS customer,
    	p.productname AS product,
    	od.orderid,
    	od.quantity,
    	o.orderdate
FROM customers c
JOIN orders o ON c.customerid = o.customerid
JOIN order_details od ON o.orderid = od.orderid
JOIN products p ON od.productid = p.productid;


   
 
/*2. Show each order with customer, employee, shipper, and product info 
— even if some parts are missing. (Left Join)*/
SELECT  * FROM customers;
SELECT  * FROM orders;
SELECT  * FROM employees;
SELECT  * FROM shippers;
SELECT  * FROM products;
SELECT  * FROM order_details;
SELECT  
    c.companyname AS customer,
    p.productname AS product,
    o.orderid,
    e.employeename,
    s.companyname AS shipper
FROM orders o  
LEFT JOIN customers c ON c.customerid = o.customerid
LEFT JOIN employees e ON e.employeeid = o.employeeid 
LEFT JOIN shippers s ON s.shipperid = o.shipperid 
LEFT JOIN order_details od ON o.orderid = od.orderid
LEFT JOIN products p ON od.productid = p.productid;


-- 3.Show all order details and products (include all products even if they were never ordered(Right Join)
SELECT  * FROM products;
SELECT  * FROM order_details;
SELECT  
	p.productid,
    p.productname AS product,
    od.orderid,
    od.quantity  
FROM  order_details od  
RIGHT JOIN products p ON p.productid = od.productid order by od.orderid desc ; -- where od.orderid is null
-- RIGHT JOIN orders o ON od.orderid = o.orderid  where o.orderid is null
 
/* 4. List all product categories and their products — 
including categories that have no products, 
and products that are not assigned to any category.(Outer Join)*/
SELECT  * FROM products;
SELECT  * FROM categories;
SELECT  
    c.categoryname  AS category,
    p.productname AS product
FROM  categories c  
FULL OUTER JOIN products p ON p.categoryid = c.categoryid;
-- WHERE p.productname is null or  c.categoryname is null;

 
-- 5. 	Show all possible product and category combinations (Cross join).
SELECT  
    c.categoryname  AS category,
    p.productname AS product
FROM  categories c  
CROSS JOIN products p;

-- 6. 	Show all employees who have the same manager(Self join)
SELECT  * FROM employees ORDER BY employeename ,employeeid;
SELECT
    e.employeename AS Employee,
    m.employeename AS Manager
FROM
    employees e
INNER JOIN employees m ON e.reportsto = m.employeeid
ORDER BY e.employeename;
 
 
 
-- 7. 	List all customers who have not selected a shipping method.
SELECT  
    c.companyname AS customer,
	o.orderid AS orders,
    s.companyname AS shipper
FROM customers c 
LEFT JOIN orders o ON c.customerid = o.customerid
LEFT JOIN shippers s ON o.shipperid = s.shipperid 
WHERE  o.shipperid  IS NULL


 
 
 
              



