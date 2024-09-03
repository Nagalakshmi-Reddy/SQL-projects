/* Order Of Execution */
--  FROM > JOIN > WHERE > GROUP BY > HAVING > SELECT > DISTINCT > ORDER BY > LIMIT > OFFSET

/* Order Of Writing the Clauses */
--  SELECT > DISTINCT > FROM > JOIN > WHERE > GROUP BY > HAVING > ORDER BY > LIMIT > OFFSET

/* 1 - AND, ORDER BY, LIMIT, OFFSET, BETWEEN, IN, OR */

Use Classicmodels;

--  Number of customers whose credit limit is greater than 20000 and less than 70000 
SELECT COUNT(*) FROM customers WHERE creditlimit >= 20000 AND creditlimit <= 70000;

--  The top 3 customers whose credit limit is between 20000 and 70000
SELECT * FROM customers WHERE creditlimit BETWEEN 20000 AND 70000 ORDER BY creditLimit DESC limit 3;

--  OR - is used to check multiple conditions on single column
SELECT * FROM customers WHERE country="USA" OR country="UK";

--  ( 144, 204, 189, 222 ) IN - Replacement for multiple OR
SELECT * FROM customers WHERE customerNumber IN (144,204,189,222);

--  OFFSET - to skip any NUMBER OF consecutive records from the table, it must be used with limit keyword.
# fetch the 2nd highest creditlimit.
SELECT * FROM customers order by creditlimit desc limit 1 offset 1;
----- OR ----
SELECT * FROM customers order by creditlimit desc LIMIT 1,1;

/* 2 - MIN(), MAX(), AVG() */

--  Find the maximum, minimum and average buyPrice of the each productLine
SELECT productLine, MAX(buyPrice) FROM Products GROUP BY productline;

SELECT productLine, MIN(buyPrice) FROM Products GROUP BY productLine;

SELECT productLine, AVG(buyPrice) FROM Products GROUP BY productLine;

-- Print the most amount paid to the business --
SELECT * FROM payments WHERE amount = (SELECT max(amount) FROM payments);

-- Print the least amount paid to the business --
SELECT * FROM payments WHERE amount = (SELECT min(amount) FROM payments);

-- Print the avg amount paid to the business --  
SELECT avg(amount) FROM payments;

/* 3. GROUP BY Clause */

-- Find the Total amount each customer paid 
SELECT customerNumber,sum(amount) as Total_payment FROM payments GROUP BY customerNumber ORDER BY Total_payment desc;

/* 4. HAVING Clause */

-- Find the productLines which are more than 10 
SELECT productLine, Count(productLine) as cp FROM products GROUP BY productLine HAVING cp > 10;

/* 5. CALCULATED Columns */

-- Calculate the Total price of each product purchased 
SELECT *, (buyPrice * quantityInStock) as TotalPrice FROM products;

-- Print the total price of each order given the quantityOrdered and the priceEach of each order in the orderdetils table.
SELECT *, (quantityOrdered * priceEach) as total_price FROM orderdetails;

/* 6. IF and CASE Statements */

SELECT *,
      IF(country = "USA", "NO", "YES") AS is_Foreign
FROM customers;

-- OR WE CAN WRITE ANOTHER WAY --

SELECT *,
case when country = "USA" then "NO"
     when country <> "USA" then "YES"
End ForeignCitizen
FROM customers;


SELECT *, 
     (quantityInStock * buyPrice) AS worth,
     CASE WHEN quantityInStock * buyPrice >= 500000 THEN "DIAMOND"
          WHEN quantityInStock * buyPrice >= 100000 THEN "GOLD"
          ELSE "SILVER"
          END AS ProductStatus
FROM products;

--  Create a column to show if a payment is premium or standard. A payment is premium if its more than 50000 other wise
-- its considered Standard. This should be done on the payment table.

SELECT *,
CASE WHEN amount >= 50000 THEN "PREMIUM"
     ELSE "STANDARD"
     END ProductType
FROM payments; 

/* 7. JOINS */

SELECT C.customerNumber,customerName,phone,creditLimit, SUM(P.amount) AS totalPayment
 FROM customers AS C LEFT JOIN payments AS P
 ON C.customerNumber = P.customerNumber GROUP BY P.customerNumber;
 
 -- OR --

SELECT customerNumber,customerName,phone,creditLimit, SUM(P.amount) AS totalPayment
 FROM customers AS C LEFT JOIN payments AS P
 USING (customerNumber) GROUP BY customerNumber;
 
-- OR --

SELECT customers.customerNumber,customerName,phone,creditLimit, SUM(payments.amount) AS totalPayment
 FROM customers, payments
 WHERE customers.customerNumber = payments.customerNumber GROUP BY payments.customerNumber;

-- Generate a table like this. If total Payment > 100000 then premium

SELECT customerNumber,customerName,phone,creditLimit, SUM(P.amount) AS totalPayment,
 IF(SUM(P.amount) > 100000, "Premium", "Non-Premium") AS status
 FROM customers AS C LEFT JOIN payments AS P
 USING (customerNumber)
 GROUP BY customerNumber;

-- JOINING MULTIPLE TABLES

SELECT customerNumber, customerName, country, orderDate, status, productName,
 quantityOrdered as quantity, priceEach, (quantityOrdered * priceEach) AS totalcost
 FROM customers JOIN orders USING(customerNumber)
 JOIN orderdetails USING(orderNumber) 
 JOIN products USING(productCode);
 
-- Write a query to return the top 10 most paying customers report

SELECT customerNumber, customerName, country, orderDate, status, productName,
 quantityOrdered as quantity, priceEach, (quantityOrdered * priceEach) AS totalcost
 FROM customers JOIN orders USING(customerNumber)
 JOIN orderdetails USING(orderNumber) 
 JOIN products USING(productCode)
 ORDER BY totalcost desc limit 10;
 
/* 8. SUB QUERIES - the o/p of subquery should be a single row output if '=' is used, to fetch multiple rows from subquery use IN operator */

-- Name the employees who are working NewYork state

SELECT employeeNumber, lastName, firstName, jobTitle FROM employees
 WHERE officeCode = (SELECT officeCode FROM offices WHERE state = "NY"); 

-- Fetch the orderdetails where the orders made in the year 2003.

SELECT productCode, quantityOrdered, priceEach,
 (quantityOrdered * priceEach) AS total_cost
 FROM orderdetails WHERE orderNumber IN  
 (SELECT OrderNumber FROM orders WHERE orderDate BETWEEN "2003-01-01" AND "2003-12-31");

/* 9. Co-Related Queries */

-- Print the lastName, FirstName and the City of Employees who belongs to the city PARIS using corelated query 

SELECT e.lastName, e.firstName,
 (SELECT city FROM offices o WHERE e.officeCode = o.officeCode) AS City
 FROM employees e HAVING City = "Paris";

/* 10. QUERY OPTIMIZATION */

EXPLAIN 
SELECT * FROM customers;

EXPLAIN FORMAT = TREE
SELECT * FROM customers WHERE customerName = "Atelier graphique";

EXPLAIN ANALYZE
SELECT * FROM customers WHERE customerName = "Atelier graphique";

/* 11. Common Table Expressions - CTEs*/

WITH products_cte AS (
 SELECT productCode, productName, productLine, quantityInStock, buyPrice
 FROM products
 )
SELECT * FROM products_cte WHERE productLine = "Classic Cars";

-- Having External Table Names 
WITH products_cte (A, B, C, D, E) AS (
 SELECT productCode, productName, productLine, quantityInStock, buyPrice
 FROM products
 )
SELECT * FROM products_cte WHERE C = "Classic Cars";

/* 12. Business Understanding - SALES REPORT */
-- Generate a table like this. - sales & profit Report 

SELECT *,(Gross_Sales - COGS) AS profit FROM
(SELECT productCode, productName, quantityInStock, buyPrice, MSRP, quantityOrdered as quantitySold,
AVG(priceEach) AS Market_Value,
(quantityOrdered*buyPrice) AS COGS,
(quantityOrdered*priceEach) AS Gross_Sales
FROM products JOIN orderdetails USING(productCode)
GROUP BY productCode) as tmp;

/* 13. VARIABLES AND FUNCTIONS */

-- Variable 
SET @name = "SQl Tutorial";
SELECT @name;

SELECT @msg := "You are learning SQL";

SET @AvgPrice =
(SELECT AVG(priceEach) FROM orderdetails WHERE productCode="S18_1749");
SELECT @AvgPrice;

-- OR --
SELECT @AvgPrice :=
(SELECT AVG(priceEach) FROM orderdetails WHERE productCode="S18_1749") AS price_avg;

-- Functions
SELECT now();

SELECT Date_add(now(), interval 20 day);
 
 -- USER - DEFINED FUNCTIONS
 
/*
CREATE FUNCTION `get_market_value` (
       prodCode VARCHAR(20)
)
RETURNS FLOAT
DETERMINISTIC
BEGIN
		 DECLARE price_avg float;
         SET price_avg =
         (SELECT AVG(priceEach) FROM orderdetails WHERE orderdetails.productCode=prodCode);
RETURN price_avg;
END
*/

/* 14. Store Procedures */






  