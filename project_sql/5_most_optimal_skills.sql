/*
Question: What are the most optimal skills ,i.e., high demand and high paying.
- Look at the average salary for each skill assocaited with a Data Analyst role.
- Focus on roles with specified salaries, regardless of location
- Why? Identifying the optimal skils helps job sekeers to target job security (high demand) and financial stability (high paying).
*/

WITH demanded_skills AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(*) AS demand_count
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_postings_fact.job_title_short = 'Data Analyst'
        AND job_postings_fact.salary_year_avg IS NOT NULL
    GROUP BY 
        skills_dim.skill_id
), top_paying_skills AS (
    SELECT 
        skills_dim.skill_id,    
        skills_dim.skills,
        ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS average_salary
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_postings_fact.job_title_short = 'Data Analyst'
        AND job_postings_fact.salary_year_avg IS NOT NULL
    GROUP BY 
        skills_dim.skill_id
)

SELECT 
    ds.skill_id,
    ds.skills,
    ds.demand_count,
    ps.average_salary
FROM 
    demanded_skills ds
INNER JOIN top_paying_skills ps ON ds.skill_id = ps.skill_id
ORDER BY
    average_salary DESC,
    demand_count DESC
LIMIT 20;