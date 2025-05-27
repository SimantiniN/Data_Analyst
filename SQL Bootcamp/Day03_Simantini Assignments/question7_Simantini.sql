-- USE NEW Northwind DB:
/* 7)List all orders with employee full names. (Inner join) */
SELECT *  FROM orders;
SELECT *  FROM order_details;
SELECT distinct(first_name ||' '||last_name ) as full_name  FROM employees;

SELECT employees.first_name ||' '||employees.last_name AS employee_full_name,
orders.order_id as order_number,
order_date
FROM orders
INNER JOIN employees
ON orders.employee_id = employees.employee_id
ORDER BY employee_full_name;

 