#Total Number of Projects Based On Outcomes
select state,count(*) as total_projects
from kickstarter_crowdfunding_project.projects
group by state 
order by total_projects desc;

#Total Number of Projects Based On Locations
select country,count(*) as total_projects
from kickstarter_crowdfunding_project.projects
group by country
order by total_projects desc;

#Total Number of Projects Based On Category
select c.name,count(p.projectID) as total_projects
from kickstarter_crowdfunding_project.projects p
join kickstarter_crowdfunding_project.category c on p.category_id = c.id
group by c.name
order by total_projects desc;

#Total Number Of Projects By year
select
year(from_unixtime(created_at)) as year,
count(*) as total_projects
from kickstarter_crowdfunding_project.projects
group by year
order by year;

#Total Number Of Projects By Quarter
select
quarter(from_unixtime(created_at)) as quarter,
count(*) as total_projects
from kickstarter_crowdfunding_project.projects
group by quarter
order by quarter;

#Total Number Of Projects By Month
select
month(from_unixtime(created_at)) as month,
count(*) as total_projects
from kickstarter_crowdfunding_project.projects
group by month
order by month;

#Number of successful projects by amount raised
select 
    name as project_name,
    state,
    case
        when (goal * static_usd_rate) >= 1000000 then
		concat('$',round((goal * static_usd_rate) / 1000000, 2),'M')
        else concat('$',round((goal * static_usd_rate), 2))
    end as amount_raised
from 
    kickstarter_crowdfunding_project.projects
where 
    state = 'successful'
order by 
    (goal * static_usd_rate) desc;

#Number of successful projects by Number of backers
select name as project_name,
state,
backers_count
from kickstarter_crowdfunding_project.projects
where state='successful'
order by backers_count desc;

#Average Number Of Days For Successful Projects
select
Avg(datediff(from_unixtime(successful_at), from_unixtime(created_at))) AS avg_days
From kickstarter_crowdfunding_project.projects
where state = 'successful';

#Top 5 Succesful projects based on number of backers
select name as project_name,
backers_count
from kickstarter_crowdfunding_project.projects
where state= 'Successful'
order by backers_count desc
limit 5;

#Top 5 Succesful projects based on Amount Raised
select name as project_name,
concat('$',round(usd_pledged / 1000000, 2),'M') as usd_pledged
from 
kickstarter_crowdfunding_project.projects
where 
state = 'Successful'
order by 
usd_pledged * 1 desc
limit 5;

#Percentage Of successful projects overall
select concat(round(count(case when state='successful' then 1 end)*100.0/count(*),2),'%') as success_percentage 
from kickstarter_crowdfunding_project.projects;

#Percentage of successfull projects by category
select 
    c.name as category_name,
    concat(round(count(case when p.state = 'successful' then 1 end) * 100.0 / count(p.ProjectID),2),'%') as success_percentage
from 
    kickstarter_crowdfunding_project.projects p
join 
    kickstarter_crowdfunding_project.category c 
        on p.category_id = c.id
group by 
    c.name
order by 
    (count(case when p.state = 'successful' then 1 end) * 100.0 / count(p.ProjectID)) desc;

#Percentage of Successful Projects by Year
select
    year(from_unixtime(created_at)) as year,
    concat(round(100.0 * sum(case when state = 'successful' then 1 else 0 end)/ count(*), 2),'%') as success_percentage
from kickstarter_crowdfunding_project.projects
group by year
order by year;

#Percentage of Successful Projects by Quarter
select
    quarter(from_unixtime(created_at)) as quarter,
    concat(round(100.0 * sum(case when state = 'successful' then 1 else 0 end)/ count(*), 2),'%') as success_percentage
from kickstarter_crowdfunding_project.projects
group by quarter
order by quarter;

#Percentage of Successful Projects by Month 
select
    month(from_unixtime(created_at)) as month,
    concat(round(100.0 * sum(case when state = 'successful' then 1 else 0 end)/ count(*), 2),'%') as success_percentage
from kickstarter_crowdfunding_project.projects
group by month
order by month;

#Percentage of successful projects by goal range
select 
    case 
        when (goal * static_usd_rate) < 5000 then '< 5000'
        when (goal * static_usd_rate) between 5000 and 20000 then '5000 to 20000'
        when (goal * static_usd_rate) between 20000 and 50000 then '20000 to 50000'
        when (goal * static_usd_rate) between 50000 and 100000 then '50000 to 100000'
        else '> 100000'
    end as goal_range,
    count(ProjectID) as total_projects,
    count(case when state = 'successful' then 1 end) as successful_projects,
    concat(round(count(case when state = 'successful' then 1 end) * 100.0 / count(ProjectID),2),'%') as success_percentage
from 
    kickstarter_crowdfunding_project.projects
group by 
    goal_range
order by 
    (count(case when state = 'successful' then 1 end) * 100.0 / count(ProjectID)) desc;