/* 1.Write  a function to Calculate the total stock value for a given category:
	 (Stock value=ROUND(SUM(unit_price * units_in_stock)::DECIMAL, 2)
	 Return data type is DECIMAL(10,2) */
	 
SELECT * FROM  products; 	 
SELECT distinct(category_id)  FROM products order by category_id ;

-- SELECT category_id FROM categories WHERE category_id = 19;

CREATE OR REPLACE FUNCTION total_stock(category INT)
RETURNS DECIMAL(10,2)
LANGUAGE plpgsql
AS
$$
DECLARE
Stock_value DECIMAL(10,2); -- variable declaration
BEGIN  -- logic
--  PostgreSQL checks: Is there at least one row matching the condition?
-- 1 is just a dummy value — it tells PostgreSQL not to pull all columns, just confirm the match.
	IF NOT EXISTS(
		SELECT 1 FROM products       
		WHERE category_id = category)
	THEN
		RAISE EXCEPTION 'SUCH PRODUCT CATEGORY % NOT EXISTS',category;
		-- RETURN 0;
	END IF;
	SELECT COALESCE(ROUND(SUM(unit_price * units_in_stock)::DECIMAL, 2), 0.00)
	INTO stock_value
	FROM products
	WHERE category_id = category;
	RETURN stock_value;
END;
$$;

SELECT total_stock(19); 
SELECT total_stock(1); 
SELECT p.product_name,
	   c.category_name, 
	   p.category_id,
	   total_stock(p.category_id) AS category_stock_value
FROM products p
JOIN categories c 
ON p.category_id = c.category_id
WHERE p.discontinued = 0
GROUP BY p.product_name,
	   c.category_name ,p.category_id
ORDER BY c.category_name;


-- DROP FUNCTION IF EXISTS total_stock(INT);

/* 
	In psql  tool 
	\prompt 'Enter category id: ' category_id
	Enter category id: 1
	northwind=# SELECT total_stock(:category_id);
	 total_stock 
	-------------
	     1670.46
	(1 row)
*/
