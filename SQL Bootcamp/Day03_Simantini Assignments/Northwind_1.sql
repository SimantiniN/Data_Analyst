/* 1)Update the categoryName From “Beverages” to "Drinks" in the categories table.*/
SELECT * FROM categories ORDER BY categoryname;
UPDATE categories
SET categoryname = 'Drinks'
WHERE categoryname = 'Beverages';

/* 2)Insert into shipper new record (give any values) */
SELECT * FROM shippers; 

INSERT INTO shippers
VALUES(4,'Austarlian Post');

SELECT * FROM shippers; 
 
/* Delete that new record from shippers table.*/

DELETE FROM shippers
WHERE companyname='Austarlian Post';
SELECT * FROM shippers; 

/*3)Update categoryID=1 to categoryID=1001. 
   Make sure related products update their categoryID too. 
   Display the both category and products table to show the cascade.
   (HINT: Alter the foreign key on products(categoryID) 
   to add ON UPDATE CASCADE, ON DELETE CASCADE)*/*/
   
SELECT * FROM categories order by categoryid ;
SELECT * FROM products order by categoryid ;

ALTER TABLE products
DROP CONSTRAINT products_categoryid_fkey;

ALTER TABLE products
ADD CONSTRAINT products_categoryid_fkey
FOREIGN KEY (categoryid)
REFERENCES categories(categoryid)
ON UPDATE CASCADE
ON DELETE CASCADE;

/* DROP CONSTRAINT fk_category_id; if needed  and create again */
-- ALTER TABLE products
-- DROP CONSTRAINT fk_category_id;


UPDATE categories  
SET categoryid = 1001 
WHERE categoryid = 1;

/*  Delete the categoryID= “3”  from categories. 
  Verify that the corresponding records are deleted automatically from products.*/
  
DELETE FROM categories
WHERE categoryid = 3 ;

SELECT * FROM products WHERE categoryid = 3 ; 
/* ERROR:  Key (productid)=(16) is still referenced from table "order_details".
update or delete on table "products" violates foreign key constraint
"order_details_productid_fkey" on table "order_details" */

ALTER TABLE order_details
DROP CONSTRAINT order_details_productid_fkey;

ALTER TABLE order_details
ADD CONSTRAINT fk_orderdetails_productid
FOREIGN KEY (productid)
REFERENCES products(productid)
ON DELETE CASCADE;

-- SELECT conname
-- FROM pg_constraint
-- WHERE conrelid = 'products'::regclass;

ALTER TABLE order_details
DROP CONSTRAINT fk_orderdetails_productid;

DELETE FROM categories
WHERE categoryid = 3 ;

SELECT * FROM categories order by categoryid;
SELECT * FROM products order by categoryid ;
SELECT * FROM order_details order by productid;
 
/* 4)Delete the customer = “VINET”  from customers.
Corresponding customers in orders table should be set to null 
(HINT: Alter the foreign key on orders(customerID) to use ON DELETE SET NULL) */
SELECT * FROM customers WHERE customerid= 'VINET';
SELECT * FROM orders WHERE customerid= 'VINET';

-- SELECT * FROM pg_constraint;
SELECT conname
FROM pg_constraint
WHERE conrelid = 'orders'::regclass;

ALTER TABLE orders
DROP CONSTRAINT orders_customerid_fkey;


ALTER TABLE orders
ADD CONSTRAINT orders_customerid_fkey
FOREIGN KEY (customerid)
REFERENCES customers(customerid)
ON DELETE SET NULL;

ALTER TABLE orders
ALTER COLUMN customerid  DROP NOT NULL;

DELETE FROM customers
WHERE customerid = 'VINET';

SELECT * FROM orders WHERE customerid= 'VINET' or customerid IS NULL;

/* 5)Insert the following data to Products using UPSERT:
product_id = 100, product_name = Wheat bread, quantityperunit=1,unitprice = 13, discontinued = 0, categoryID=3
product_id = 101, product_name = White bread, quantityperunit=5 boxes,unitprice = 13, discontinued = 0, categoryID=3
product_id = 100, product_name = Wheat bread, quantityperunit=10 boxes,unitprice = 13, discontinued = 0, categoryID=3
(this should update the quantityperunit for product_id = 100) */
ALTER TABLE products
RENAME COLUMN price_in_usd TO unitprice;

SELECT * FROM products order by productid ;

INSERT INTO products(productid, productname, quantityperunit, unitprice, discontinued, categoryid)
VALUES (100,'Wheat bread','1 box',13,0,3),
		(101,'Wheat bread','5 boxes',13,0,3)
-- DElete from products where productid = 100;
SELECT * FROM products WHERE productid = 100 ;

INSERT INTO categories VALUES (3,'Confections','Desserts, candies, and sweet breads')
SELECT * FROM  categories order by categoryid;

INSERT INTO products(productid, productname, quantityperunit, unitprice, discontinued, categoryid)
VALUES (100,'Wheat bread','10 boxes',13,0,3)
ON CONFLICT (productid)
DO UPDATE SET quantityperunit = EXCLUDED.quantityperunit;

SELECT * FROM products WHERE productid = 100 ;

/* Note : The left side refers to the existing value in the table that will be updated, 
          and the right side (EXCLUDED.quantityperunit) 
 	      refers to the new value being inserted (like '10 boxes') that replaces it 
	      if a conflict occurs.*/
		  
 /* 6)Write a MERGE query:
		Create temp table with name:  ‘updated_products’ and insert values as below:
 		Update the price and discontinued status for from below table ‘updated_products’ 
 		only if there are matching products and updated_products .discontinued =0
		 /* Insert any new products from updated_products that don’t exist in products 
only if updated_products .discontinued =0.*/

*/

CREATE TEMPORARY TABLE updated_products(
productID integer PRIMARY KEY,
productName text NOT NULL,
quantityPerUnit text  NOT NULL,
unitPrice float NOT NULL,
discontinued integer NOT NULL,
categoryID integer NOT NULL);

SELECT * FROM updated_products;
INSERT INTO categories VALUES (1,'Beverages','Soft drinks, coffees, teas, beers, and ales')
INSERT INTO updated_products 
VALUES 	(100,'Wheat bread','10',20,1,3),
		(101,'White bread','5 boxes',19.99,0,3),
		(102,'Midnight Mango Fizz','24 - 12 oz bottles',19,0,1),
		(103,'Savory Fire Sauce','12 - 550 ml bottles',10,0,2)
		
MERGE INTO products
USING updated_products 
ON products.productid = updated_products.productid
WHEN MATCHED AND updated_products .discontinued = 0 THEN
    UPDATE SET unitPrice = COALESCE(updated_products.unitprice, products.unitprice),
			   discontinued = updated_products.discontinued 
WHEN MATCHED AND updated_products .discontinued = 1 THEN
    DELETE
WHEN NOT MATCHED AND updated_products .discontinued = 0  THEN
 INSERT (productID,productName,quantityPerUnit,unitPrice,discontinued,categoryID)
   VALUES (updated_products.productID,updated_products.productName,updated_products.quantityPerUnit,updated_products.unitPrice,updated_products.discontinued,updated_products.categoryID)			
RETURNING
    merge_action() as action,
    products.productid,
    products.productName,
    products.quantityPerUnit,
    products.unitPrice,
    products.discontinued,
    products.categoryID;

-- INSERT INTO products 
-- 	SELECT (productID,productName,quantityPerUnit,unitPrice,discontinued,categoryID) 
--     FROM updated_products

Select * from products order by productID desc;
/* 
UPDATE updated_products
SET price = 'Drinks'
WHERE categoryname = 'Beverages';

SELECT products.productid , updated_products.productid,products.productname from products 
join updated_products 
on products.productid = updated_products.productid

 

/*            -----------------TIP UPSERT-----------
Here's how it works:
1. INSERT INTO:
You start with a standard INSERT INTO statement, specifying the table and columns to insert into.
2. ON CONFLICT:
This clause is where the "upsert" magic happens. 
It specifies which unique constraint or unique index to check for conflicts.
3. DO UPDATE:
If a conflict is detected (meaning a row with the same value in the constraint exists),
the DO UPDATE clause is executed. This clause specifies which columns to update and with what values.
4. DO NOTHING:
Alternatively, you can use DO NOTHING to skip the insert if a conflict is found, 
effectively just ignoring the attempt to insert a duplicate.*/




