# Introduction
📊 In today's data-driven landscape, __Data Analysts__ are the backbone of businesses, turning numbers into insights and insights into action. But what skills truly pay off? 💰 Which roles are leading the salary charts? And what should aspiring data professionals focus on to maximize their market value? 📈 I'm here to answer all that and more!

🔍 Check out the SQL queries here: [project_sql](/project_sql/)

# Background
As the demand for data-driven expertise grows, professionals entering or advancing in this field often face critical questions:
- Which Data Analyst roles pay the most? 💰
- What skills are required for these top-paying roles? 🤹‍♂️
- What skills are most sought after by employers? 🔥
- What skills are associated with higher salaries? 💸
- Which skills offer the best balance of high demand and high salary? 🎯

Understanding these dynamics is key to making informed career choices and strategically positioning oneself in the job market. Using data exploration, this project aims to decode the data analyst job landscape uncovering trends in compensation, skill requirements, and market demand—providing valuable insights for data professionals and aspiring analysts alike. It gives more to the remote job postings.

# Tools I used

This project leveraged a combination of powerful tools to extract, analyze, and visualize insights from data job postings. Below are the key technologies used:
- SQL – The backbone of our data analysis! Used for querying the database efficiently and unearthing crucial insights. 💾
- PostgreSQL – A robust relational database system, perfect for managing and processing job posting data. 🐘
- Visual Studio Code – The trusted code editor that made scripting and querying seamless. ✨
- Git – Version control to track changes and collaborate effectively. 🔄
- GitHub – Our hub for sharing code, insights, and progress with the world! 🌍

Together, these tools enabled deep exploration of Data Analyst job trends, helping uncover high-paying roles, in-demand skills, and optimal career strategies.

# The Analysis

Each query aims at investigating specific aspects of the data analyst job market. Here's the approach to each question:

### 1. Highest-Paying Data Analyst Roles

To retrieve the highest-paying roles, I filtered data analyst positions that are remote friendly and have specified salaries. I then sorted out the results in descending order and limited it to 10 rows to get the top 10 highest paying jobs.

```sql
SELECT 
    job_id,
    job_title,
    job_location,
    name AS company_name,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
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
```
The table below lists the top 10 highest-paying data analyst roles:

| job_id   | job_title                                      | company                                     | salary_year_avg |
|----------|----------------------------------------------|--------------------------------------------|----------------|
| 226942   | Data Analyst                                 | Mantys                                      | 650000         |
| 547382   | Director of Analytics                        | Meta                                        | 336500         |
| 552322   | Associate Director- Data Insights           | AT&T                                        | 255830         |
| 99305    | Data Analyst, Marketing                     | Pinterest Job Advertisements               | 232423         |
| 1021647  | Data Analyst (Hybrid/Remote)                | Uclahealthcareers                           | 217000         |
| 168310   | Principal Data Analyst (Remote)             | SmartAsset                                  | 205000         |
| 731368   | Director, Data Analyst - HYBRID             | Inclusively                                 | 189309         |
| 310660   | Principal Data Analyst, AV Performance Analysis | Motional                                | 189000         |
| 1749593  | Principal Data Analyst                      | SmartAsset                                  | 186000         |
| 387860   | ERM Data Analyst                            | Get It Recruit - Information Technology    | 184000         |

- With __6 out of 10__ of the highest-paying data analyst roles being that of a senior level, we can conclude the the highest salaries for data analyst roles are mostly associated with senior positions.

### 2. Key Skills for Top-Paying Data Analyst Positions

To Identify the skills needed for the top-paying data analyst positions, associating each job with its required skills using inner joins between job postings and skill-related tables, ensuring that only jobs with specified skills are included.

```sql
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
```
Key insights into the most demanded skills for top 10 higest-paying data analyst jobs:
- SQL – Most commonly listed (8 times), with an average salary of ~$207K.
- Python – Appears 7 times, with an average salary of ~$206K.
- Tableau – 6 mentions, linked with a higher average salary of ~$214K.
- R, Snowflake, Excel, and Pandas – Also prominent and tied to high-paying roles.

### 3. Most In-Demand Skills for Data Analysts

This query uncovers the skills most frequently requested in data analyst job postings, directing focus to areas with high demand.

```sql
SELECT 
    skills_dim.skills,
    COUNT(*) AS demand_count
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_postings_fact.job_title_short = 'Data Analyst'
GROUP BY 
    skills_dim.skills
ORDER BY 
    demand_count DESC
LIMIT 10;
```
The table below lists the top 10 most-sought after skill for Data Analyst positions based on their frequency in job postings:

| Skills    | Demand Count |
|-----------|-------------|
| SQL       | 92,628      |
| Excel     | 67,031      |
| Python    | 57,326      |
| Tableau   | 46,554      |
| Power BI  | 39,468      |
| R         | 30,075      |
| SAS       | 28,068      |
| PowerPoint | 13,848     |
| Word      | 13,591      |
| SAP       | 11,297      |

Here’s a quick breakdown of the most sought-after skills in D.A job postings:
- SQL tops the list, highlighting the strong demand for database management and data querying skills.
- Excel remains highly relevant, reflecting its versatility in data analysis and business operations.
- Python is widely needed, showing its importance in data science, automation, and software development.
- Tableau and Power BI emphasize the growing demand for data visualization and business intelligence tools.


### 4. Skills Linked to Higher Salaries

Exploring salaries associated with different skills revealed which are the highes paying ones.

```sql
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
```
The table below lists the top 20 highest-paying skills for Data Analyst positions:

| Skills       | Average Salary |
|-------------|---------------|
| SVN         | 400,000       |
| Solidity    | 179,000       |
| Couchbase   | 160,515       |
| DataRobot   | 155,486       |
| Golang      | 155,000       |
| MXNet       | 149,000       |
| dplyr       | 147,633       |
| VMware      | 147,500       |
| Terraform   | 146,734       |
| Twilio      | 138,500       |
| GitLab      | 134,126       |
| Kafka       | 129,999       |
| Puppet      | 129,820       |
| Keras       | 127,013       |
| PyTorch     | 125,226       |
| Perl        | 124,686       |
| Ansible     | 124,370       |
| Hugging Face | 123,950      |
| TensorFlow  | 120,647       |
| Cassandra   | 118,407       |

Here's a brief summary of the top paying skills.
- Cross-disciplinary and emerging tech skills pay more: Skills like Solidity (blockchain), Golang (systems/backend development), and Hugging Face (AI/ML NLP models) signal high demand for analysts who can work across domains like Web3, AI, and software engineering.
- DevOps and infrastructure knowledge is valuable: Tools such as Terraform, Ansible, Puppet, and VMware show that data analysts with infrastructure automation and deployment skills can command higher salaries, likely due to their ability to support scalable data operations.
- Niche tools and advanced ML libraries boost earnings: Proficiency in specialized tools like DataRobot, Couchbase, and deep learning libraries (Keras, PyTorch, TensorFlow) correlates with higher pay, reflecting the premium placed on automation and advanced analytics expertise.
- Lastly, it's interesting to note that none of the most sought after skills for Data Analyst skills e.g SQL, Python and Excel, appear in this list.

### 5. The Perfect Skill Balance: High Demand & High Pay

Analyzing job postings to uncover the intersection of sought-after skills and top salaries offering a strategic focus for skill development.

```sql
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
```
Table below shows the most optimal skills that data analysts can focus on in terms of upskilling.

| skill_id | skills    | demand_count | average_salary |
|----------|----------|--------------|---------------|
| 8        | go       | 27           | 115320        |
| 234      | confluence | 11          | 114210        |
| 97       | hadoop   | 22           | 113193        |
| 80       | snowflake | 37          | 112948        |
| 74       | azure    | 34           | 111225        |
| 77       | bigquery | 13           | 109654        |
| 76       | aws      | 32           | 108317        |
| 4        | java     | 17           | 106906        |
| 194      | ssis     | 12           | 106683        |
| 233      | jira     | 20           | 104918        |

# What I Learned

Throughout this journey, I managed to pick up some treasure stones in my quest for SQL mastery:

- Complex Query Writing: Mastering complex SQL queries felt like leveling up in a high-stakes strategy game! I learned to weave together intricate JOINs, subqueries, and window functions to unlock deeper layers of data, and refining my skills with every challenge.

- Data Aggregation: Diving into SQL’s world of data aggregation felt like unlocking a hidden power. By wielding mighty functions like SUM(), AVG(), COUNT(), and GROUP BY, I learned to slice, dice, and consolidate data with precision. Watching scattered numbers come together into valuable summaries was like watching puzzle pieces fall into place.

- Insightful Mastery: I sharpened my analytical instincts, uncovering hidden patterns that could guide job seekers and skill-builders toward success! By dissecting industry trends, skill demands, and hiring patterns, I transformed raw data into a roadmap for those feeling lost in their career journey.

- PostgreSQL and VS Code: MLearning more on PostgreSQL and its seamless connection with VS Code felt like unlocking a powerhouse for data management! I navigated the setup, ensuring PostgreSQL and its extensions played nicely with my coding environment, enabling smooth interactions between my queries and database. Loading CSV files into Postgres was a game-changer. With each challenge tackled, from configuring database connections to optimizing data imports, I elevated my workflow, turning PostgreSQL and VS Code into an unstoppable duo for efficient data handling.

# Conclusions

1. __Highest-Paying Data Analyst Roles__: The highest-paying data analyst positions offer a wide range of salaries with highest being $650,000!
2. __Key Skills for Top-Paying Data Analyst Positions__: 8 out of 1o of the highest paying data anaylst required SQL mastery suggesting that it's a crucial skill to earning a top salary. 
3. __Most In-Demand Skills for Data Analysts__: SQL is the most demanded skill which makes it crucial for job seekers to have the skill.
4. __Skills Linked to Higher Salaries__: Emerging tech and cross-disciplinary expertise—like blockchain, AI, and backend development—are in high demand, boosting analyst salaries. DevOps and infrastructure automation skills also command higher pay, as they enhance scalability in data operations.
5. __The Perfect Skill Balance: High Demand & High Pay__: SQL is one for the most optimal skills as it leads in demand and offers a high average salary, positioning it as one of the most crucial skill for data analysts to learn so as to increase their market value.


