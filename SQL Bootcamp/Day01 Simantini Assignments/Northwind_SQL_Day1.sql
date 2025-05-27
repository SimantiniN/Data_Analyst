CREATE Table customers (customerID TEXT PRIMARY KEY not null, 
companyName TEXT not null,
contactName text not null,
contactTitle text not null,
city text not null,
country text not null
);
-- DROP TABLE customers;

CREATE Table categories (categoryID INTEGER PRIMARY KEY not null,
categoryName TEXT not null,
description TEXT not null
);
-- DROP Table categories;

CREATE TABLE shippers (shipperID INTEGER PRIMARY KEY NOT NULL,
companyName TEXT NOT NULL
);
CREATE TABLE products (productID INTEGER PRIMARY KEY NOT NULL,
productName TEXT NOT NULL,
quantityPerUnit TEXT NOT NULL,
unitPrice FLOAT NOT NULL,
discontinued INTEGER NOT NULL,
categoryID INTEGER NOT NULL,
FOREIGN KEY (categoryID) REFERENCES categories(categoryID)
);

-- DROP Table products;
-- select * from categories where categoryID = 1;
select * from products ;

-- CREATE TABLE order_details (orderID INTEGER NOT NULL,
/*productID INTEGER NOT NULL,
unitPrice FLOAT NOT NULL,
quantity INTEGER NOT NULL,
discount FLOAT NOT NULL,
PRIMARY KEY (orderid, productid),
FOREIGN KEY (orderid) REFERENCES categories(orderid)
FOREIGN KEY (products) REFERENCES categories(productid);
*/


CREATE TABLE employees(
employeeID INTEGER PRIMARY KEY NOT NULL,
employeeName TEXT NOT NULL,
title TEXT NOT NULL,
city TEXT NOT NULL,
country TEXT NOT NULL,
reportsTo INTEGER,
FOREIGN KEY (reportsTo) REFERENCES employees(employeeID) 
);

CREATE TABLE orders (
    orderID INTEGER PRIMARY KEY NOT NULL,
    customerID TEXT NOT NULL,
    employeeID INTEGER NOT NULL,
    orderDate DATE NOT NULL,
    requiredDate DATE NOT NULL,
    shippedDate DATE,
    shipperID INTEGER NOT NULL,
    freight FLOAT NOT NULL,
    FOREIGN KEY (customerID) REFERENCES customers(customerID),
    FOREIGN KEY (employeeID) REFERENCES employees(employeeID),
    FOREIGN KEY (shipperID) REFERENCES shippers(shipperID)
);

-- select * from orders ;
-- DROP Table orders;