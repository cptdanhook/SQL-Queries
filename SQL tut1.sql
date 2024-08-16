SELECT * 
FROM employee_demographics;

SELECT first_name, age, birth_date, age + 10 AS older_age
FROM employee_demographics;

SELECT DISTINCT first_name, gender
FROM employee_demographics;