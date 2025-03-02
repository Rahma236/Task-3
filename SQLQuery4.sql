-------------&[TASK_B]-----------

CREATE DATABASE OnlineShoppingSystem
USE OnlineShoppingSystem

CREATE TABLE Customers(
id INT IDENTITY PRIMARY KEY,
email VARCHAR(100) UNIQUE NOT NULL,
name NVARCHAR(50) NOT NULL,
phoneNumber NVARCHAR(50) NOT NULL,
address NVARCHAR(50) NOT NULL,
);
CREATE TABLE  Products(
productID INT IDENTITY PRIMARY KEY,
category NVARCHAR(50) NOT NULL ,
name NVARCHAR(50) UNIQUE NOT NULL,
description NVARCHAR(MAX) NOT NULL,
 price DECIMAL(8,2) CHECK (price > 0) NOT NULL
);
CREATE TABLE Orders(
orderID INT IDENTITY PRIMARY KEY,
totalAmount DECIMAL(8,2) NOT NULL ,
orderDate DATETIME DEFAULT GETUTCDATE(),
status NVARCHAR(50),
customerID INT NOT NULL,
FOREIGN KEY (customerID) REFERENCES Customers(id)
);
CREATE TABLE OrderDetails (
    orderDetailID INT IDENTITY PRIMARY KEY,
    price DECIMAL(8,2) CHECK (price > 0) NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    productID INT NOT NULL,
    orderID INT NOT NULL,
    FOREIGN KEY (orderID) REFERENCES Orders(orderID),
    FOREIGN KEY (productID) REFERENCES Products(productID)
);
CREATE TABLE Suppliers(
id INT IDENTITY PRIMARY KEY,
contactInfo  NVARCHAR(200) NOT NULL,
name NVARCHAR(100) NOT NULL,
);
CREATE TABLE ProductSupplier(
productID INT NOT NULL,
supplierID INT NOT NULL,
FOREIGN KEY (productID) REFERENCES Products(productID),
FOREIGN KEY (supplierID) REFERENCES Suppliers(id)
);

ALTER TABLE Products
ADD rating DECIMAL(3,2) DEFAULT 0 ;
ALTER TABLE Products
ADD CONSTRAINT DE_category DEFAULT 'NEW' FOR category;

-- حذف العمود بعد إزالة القيد
DECLARE @constraintName NVARCHAR(255);
SELECT @constraintName = name 
FROM sys.default_constraints 
WHERE parent_object_id = OBJECT_ID('Products') 
AND parent_column_id = COLUMNPROPERTY(OBJECT_ID('Products'), 'rating', 'ColumnId');
IF @constraintName IS NOT NULL 
BEGIN
    EXEC('ALTER TABLE Products DROP CONSTRAINT ' + @constraintName);
END

ALTER TABLE Products 
DROP COLUMN rating;

-----[update the order date]---
UPDATE Orders SET orderDate=GETUTCDATE() WHERE orderID>0 ;
----[Delete all rows from the Products table]----
DELETE FROM Products where name IS NOT NULL AND name <>'NULL';




