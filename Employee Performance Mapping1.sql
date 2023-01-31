CREATE DATABASE IF NOT EXISTS employee;
USE employee;
SELECT * FROM employee.data_science_team;
SELECT * FROM employee.emp_record_table;
SELECT * FROM employee.proj_table;

-- 3. Make a list of employees and their departments
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT FROM employee.emp_record_table;

-- 4. To fetch employee details whose employee rating is less than 2
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING FROM employee.emp_record_table 
WHERE EMP_RATING < 2;

-- To fetch the details of employees whose rating is more than 4
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING FROM employee.emp_record_table 
WHERE EMP_RATING > 4;

-- To fetch the details of the employees whose rating is between 2 and 4
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING FROM employee.emp_record_table
WHERE EMP_RATING >= 2 AND EMP_RATING <= 4;

-- 5. To fetch the first and last names of employees from the Finance Department
SELECT FIRST_NAME, LAST_NAME, DEPT, CONCAT(FIRST_NAME,' ', LAST_NAME) AS FULL_NAME 
FROM employee.emp_record_table WHERE DEPT="FINANCE";

-- 6. To list only those employees who have someone reporting to them 
SELECT
w.EMP_ID, w.FIRST_NAME, w.LAST_NAME, w.ROLE,
w.EXP, w.DEPT, COUNT(a.EMP_ID) as "EMP_COUNT"
FROM
employee.emp_record_table w
INNER JOIN employee.emp_record_table a
ON w.EMP_ID = a.MANAGER_ID
AND a.EMP_ID != a.MANAGER_ID
WHERE w.ROLE IN ( "MANAGER", "PRESIDENT")
GROUP BY w.EMP_ID
ORDER BY w.EMP_ID;

--  7. To list down all the employees from the healthcare and finance departments using union
SELECT EMP_ID, CONCAT(FIRST_NAME,' ', LAST_NAME) AS FULL_NAME, DEPT FROM employee.emp_record_table
WHERE DEPT = "HEALTHCARE"
UNION
SELECT EMP_ID, CONCAT(FIRST_NAME,' ', LAST_NAME) AS FULL_NAME, DEPT FROM employee.emp_record_table
WHERE DEPT="FINANCE";

/* 8. List down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT,
 and EMP_RATING grouped by dept, along with the max emp rating for the department.*/
SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EMP_RATING, MAX(EMP_RATING) AS MAX_RATING
FROM employee.emp_record_table GROUP BY DEPT;

-- 9. Calculate the minimum and the maximum salary of the employees in each role.
SELECT ROLE, MAX(SALARY)as MAX_SALARY, MIN(SALARY)AS MIN_SALARY 
FROM employee.emp_record_table GROUP BY ROLE;

-- 10. Assign ranks to each employee based on their experience
SELECT EMP_ID, FIRST_NAME, LAST_NAME, EXP, 
RANK() OVER (
ORDER BY  EXP DESC) EMP_RANK
FROM employee.emp_record_table;


-- 11. To create a view that displays employees in various countries whose salary is more than six thousand
CREATE VIEW EMPLOYEE_DB AS
SELECT FIRST_NAME, LAST_NAME, COUNTRY, SALARY FROM employee.emp_record_table
WHERE SALARY > 6000;
SELECT * FROM EMPLOYEES_DB;

-- 12. Nested query to find employees with experience of more than ten years
SELECT EMP_ID, CONCAT(FIRST_NAME,' ', LAST_NAME) AS FULL_NAME, ROLE, DEPT, EXP 
FROM employee.emp_record_table 
WHERE EXP > ANY(SELECT EXP FROM employee.emp_record_table
WHERE EXP > 10);      

-- 13. Create a stored procedure to retrieve the details of the employees whose experience is more than three years
DELIMITER $$
CREATE PROCEDURE GetEmpExp()
BEGIN
SELECT * FROM employee.emp_record_table
WHERE EXP >3;
END $$
CALL GetEmpExp();

/* 14. a query using stored functions in the project table to check whether the job profile 
assigned to each employee in the data science team matches the organization’s set standard.*/
DELIMITER $$
DROP FUNCTION Design;
CREATE FUNCTION Design(exp int)
RETURNS VARCHAR(255) 
DETERMINISTIC
BEGIN DECLARE design VARCHAR(255);
IF exp <= 2 THEN SET design = 'JUNIOR DATA SCIENTIST';
ELSEIF exp > 2 AND exp <= 5 THEN SET design = 'ASSOCIATE DATA SCIENTIST';
ELSEIF exp > 5 AND exp <= 10 THEN SET design = 'SENIOR DATA SCIENTIST';
ELSEIF exp >10 AND exp <= 12 THEN SET design = 'LEAD DATA SCIENTIST';
ELSEIF exp >12 AND exp <= 16 THEN SET design = 'MANAGER';
END IF; 
RETURN (design); 
END$$ DELIMITER ;

SELECT FIRST_NAME, LAST_NAME, DEPT, EXP, Design(exp) AS DESIGNATION 
FROM employee.data_science_team ORDER BY exp;
 
-- 15 Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’.
SELECT * FROM employee.emp_record_table WHERE FIRST_NAME = "ERIC";

/*16. Query to calculate the bonus for all the employees, based on their ratings and 
salaries (Use the formula: 5% of salary * employee rating).*/
SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, EMP_RATING, SALARY, 
(SALARY * 0.05 * EMP_RATING) AS BONUS
FROM employee.emp_record_table;

-- 17. Query to calculate the average salary distribution based on the continent and country.
SELECT COUNTRY, CONTINENT, AVG(SALARY) AS AVERAGE_SALARY FROM employee.emp_record_table 
GROUP BY COUNTRY, CONTINENT;

