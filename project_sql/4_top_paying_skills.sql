/*
Question: What are the top skills based on salary.
- Look at the average salary for each skill assocaited with a Data Analyst role.
- Focus on roles with specified salaries, regardless of location
- Why? Understanding the average salary for each skill can help job seekers prioritize their learning and development efforts.
- This can also help employers understand the value of certain skills in the job market.
*/

SELECT 
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
    skills_dim.skills
ORDER BY 
    average_salary DESC
LIMIT 20;

/*
Here's a brief summary of the top paying skills.
-Cross-disciplinary and emerging tech skills pay more: Skills like Solidity (blockchain), Golang (systems/backend development), and Hugging Face (AI/ML NLP models) signal high demand for analysts who can work across domains like Web3, AI, and software engineering.
-DevOps and infrastructure knowledge is valuable: Tools such as Terraform, Ansible, Puppet, and VMware show that data analysts with infrastructure automation and deployment skills can command higher salaries, likely due to their ability to support scalable data operations.
-Niche tools and advanced ML libraries boost earnings: Proficiency in specialized tools like DataRobot, Couchbase, and deep learning libraries (Keras, PyTorch, TensorFlow) correlates with higher pay, reflecting the premium placed on automation and advanced analytics expertise.
*/