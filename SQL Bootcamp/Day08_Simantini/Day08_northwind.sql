/* 1.Create view vw_updatable_products (use same query whatever I used in the training)
	Try updating view with below query and see if the product table also gets updated.
	Update query:
	UPDATE updatable_products SET unit_price = unit_price * 1.1 WHERE units_in_stock < 10;*/
--  Create the View
SELECT * FROM  products
WHERE units_in_stock < 10;

CREATE OR REPLACE  VIEW vw_updatable_products AS
SELECT 
    product_id,
    product_name,
    unit_price,
    units_in_stock
FROM products
WHERE discontinued = 0
WITH CHECK OPTION;

--  Update the View --  
UPDATE vw_updatable_products 
SET unit_price = unit_price * 1.1 
WHERE units_in_stock < 10;

---Display it 
SELECT * FROM  vw_updatable_products
WHERE units_in_stock < 10; 

SELECT * FROM  products
WHERE units_in_stock < 10;



/* 2.Transaction:Update the product price for products by 10% in category id=1
			  Try COMMIT and ROLLBACK and observe what happens.*/
SELECT * FROM products WHERE category_id = 1;
-- Begin transaction
BEGIN;

-- Update product prices by 10% in category id=1
UPDATE products
SET unit_price = unit_price * 1.10
WHERE category_id = 1;

-- Check if any updated prices exceed 50 using exception 
DO $$
DECLARE
    price_exceeded BOOLEAN;
BEGIN
    SELECT EXISTS (
        			SELECT 1 
        			FROM products
        			WHERE category_id = 1 AND unit_price > 50
    				) INTO price_exceeded;
    IF price_exceeded 
	THEN
        RAISE NOTICE 'Some prices exceed 50.';
		-- If Manually commit or rollback use NOTICE 
		-- RAISE EXCEPTION 'Some prices exceed 50.'
		--  Exceptions automatically trigger ROLLBACK — no need for a manual ROLLBACK; after COMMIT;
    ELSE
        RAISE NOTICE 'Prices updated successfully.';
    END IF;
END
$$;
-- Try COMMIT and ROLLBACK and observe what happens
COMMIT;  --  to commit the changes
ROLLBACK;  -- MAnnually - to discard the changes as we use NOTICE

/* 3. Create a regular view which will have below details (Need to do joins):
		Employee_id,
		Employee_full_name,
		Title,
		Territory_id,
		territory_description,
		region_description */

SELECT * FROM employees;
SELECT * FROM employee_territories;
SELECT * FROM territories;
SELECT * FROM region;

-- Create the view
CREATE VIEW OR REPLACE  employee_view AS
SELECT
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_full_name,
    e.title,
    t.territory_id,
    t.territory_description,
    r.region_description
FROM employees e
JOIN employee_territories et
    ON e.employee_id = et.employee_id
JOIN territories t
    ON et.territory_id = t.territory_id
JOIN region r
    ON t.region_id = r.region_id;

-- display the view 
SELECT * FROM employee_view;

-- delete  the view 
-- DROP VIEW employee_view;
		
	
/* 4.Create a recursive CTE based on Employee Hierarchy.*/

SELECT employee_id, reports_to FROM employees;

-- Create a recursive CTE based on Employee Hierarchy
WITH RECURSIVE cte_employee_hierarchy AS
(
		SELECT /* non-recursive statement */
				employee_id,
				first_name||''||last_name AS employee_full_name,
				reports_to,
				0 as hierarchy_level
		FROM employees
		WHERE reports_to IS NULL
		
		UNION ALL
		
		SELECT  /*recursive statement referencing the above select statement */
				e.employee_id,
				e.first_name||''||e.last_name AS employee_name,
				e.reports_to,
				eh.hierarchy_level +1  as hierarchy_level 
		FROM employees e
		JOIN cte_employee_hierarchy eh
		ON e.reports_to = eh.employee_id
)
SELECT -- display cte_employee_hierarchy
		employee_id,
		hierarchy_level,
		employee_name,
		reports_to
		FROM cte_employee_hierarchy
		ORDER by hierarchy_level ,employee_name ; 


