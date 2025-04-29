/*
Question: What are the top-paying job skills for data analysts?
- Use the top 10 highest-paying data analyst jobs from the first query.
- Identify the skills associated with these jobs.
- Why? Understanding the skills that lead to high-paying opportunities can guide career development for data analysts.
*/

WITH top_paying_jobs AS (
    SELECT 
    job_id,
    job_title,
    job_location,
    name AS company_name,
    salary_year_avg
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_location = 'Anywhere'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills_dim.skills 
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
-- Inner join to get the skills associated with the top-paying jobs.
-- A left join has no effect as it will also give us the jobs without skills.
ORDER BY top_paying_jobs.salary_year_avg DESC;

/*Here are the insights from the Skills column:
SQL – Most commonly listed (8 times), with an average salary of ~$207K.
Python – Appears 7 times, with an average salary of ~$206K.
Tableau – 6 mentions, linked with a higher average salary of ~$214K.
R, Snowflake, Excel, and Pandas – Also prominent and tied to high-paying roles.
*/