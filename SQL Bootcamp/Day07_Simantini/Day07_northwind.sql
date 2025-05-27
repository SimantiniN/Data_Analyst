/* 1. Rank employees by their total sales
(Total sales = Total no of orders handled, JOIN employees and orders table)*/

SELECT * FROM employees;
SELECT * FROM orders;
SELECT
	    e.employee_id,
		e.first_name ||'  '|| e.last_name AS emplyee_name, 
		COUNT(o.order_id) AS total_sales, 
	    RANK() OVER(ORDER BY COUNT(o.order_id)DESC) AS rank_by_order
		-- RANK() assigns the same rank to tied rows but skips the next ranks (e.g., 1, 2, 2, 4).
FROM employees e
JOIN orders o ON o.employee_id = e.employee_id
GROUP BY e.employee_id,emplyee_name;

/* Another Soution using all functions for learning purpose*/ 
SELECT
	    e.employee_id,
		e.first_name ||'  '|| e.last_name AS emplyee_name, 
		COUNT(o.order_id) AS total_sales, 
		o.ship_country,
		ROW_NUMBER() OVER (ORDER BY COUNT(o.order_id)DESC) AS row_number_by_order,
		-- ROW_NUMBER() gives a unique number to each row, even if there are ties.
	    RANK() OVER (PARTITION BY o.ship_country ORDER BY COUNT(o.order_id)DESC) AS rank_by_order,
		-- RANK() assigns the same rank to tied rows but skips the next ranks (e.g., 1, 2, 2, 4).
		DENSE_RANK() OVER (ORDER BY COUNT(o.order_id)DESC) AS dense_rank_by_order
		-- DENSE_RANK() also assigns the same rank to ties but doesn't skip the next rank (e.g., 1, 2, 2, 3).
FROM employees e
JOIN orders  o on o.employee_id = e.employee_id
GROUP BY e.employee_id,emplyee_name,o.ship_country;

/*2.Compare current order's freight with previous and next order for each customer.
-- (Display order_id,  customer_id,  order_date,  freight,
-- Use lead(freight) and lag(freight).*/
SELECT * FROM orders;
SELECT 
		order_id,  
		customer_id,  
		order_date,  
		freight,
		LEAD(freight)OVER (PARTITION BY customer_id ORDER BY order_date DESC)AS NEXT_ORDER, 
		LAG(freight)OVER (PARTITION BY customer_id ORDER BY order_date DESC)AS PREVIOUS_ORDER 
FROM orders;
/* FOR CURRENT ORDER without displaying the previous/next values for learning purpose*/
SELECT 
		order_id,  
		customer_id,  
		order_date,  
		freight
		FROM (SELECT * ,
					LAG(freight)
						OVER (PARTITION BY customer_id 
											ORDER BY order_date DESC)AS PREVIOUS_ORDER 
FROM orders)current_order
WHERE freight > PREVIOUS_ORDER ;

/*3.Show products and their price categories, product count in each category, avg price:
     (HINT:
·  	Create a CTE which should have price_category definition:
        	WHEN unit_price < 20 THEN 'Low Price'
            WHEN unit_price < 50 THEN 'Medium Price'
            ELSE 'High Price'
·  	In the main query display: price_category,  product_count in each price_category, 
ROUND(AVG(unit_price)::numeric, 2) as avg_price)*/
SELECT * FROM products;
SELECT * FROM categories;
WITH cte_category_product AS (
    SELECT 
        p.product_id, 
        p.product_name,
		p.unit_price, 
		c.category_name,
        (CASE 
            WHEN p.unit_price < 20 THEN 'Low Price'
            WHEN p.unit_price < 50 THEN 'Medium Price'
            ELSE 'High Price'
        END) price_category
    FROM products p
	JOIN categories c ON c.category_id = p.category_id
	 
)
SELECT
	   price_category,
	   -- category_name,
	   COUNT(*) AS Product_count,
	   ROUND(AVG(unit_price)::numeric, 2) as Avarage_price
FROM cte_category_product
GROUP BY price_category   --,category_name
ORDER BY price_category; 
 
 
 

