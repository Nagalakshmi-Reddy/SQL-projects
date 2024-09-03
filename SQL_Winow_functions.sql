/* Window Functions / Analytic Functions
(PARTITION BY)
1. ROW_NUMBER()
2. RANK()
3. DENSE_RANK()
4. LAG()
5. LEAD()
*/
 
USE classicmodels;
select * from customers;

# Need of partition by clause: Difference betwenn normal group by and partition by clause
# Q1. Display the maximum creditlimit for each person who belong to the state.
select customerNumber, customerName, State, count(state), max(creditLimit) from customers group by state;

SELECT customerNumber, customerName, state,
max(creditlimit) over(partition by(state)) FROM customers;

/* 1. ROW_NUMBER() */

SELECT * FROM EMPLOYEES;

SELECT *, row_number() OVER() as rn FROM Employees;

SELECT *, row_number() OVER(partition by jobTitle) as rn FROM Employees order by employeeNumber;

/* Fetch the top 3 employees in each dept who earns max salary */
Use pga11;

select * from (
SELECT *, rank() over(partition by department_id order by salary desc) as rnk from employee_details) as tmp
where tmp.rnk < 4;

/* 2. Dense_Rank() */

update employee_details set salary=34048 where employee_id=103;

SELECT *, rank() over(partition by department_id order by salary desc) as rnk,
dense_rank() over(partition by department_id order by salary desc) as dense_rnk,
row_number() over(partition by department_id order by salary desc) as rn
from employee_details; 

/* 3. Lag */

select Employee_id,Salary,
lag(salary) over(partition by department_id order by employee_id)
from employee_details;

select Employee_id,Salary,
lag(salary, 1, 0) over(partition by department_id order by employee_id)
from employee_details;

select Employee_id,Salary,
lag(salary, 2, 0) over(partition by department_id order by employee_id)
from employee_details;

/* 4. Lead 
Fetch a query to display if the salary of an employee in each department is higher, lower or equal to suceeding employee
*/

select Employee_id,Salary,
Lead(salary, 1, 0) over(partition by department_id order by employee_id)
from employee_details;

select Employee_id,Salary,
Lag(salary, 1, 0) over(partition by department_id order by employee_id) as previous_emp_salary,
case when E.salary > Lag(salary) over(partition by department_id order by employee_id) then "Higher than previous employee"
     when E.salary < Lag(salary) over(partition by department_id order by employee_id) then "Lesser than previous employee"
	 when E.salary = Lag(salary) over(partition by department_id order by employee_id) then "Equal to the previous employee"
     End Statement
from employee_details E; 


# Additional Practice questions
USE classicmodels;

SELECT employeeNumber, lastname, firstname FROM employees WHERE officeCode=4;

SELECT DISTINCT(jobTitle) FROM employees;

SELECT COUNT(*) FROM employees WHERE jobTitle = "Sales Rep";

SELECT MIN(amount), AVG(amount), MAX(amount) FROM payments;

SELECT * FROM payments WHERE amount BETWEEN 100000 AND 200000;

SELECT * FROM customers WHERE country = "USA" AND creditLimit > 100000;

SELECT * FROM customers WHERE country = "Canada" OR creditLimit > 100000;

SELECT * FROM customers WHERE country <> "USA";

SELECT customerNumber,customerName FROM customers WHERE customerName LIKE "_an%";

SELECT * FROM customers WHERE salesRepEmployeeNumber IS NULL;

SELECT productCode, productName FROM products ORDER BY quantityInStock DESC;

SELECT productCode, SUM(quantityOrdered) FROM orderdetails GROUP BY productCode HAVING SUM(quantityOrdered) > 1000;

SELECT * FROM orderdetails WHERE priceEach = 
(SELECT MAX(priceEach) FROM orderdetails);

