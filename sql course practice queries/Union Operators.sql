/*
Get the corresponding skill and skill type for each job posting in Q1.
    -Include those wihtout any skills, too.
    -Look at the skills and the type for each job in Q1 that has a salary greater than 70k.
*/

SELECT
    january_jobs.job_id,
    skills_dim.skills,
    skills_dim.type
FROM january_jobs
LEFT JOIN skills_job_dim ON january_jobs.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE salary_year_avg > 70000

UNION

SELECT
    february_jobs.job_id,
    skills_dim.skills,
    skills_dim.type
FROM february_jobs
LEFT JOIN skills_job_dim ON february_jobs.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE salary_year_avg > 70000

UNION

SELECT
    march_jobs.job_id, 
    skills_dim.skills,
    skills_dim.type
FROM march_jobs
LEFT JOIN skills_job_dim ON march_jobs.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE salary_year_avg > 70000;

-- Practice Problem 2

/*
Find job postings with an average salary greater than 70k.
    -Combine job posting tables from the first quarter of 2023 (Jan-March).
    -Get job postings with an average salary greater than 70k.
*/

SELECT 
    q1_jobs.job_title_short,
    q1_jobs.job_location,
    q1_jobs.job_via,
    q1_jobs.job_posted_date::DATE,
    q1_jobs.salary_year_avg
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS q1_jobs
WHERE 
    q1_jobs.salary_year_avg > 70000
    AND q1_jobs.job_title_short = 'Data Analyst'
ORDER BY q1_jobs.salary_year_avg DESC;