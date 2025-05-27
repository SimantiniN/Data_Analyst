 
/* 1.GROUP BY with WHERE - Orders by Year and Quarter
Display order year, quarter, order count, and average freight cost only
for those orders where the freight cost > 1*/

SELECT * FROM orders;

SELECT
      EXTRACT(YEAR FROM order_date) AS order_year,
      EXTRACT(QUARTER FROM order_date)AS quarter,
	  COUNT(order_id) As total_order,
	  AVG(freight) AS average_freight           
FROM orders
WHERE freight > 1 
GROUP BY 
		EXTRACT(YEAR FROM order_date),
		EXTRACT(QUARTER  FROM order_date)
ORDER BY order_year, quarter;

--- Another Solution

SELECT
    EXTRACT(YEAR FROM order_date) AS order_year,
    EXTRACT(QUARTER FROM order_date) AS quarter,
    COUNT(order_id) AS total_order,
    AVG(freight) AS average_freight
FROM orders
WHERE freight > 1
GROUP BY
    order_year,
    quarter
ORDER BY order_year, quarter;

/*2.GROUP BY with HAVING - High Volume Ship Regions
Display ship region, no of orders in each region, min and max freight cost
Filter regions where no of orders >= 5 */

SELECT * FROM orders;

SELECT
    ship_region,
    COUNT(order_id) AS total_order,
    MIN(freight) AS min_freight,
	MAX(freight) AS max_freight
FROM orders
GROUP BY
    ship_region
HAVING COUNT(order_id)  >= 5
ORDER BY ship_region;
/* 3.Get all title designations across employees and customers ( Try UNION & UNION ALL)*/

SELECT * FROM employees;
SELECT * FROM customers;

-- UNION returns unique rows, eliminating duplicate entries from the result set.
SELECT 
      first_name ||''||last_name as name  ,title as designation  FROM employees
UNION 
SELECT contact_name as name ,contact_title as designation FROM customers


-- UNION ALL includes all rows, including duplicate rows.

SELECT 
      first_name ||''||last_name as name  ,title as designation  FROM employees
UNION ALL 
SELECT contact_name as name ,contact_title as designation FROM customers

/* 4.Find categories that have both discontinued and in-stock products
(Display category_id, instock means units_in_stock > 0, Intersect)*/
SELECT * FROM categories ;
SELECT * FROM products where category_id=1 and discontinued = 1;
-- SELECT
--     category_id
-- FROM categories
-- -- WHERE units_in_stock > 0
-- INTERSECT
-- SELECT
--     category_id --,units_in_stock
-- FROM products 
-- WHERE discontinued = 1 and units_in_stock > 0
-- ORDER BY category_id;

SELECT
    category_id ,units_in_stock as instock 
FROM products 
WHERE units_in_stock > 0
INTERSECT
SELECT
    category_id,units_in_stock as instock
FROM products 
WHERE discontinued = 1 
ORDER BY category_id;

/*5.Find orders that have no discounted items (Display the  order_id, EXCEPT)*/

SELECT * FROM order_details;
SELECT order_id
FROM orders
EXCEPT 
SELECT order_id
FROM order_details
WHERE discount > 0;

