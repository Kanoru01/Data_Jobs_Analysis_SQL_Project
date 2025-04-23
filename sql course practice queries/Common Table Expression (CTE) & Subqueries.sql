-- Common Table Expression (CTE) & Subqueries

-- CTEs
WITH april_jobs AS ( -- Common Table Expression (CTE) to filter jobs starting in April
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 4
) -- End of CTE
SELECT *
FROM april_jobs; -- Select all columns from the CTE april_jobs
-- This query retrieves details of all jobs posted in April.


-- Subqueries
SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 5
) AS may_jobs; -- Subquery to filter jobs posted in May
-- This query retrieves adetails of all jobs posted in May.

-- Names of companies that are offering jobs with no degree requirement.
-- Hint: Use a subquery to filter companies based on job postings.

SELECT name AS company_name
FROM company_dim
WHERE company_id IN (
    SELECT company_id
    FROM job_postings_fact
    WHERE job_no_degree_mentioned = TRUE
); -- Subquery to filter companies with no degree requirement
-- This query retrieves the names of companies that are offering jobs with no degree requirement.


/*
Find the companies that have the most job openings.
    - Get the total number of job openings for each company id.
    - Return the total number of job openings and the company name.
*/

WITH job_counts AS (
    SELECT 
        company_id, 
        COUNT (*) AS total_job_openings
    FROM 
        job_postings_fact 
    GROUP BY 
        company_id
)
SELECT 
    company_dim.name AS company_name, 
    job_counts.total_job_openings
FROM 
    company_dim
LEFT JOIN job_counts ON company_dim.company_id = job_counts.company_id
ORDER BY
    job_counts.total_job_openings DESC;

-- Order by total job openings in descending order
-- This query retrieves the names of companies and their total number of job openings, ordered by the number of openings in descending order.

/*
Find the count of remote job postings per skill.
    - Display the top 5 skill by their demand in remote job postings.
    - Include skill ID, name, and count of posting requiring the skill.
*/

WITH remote_job_counts AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills, 
        COUNT(*) AS remote_job_count
    FROM 
        skills_job_dim
    LEFT JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
    LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

    WHERE 
        job_location = 'Anywhere'
        --job_title_short = 'Data Analyst'
    GROUP BY 
        skills_dim.skill_id, skills_dim.skills

)
SELECT *
FROM remote_job_counts
ORDER BY remote_job_count DESC
LIMIT 5;