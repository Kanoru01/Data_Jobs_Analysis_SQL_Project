/* Label new columns as follows:
    - 'Anywhere' as 'Remote'
    - 'New York, NY' as 'Local'
    - all other locations as 'Onsite'
*/
SELECT
    COUNT(job_id) AS job_count,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    location_category;

-- The query counts the number of job postings for 'Data Analyst' and categorizes them based on their location.
-- The results will show the count of job postings for each location category: 'Remote', 'Local', and 'Onsite'.

-- Categorizing data analyst job postings by salary range.

SELECT
    COUNT(job_id) AS job_count,
    CASE
        WHEN salary_year_avg <= 50000 THEN 'Low'
        WHEN salary_year_avg > 50000 AND salary_year_avg <= 150000 THEN 'Medium'
        WHEN salary_year_avg > 150000 THEN 'High'
        ELSE 'Unknown'
    END AS salary_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    salary_category
ORDER BY
    job_count;