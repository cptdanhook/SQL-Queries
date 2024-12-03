SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

SELECT ed.first_name, ed.last_name, age, gender, birth_date, occupation, salary, dept_id
FROM employee_demographics AS ed
JOIN employee_salary AS es
ON ed.employee_id = es.employee_id
ORDER BY salary DESC;

SELECT first_name, last_name, gender, birth_date, occupation, salary, dept_id,
CASE WHEN age < 30 THEN '18-30'
				WHEN age <= 45 THEN '30-45'
				WHEN age > 45 THEN '45+' END AS demographic, age
FROM 
	(SELECT ed.first_name, ed.last_name, age, gender, birth_date, occupation, salary, dept_id
		FROM employee_demographics AS ed
		JOIN employee_salary AS es
		ON ed.employee_id = es.employee_id
		ORDER BY salary DESC) AS sub
        GROUP BY first_name, last_name, age, gender, birth_date, occupation, salary, dept_id;

    
