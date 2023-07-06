-- QUESTIONS AND ANALYSIS
# Guide
USE projectportfolio;
SELECT * FROM hr;

# 1. What is the gender breakdown of employees in the company?
SELECT gender, COUNT(*) AS count
FROM hr 
WHERE age >= 20 AND term_date = 0000-00-00
GROUP BY gender;

# 2. What is the race/ethnicity breakdown of employees in the company?
SELECT race, COUNT(*) AS count
FROM hr
WHERE age >= 20 AND term_date = 0000-00-00
GROUP BY race
ORDER BY count DESC;

# 3. What is the age distribution of employees by gender in the company?
SELECT 
	CASE
		WHEN age >= 20 AND age <= 30 THEN "20-30"
		WHEN age >= 31 AND age <= 40 THEN "31-40"
		WHEN age >= 41 AND age <= 50 THEN "41-50"
		WHEN age >= 51 AND age <= 60 THEN "51-60"
		ELSE '61+'
	END AS age_group, gender, 
	COUNT(*) AS count
FROM hr
WHERE age >= 20 AND term_date = 0000-00-00
GROUP BY age_group, gender
ORDER BY age_group, gender;


SELECT 
	CASE
		WHEN age >= 20 AND age <= 30 THEN "20-30"
		WHEN age >= 31 AND age <= 40 THEN "31-40"
		WHEN age >= 41 AND age <= 50 THEN "41-50"
		WHEN age >= 51 AND age <= 60 THEN "51-60"
		ELSE '61+'
	END AS age_group, 
	COUNT(*) AS count
FROM hr
WHERE age >= 20 AND term_date = 0000-00-00
GROUP BY age_group
ORDER BY age_group;

# 4. How many employees work at headquarters versus remote locations?
SELECT location, COUNT(*) AS count
FROM hr
WHERE age >= 20 AND term_date = 0000-00-00
GROUP BY location;

# 5. What is the average length of employment for employees who have been terminated?
SELECT ROUND(AVG(datediff(term_date, hire_date))/365, 0) AS avg_length_employment
FROM hr
WHERE age >= 20 AND term_date <> 0000-00-00 AND term_date <= curdate();

# 6. How does the gender distribution vary across departments?
SELECT gender, department, COUNT(*) AS count
FROM hr
WHERE age >= 20 AND term_date = 0000-00-00
GROUP BY gender, department
ORDER BY department;

# 7. What is the distribution of job titles across the company?
SELECT job_title, COUNT(*) AS count
FROM hr
WHERE age >= 20 AND term_date = 0000-00-00
GROUP BY job_title
ORDER BY job_title;

# 8. Which department has the highest turnover rate?
SELECT
	department,
    total_count,
    terminated_count,
    terminated_count/total_count AS termination_rate
FROM
	(SELECT
		department,
        COUNT(*) AS total_count,
        SUM(CASE WHEN term_date <> 0000-00-00 
						AND term_date <= curdate() THEN 1 ELSE 0 END) AS terminated_count
	FROM hr
    WHERE age >= 18
    GROUP BY department) AS subquery
ORDER BY termination_rate DESC;	

# 9. What is the distribution of employees across locations by state?
SELECT location_state, COUNT(*) AS count
FROM hr
WHERE age >= 20 AND term_date = 0000-00-00
GROUP BY location_state
ORDER BY count DESC;

# 10. How has the company's employee count changed over time based on hire and term dates?
SELECT
	year,
    hires,
    terminations,
    hires - terminations AS net_change,
	ROUND((hires - terminations)/hires * 100, 2) AS net_change_percentage
FROM
	(SELECT 
		YEAR(hire_date) AS year,
		COUNT(*) AS hires,
        SUM(CASE WHEN term_date <> 0000-00-00 
						AND term_date <= curdate() THEN 1 ELSE 0 END) AS terminations
	FROM hr
    WHERE age >= 20
    GROUP BY year) AS subquery
ORDER BY year;
    
# 11. What is the tenure distribution for each department?
SELECT department, ROUND(AVG(datediff(term_date, hire_date)/365), 0) AS avg_tenure
FROM hr
WHERE age >= 20 AND term_date <> 0000-00-00 AND term_date <= curdate()
GROUP BY department;




