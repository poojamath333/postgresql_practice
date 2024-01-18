-- HR ANALYTICS DASHBOARD CROSS CHECK -- 

-- Employee Count -- 

SELECT sum(employee_count) AS employee_count
FROM hr_data 
WHERE education = 'High School'
AND department = 'Sales';
--AND education_field = 'Medical'
--AND gender = 'Female'
--AND job_role = 'Sales Executive'
--AND age_band = '45 - 54'

-- Attrition Count -- 

SELECT count(attrition) AS attrition_count
FROM hr_data 
WHERE attrition = 'Yes'
AND education = 'High School'
AND department = 'Sales';
--AND education_field = 'Medical'
--AND gender = 'Female'
--AND job_role = 'Sales Executive'
--AND age_band = '45 - 54'

-- Attrition Rate -- 

SELECT 
round(((
	SELECT count(attrition) 
		FROM hr_data 
			WHERE attrition = 'Yes'
			AND education = 'High School'
			AND department = 'Sales'
			--AND education_field = 'Medical'
			--AND gender = 'Female'
			--AND job_role = 'Sales Executive'
			--AND age_band = '45 - 54'
		) / sum(employee_count))*100, 0)
FROM hr_data
WHERE education = 'High School'
AND department = 'Sales';
--AND education_field = 'Medical'
--AND gender = 'Female'
--AND job_role = 'Sales Executive'
--AND age_band = '45 - 54'

-- Active Employee -- 

SELECT sum(employee_count) - (SELECT count(attrition) FROM hr_data 
										WHERE attrition = 'Yes'
										AND education = 'High School'
										AND department = 'Sales'
										--AND education_field = 'Medical'
										--AND gender = 'Female'
										--AND job_role = 'Sales Executive'
										--AND age_band = '45 - 54') 
FROM hr_data
WHERE education = 'High School'
AND department = 'Sales';
--AND education_field = 'Medical'
--AND gender = 'Female'
--AND job_role = 'Sales Executive'
--AND age_band = '45 - 54'

-- Average Age -- 

SELECT round(avg(age), 0)
FROM hr_data 
WHERE education = 'High School'
AND department = 'Sales';
--AND education_field = 'Medical'
--AND gender = 'Female'
--AND job_role = 'Sales Executive'
--AND age_band = '45 - 54'

-- Attrition By Gender -- 

SELECT gender, count(attrition)  AS attrition_count
FROM hr_data 
WHERE attrition = 'Yes'
GROUP BY 1;

-- Department wise Attrition --

SELECT department, count(attrition), round((cast (count(attrition) as numeric) / 
(select count(attrition) from hr_data where attrition= 'Yes')) * 100, 0)
FROM hr_data 
WHERE attrition = 'Yes'
GROUP BY 1;

-- No. of employees by age group -- 

SELECT age, sum(employee_count)
FROM hr_data 
GROUP BY 1
ORDER BY 1;

-- Education field wise attrition -- 

SELECT education_field, count(attrition)
FROM hr_data
WHERE attrition = 'Yes'
GROUP BY 1;

-- Job satisfcation rating --

CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT * FROM crosstab ( 'SELECT job_role, job_satisfaction, sum(employee_count)
FROM hr_data
GROUP BY 1, 2
ORDER BY 1, 2')
	AS ct (job_role varchar(50), one NUMERIC, two NUMERIC, three NUMERIC, four NUMERIC)
ORDER BY job_role;

-- Attrition Rate by Gender for different Age Group --

SELECT age_band, gender, count(attrition)
FROM hr_data
WHERE attrition = 'Yes'
GROUP BY 1, 2
ORDER BY 1, 2;

