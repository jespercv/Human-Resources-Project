-- DATA CLEANING

# Check dataset
USE projectportfolio;
SELECT * FROM hr;
DESCRIBE hr;

# Change the column format into appropriate format and datatype
ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id INTEGER;

ALTER TABLE hr
CHANGE COLUMN firstname first_name VARCHAR(30) NULL;

ALTER TABLE hr
CHANGE COLUMN lastname last_name VARCHAR(30) NULL;

ALTER TABLE hr
CHANGE COLUMN jobtitle job_title VARCHAR(50) NULL;

ALTER TABLE hr
CHANGE COLUMN termdate term_date VARCHAR(50) NULL;

# Changing the format and dataype of birth_date
SELECT birth_date FROM hr;
SET sql_safe_updates = 0;

UPDATE hr
SET birthdate = CASE
	WHEN birthdate LIKE "%/%" THEN date_format(str_to_date(birthdate, "%m/%d/%Y"), "%Y-%m-%d")
    WHEN birthdate LIKE "%-%" THEN date_format(str_to_date(birthdate, "%m-%d-%Y"), "%Y-%m-%d")
    ELSE NULL
END;
 
ALTER TABLE hr
CHANGE COLUMN birthdate birth_date DATE;

# Changing the format and dataype of hire_date
SELECT hire_date FROM hr;

ALTER TABLE hr
CHANGE COLUMN hiredate hire_date DATE;

UPDATE hr
SET hire_date = CASE
	WHEN hire_date LIKE "%/%" THEN date_format(str_to_date(hire_date, "%m/%d/%Y"), "%Y-%m-%d")
    WHEN hire_date LIKE "%-%" THEN date_format(str_to_date(hire_date, "%m-%d-%Y"), "%Y-%m-%d")
    ELSE NULL
END;

# Changing the format and dataype of term_date
SELECT term_date FROM hr;
SET sql_mode = 'ALLOW_INVALID_DATES';

UPDATE hr
SET term_date = IF(term_date IS NOT NULL AND term_date != '', date(str_to_date(term_date, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE TRUE;

ALTER TABLE hr
MODIFY COLUMN term_date DATE NULL;

# Adding a new column name age and set the current age of each individual	 
ALTER TABLE hr
ADD COLUMN age INT;

UPDATE hr
SET age = timestampdiff(YEAR, birth_date, CURDATE());

# Apparently there are negative ages/less than 18
# So we will exclude those to get our analysis and data visualization properly
SELECT COUNT(*) FROM hr WHERE age < 18;



