/*
Question: What are the top demanded skills for data analysts?
- Inner join job postings to get the skills associated with the
- Identify top 10 in-demand skills for a data analyst role.
- Focus on all job postings.
- Why? Understanding the most demanded skills can help job seekers align their qualifications with market needs.
*/

SELECT 
    skills_dim.skills,
    COUNT(*) AS demand_count
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_postings_fact.job_title_short = 'Data Engineer'
GROUP BY 
    skills_dim.skills
ORDER BY 
    demand_count DESC
LIMIT 10;
