/*
Question: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying data analyst that are available remotely.
- Focus on the job postings with specified salaries.
- Why? Highlight the top-paying opportunities for Data Analysts, offering insights into employment.

*/

SELECT 
    job_id,
    job_title,
    name AS company,
    ROUND(salary_year_avg, 0) AS salary_year_avg
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_location = 'Anywhere'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
