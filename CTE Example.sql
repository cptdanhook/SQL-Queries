-- CTE
WITH CTE (Gender, AVG_sal, MAX_sal, MIN_sal, COUNT_sal) AS
(
SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal, MIN(salary) min_sal, COUNT(salary) count_sal
FROM employee_demographics dem
JOIN employee_salary sal
ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT *
FROM CTE; 

/*WITH CTE AS
(
SELECT employee_id, gender, birth_date
FROM employee_demographics
WHERE birth_date > '1985-01-01'
),
CTE2 AS
(
SELECT employee_id, salary
FROM employee_salary
WHERE salary > 50000
)
SELECT *
FROM CTE
JOIN CTE2
ON CTE.employee_id = CTE2.employee_id
;*/
