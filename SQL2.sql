Use pga11;

#Q1. Print product, sum of quantity more than 5 sold during all three months. 
SELECT product, SUM(quantity) FROM bank_inventory_pricing GROUP BY product HAVING SUM(quantity) > 5;

#Q2.Print product, quantity and month for which estimated_sale_price is less than purchase_cost 
SELECT product, quantity, month FROM bank_inventory_pricing WHERE estimated_sale_price < purchase_cost;

#Q3. Extarct the 3rd highest value of column Estimated_sale_price from bank_inventory_pricing dataset
SELECT estimated_sale_price FROM
(SELECT * FROM bank_inventory_pricing ORDER BY estimated_sale_price DESC limit 3) AS tmp
ORDER BY estimated_sale_price limit 1;

#Q4. Count all duplicate values of column Product from table bank_inventory_pricing
SELECT product, COUNT(product)-1 FROM bank_inventory_pricing GROUP BY product;

#Q5. Create a view 'bank_details' for the product 'PayPoints' and Quantity is greater than 2
CREATE VIEW bank_details AS 
(SELECT * FROM bank_inventory_pricing WHERE product = "Paypoints" AND quantity > 2);

#Q6 Update view bank_details1 and add new record in bank_details1.
-- --example(Product=PayPoints, Quantity=3, Price=410.67)
INSERT INTO bank_details(product, quantity, price)
VALUES("PayPoints", 3, 410.67);

#Q7.Real Profit = revenue - cost  Find for which products, branch level real profit is more than the estimated_profit in Bank_branch_PL.
SELECT *, (revenue- cost) AS Profit FROM bank_branch_pl GROUP BY branch, product HAVING profit > estimated_profit;

#Q8.Find the least calculated profit earned during all 3 periods
SELECT *, (revenue - cost) AS Profit FROM bank_branch_pl ORDER BY Profit limit 1;

#Q9. In Bank_Inventory_pricing, 
-- a) convert Quantity data type from numeric to character 
-- b) Add then, add zeros before the Quantity field.
SELECT cast(quantity AS CHAR(5)) FROM bank_inventory_pricing;
SELECT CONCAT("0",quantity) FROM bank_inventory_pricing;

#Q10. Write a MySQL Query to print first_name , last_name of the Customers whose first_name Contains ‘P’
SELECT * FROM customers WHERE CustomerName LIKE "P%" OR CustomerName LIKE "%P" OR CustomerName LIKE "%P%";

#Q11.Reduce 30% of the cost for all the products and print the products whose calculated profit at branch is exceeding estimated_profit .
SELECT *,(cost - cost*0.3) AS Reduced_Cost, (revenue- (cost*0.7)) AS profit 
FROM bank_branch_pl HAVING profit > estimated_profit;

#Q12.Write a MySQL query to print the observations from the Bank_Inventory_pricing table
# excluding the values “BusiCard” And “SuperSave” from the column Product
SELECT * FROM bank_inventory_pricing WHERE Product NOT IN("BusiCard", "SuperSave");

#Q13. Extract all the columns from Bank_Inventory_pricing where price between 220 and 300
SELECT * FROM bank_inventory_pricing WHERE Price BETWEEN 220 AND 300;

#Q14. Display all the non duplicate fields in the Product from Bank_Inventory_pricing table and display first 5 records.
SELECT DISTINCT * FROM bank_inventory_pricing GROUP BY product limit 5;

#Q15.Update price column of Bank_Inventory_pricing with an increase of 15%  when the quantity is more than 3.
UPDATE bank_inventory_pricing SET Price = price+price*0.15 WHERE quantity >3;

#Q16. Show Round off values of the price without displaying decimal scale from Bank_Inventory_pricing
SELECT ROUND(price,0) FROM bank_inventory_pricing;

#Q17.Increase the length of Product size by 30 characters from Bank_Inventory_pricing.
ALTER TABLE bank_inventory_pricing MODIFY product CHAR(20);
DESC bank_inventory_pricing;

#Q18. Add '100' in column price where quantity is greater than 3 and display that column as 'new_price'
SELECT *,
If(quantity > 3, coalesce(price+100, 100), price) as new_price
FROM bank_inventory_pricing;
----------- OR -------------------
Select *,
case when quantity>3 then coalesce(price+100,100)
     Else price
     end new_price
From bank_inventory_pricing;

#Q19. Display all saving account holders who have “Add-on Credit Card" and “Credit card" 
SELECT * FROM bank_account_details WHERE account_type IN ("Credit Card", "Add-on Credit Card");

#Q20. Display records of All Accounts , their Account_types, the transaction amount.
SELECT bd.Account_Number, Account_type, transaction_amount
FROM bank_account_details AS bd, bank_account_transaction AS bt WHERE bd.Account_Number=bt.Account_Number;

#Q21.Display all type of “Credit cards”  accounts including linked “Add-on Credit Cards" 
# type accounts with their respective aggregate sum of transaction amount. 
# Ref: Check linking relationship in bank_transaction_relationship_details.
# Check transaction_amount in bank_account_transaction. 
SELECT BD.Account_type,SUM(transaction_amount) FROM bank_account_transaction AS BT,bank_account_relationship_details AS BD
WHERE BT.Account_Number=BD.Account_Number AND account_type IN ("Credit Card", "Add-on Credit Card") GROUP BY Account_type;

#Q22. Compare the aggregate transaction amount of current month versus aggregate transaction with previous months.
SELECT month(transaction_date),sum(transaction_amount),
lag(sum(transaction_amount)) over() as previous_month_amount
FROM bank_account_transaction group by month(transaction_date);

# Display account_number, transaction_amount , 
-- sum of current month transaction amount ,
-- current month transaction date , 
-- sum of previous month transaction amount , 
-- previous month transaction date.
SELECT Account_Number, MONTH(transaction_date) AS Month, SUM(Transaction_amount),
lag(month(transaction_date),1,0) over(partition by(account_number) order by month(transaction_date)) AS Previous_month,
lag(sum(transaction_amount),1,0) over(partition by(account_number) order by month(transaction_date)) as previous_month_amount
FROM bank_account_transaction GROUP BY Account_Number,Month order by account_number,Month;

#Q23.Display individual accounts absolute transaction of every next  month is greater than the previous months.
SELECT Account_Number, MONTH(transaction_date) AS Month, SUM(Transaction_amount),
lag(month(transaction_date),1,0) over(partition by(account_number) order by month(transaction_date)) AS Previous_month,
lag(sum(transaction_amount),1,0) over(partition by(account_number) order by month(transaction_date)) as previous_month_amount
FROM bank_account_transaction
GROUP BY Account_Number,Month
order by account_number,Month;

#Q24. Find the no. of transactions of credit cards including add-on Credit Cards
#Q25.From employee_details retrieve only employee_id , first_name ,last_name phone_number ,salary, job_id where department_name is Contracting (Note
#Department_id of employee_details table must be other than the list within IN operator.
#Q26. Display savings accounts and its corresponding Recurring deposits transactions are more than 4 times.
#Q27. From employee_details fetch only employee_id, ,first_name, last_name , phone_number ,email, job_id where job_id should not be IT_PROG.
#Q29.From employee_details retrieve only employee_id , first_name ,last_name phone_number ,salary, job_id where manager_id is '60' (Note
#Department_id of employee_details table must be other than the list within IN operator.
#Q30.Create a new table as emp_dept and insert the result obtained after performing inner join on the two tables employee_details and department_details.

USE sql_exam;
/* 1. Write a SQL query which will sort out the customer and their grade who made an order.
 Every customer must have a grade and be served by at least one seller, who belongs to a region.*/
SELECT * FROM customer AS c JOIN orders AS o ON c.custemor_id=o.customer_id JOIN salesman AS s ON c.salesman=s.salesman_id ORDER BY c.city;

 # 2. Write a query for extracting the data from the order table for the salesman who earned the maximum commission.
SELECT * FROM orders WHERE salesman_id IN
(SELECT salesman_id FROM salesman WHERE commision IN
(SELECT max(commision) FROM salesman));
 
 /* 3. From orders retrieve only ord_no, purch_amt, ord_date, ord_date, salesman_id where salesman’s city
 is Nagpur(Note salesman_id of orderstable must be other than the list within the IN operator.) */
SELECT ord_no,purch_amt,ord_date,salesman_id FROM orders
WHERE salesman_id IN (SELECT salesman_id FROM salesman WHERE city="nagpur");

 /* 4. Write a query to create a report with the order date in such a way that the latest order date will come
 last along with the total purchase amount and the total commission for that date is (15 % for all sellers). */
SELECT *, (purch_amt*0.15) AS total_commision,
IF(ord_date = date(ord_date), ord_date, str_to_date(ord_date,"%d-%m-%Y")) as new_ord_date
FROM orders
ORDER BY new_ord_date;

 /* 5. Retrieve ord_no, purch_amt, ord_date, ord_date, salesman_id from Orders table and display only those 
sellers whose purch_amt is greater than average purch_amt. */
SELECT ord_no,purch_amt, ord_date, salesman_id FROM orders
WHERE purch_amt  > (SELECT AVG(purch_amt) FROM orders);

# 6. Write a query to determine the Nth (Say N=5) highest purch_amt from Orders table.
SELECT purch_amt FROM orders ORDER BY convert(purch_amt,float) desc limit 4,1;

# 7. What are Entities and Relationships?

# Entities are the real-world objects having an attributes that represents the characteristics of an object.
# Relationships 

/* 8. Print customer_id, account_number and balance_amount, condition that if balance_amount is nil 
then assign transaction_amount for account_type = "Credit Card" */
SELECT customer_id,account_number,balance_amount,
IF(balance_amount=0,"Credit Card",account_type) AS Account_type
FROM bank_account_details;

/* 9. Print customer_id, account_number, balance_amount, conPrint account_number, balance_amount, transaction_amount 
from Bank_Account_Details and bank_account_transaction for all the transactions occurred during march,
 2020 and april, 2020. */
SELECT customer_id, account_number,balance_amount, transaction_amount, transaction_date
FROM bank_account_details JOIN bank_account_transaction USING(Account_Number) WHERE MONTH(transaction_date) IN (3,4);

 /* 10. Print all of the customer id, account number, balance_amount,transaction_amount from bank_customer,
bank_account_details and bank_account_transactions tables where excluding all of their transactions in march,
 2020 month. */
SELECT customer_id, account_number, balance_amount, transaction_amount, transaction_date FROM
bank_customer JOIN bank_account_details USING(customer_id)
JOIN bank_account_transaction USING(account_number)
WHERE MONTH(transaction_date) != (3);
