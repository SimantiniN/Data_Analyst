/*https://www.geeksforgeeks.org/postgresql-trigger/ */
/* 
	Create AFTER UPDATE trigger to track product price changes
*/
  -- Create new product_price_audit table with below columns:

CREATE TABLE product_price_audit (
	audit_id SERIAL PRIMARY KEY,
    product_id INT,
    product_name VARCHAR(40),
    old_price DECIMAL(10,2),
    new_price DECIMAL(10,2),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_name VARCHAR(50) DEFAULT CURRENT_USER
)
	
SELECT * FROM product_price_audit;
-- trigger is automatically invoked when an event occurs i.e
-- an update happens on the products table and the price actually changes.
/* 
	Create a trigger function with the below logic: 
*/
CREATE OR REPLACE FUNCTION price_change_after_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO product_price_audit (
        product_id,
        product_name,
        old_price,
        new_price
    )
    VALUES (
        OLD.product_id,
        OLD.product_name,
        OLD.unit_price,
        NEW.unit_price
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- DROP FUNCTION price_change_after_update();

/*
	Create a row level trigger for below event:AFTER UPDATE OF unit_price ON products
	Row-Level Trigger:event occurs once per row updated 
	(e.g. 3 updated rows → 3 trigger executions)
*/

CREATE TRIGGER row_level_trigger_price_change
AFTER UPDATE OF unit_price ON products
FOR EACH ROW
EXECUTE FUNCTION price_change_after_update()


SELECT * FROM product_price_audit;

-- DROP TRIGGER row_level_trigger_price_change ON products;

/*
	Test the trigger by updating the product price by 10% to any one product_id

*/
UPDATE products
SET unit_price = unit_price * 1.10
WHERE product_id = 1;

SELECT * FROM product_price_audit;
 
   
 

