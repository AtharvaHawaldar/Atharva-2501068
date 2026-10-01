-- Q1 create database and use it
create database company_sql_test;
use company_sql_test;

-- Q2 create department and employee table
create table departments (
    dept_id int auto_increment primary key,
    dept_name varchar(100) not null,
    location varchar(100) not null
);

create table employees (
    emp_id int auto_increment primary key,
    emp_name varchar(100) not null,
    salary decimal(10, 2) not null,
    dept_id int,
    foreign key (dept_id) references departments(dept_id)
);

-- insert values in department and employees
insert into departments (dept_name, location) values
('HR', 'Mumbai'),
('Engineering', 'Pune'),
('Sales', 'Kolkata'),
('Marketing', 'Delhi'),
('Research', 'Gurgaon');

insert into employees (emp_name, salary, dept_id) values
('Atharva', 75000.00, 1),
('Krishna', 62000.00, 2),
('Pratik', 95000.00, 2),
('Pranay', 48000.00, 3),
('Kartik', 82000.00, 4),
('Shaurya', 55000.00, 1),
('Arjun', 88000.00, 2),
('Shlok', 71000.00, 3),
('Saloni', 67000.00, 4),
('Raj', 92000.00, 2);


-- Q3. Add an email column to the employees table using alter 
alter table employees add column email varchar(100);

update employees set email = 'atharva.hawaldar@company.com' where emp_id = 1;
update employees set email = 'krishna.sharma@company.com' where emp_id = 2;
update employees set email = 'pratik.patil@company.com' where emp_id = 3;
update employees set email = 'pranay.deshmukh@company.com' where emp_id = 4;
update employees set email = 'kartik.jagtap@company.com' where emp_id = 5;
update employees set email = 'shaurya.kulkarni@company.com' where emp_id = 6;
update employees set email = 'arjun.mehta@company.com' where emp_id = 7;
update employees set email = 'shlok.jain@company.com' where emp_id = 8;
update employees set email = 'saloni.verma@company.com' where emp_id = 9;
update employees set email = 'raj.singh@company.com' where emp_id = 10;

-- Q4. Add a status column using alter table with update status of 1 employee
Alter table employees add column status varchar(20) default 'Active';
select * from employees;
update employees set status = 'On Leave' where emp_id = 6;

-- Q5. Display employees whose salary is between 50,000 and 90,000, sorted from highest to lowest
select * from employees 
where salary between 50000 and 90000 
order by salary desc;

-- Q6. Display employees whose names start with 'A' and employees whose names contain the letter 'r'
select * from employees 
where emp_name LIKE 'A%' OR emp_name LIKE '%r%';

-- Q7. Display each department name and the number of employees including zero-employee departments
select d.dept_name, COUNT(e.emp_id) as employee_count
from departments d
left join employees e on d.dept_id = e.dept_id
group by  d.dept_id, d.dept_name;

-- Q8. Display the department name and average salary for departments whose average salary is greater than 70,000[cite: 1]
select d.dept_name, avg(e.salary) as avg_salary
from departments d
join employees e on d.dept_id = e.dept_id
group by d.dept_id, d.dept_name
having avg(e.salary) > 70000;


-- Q9. Display employee name, department name, location and salary using an INNER JOIN[cite: 1]
select e.emp_name, d.dept_name, d.location, e.salary
from employees e inner join departments d on e.dept_id = d.dept_id;

-- Q10. Find employees whose salary is greater than the overall average salary using a subquery[cite: 1]
select * from employees where salary > (select avg(salary) from employees);

-- Q11. Find employees whose salary is greater than the average salary of their own department using a correlated subquery[cite: 1]
select e1.* from employees e1
where e1.salary > (
    select avg(e2.salary) 
    from employees e2 
    where e2.dept_id = e1.dept_id
);

-- Q12. Use EXISTS to display departments with employees and NOT EXISTS for departments with no employees
select * from departments d
where exists(
    select 1 from employees e where e.dept_id = d.dept_id
);

-- Departments that have no employees:
select * from departments d
where not exists (
    select 1 from employees e where e.dept_id = d.dept_id
);

-- Q13. Use a window function to assign a DENSE_RANK to employees based on salary within each department
select emp_id, emp_name, salary, dept_id,
       dense_rank() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS salary_rank
FROM employees;

-- Q14. Display the top 2 highest-paid employees from each department using a window function and PARTITION BY
select emp_id, emp_name, salary, dept_id 
from (
    SELECT emp_id, emp_name, salary, dept_id,
           DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) as rnk
    FROM employees
) ranked_employees
WHERE rnk <= 2;

-- Q15. Write a CTE for average salaries and create a VIEW named employee_department_report
with DeptAvg as (
    select dept_id, avg(salary) as avg_sal
    from employees
    GROUP BY dept_id
)
SELECT e.emp_name, e.salary, e.dept_id, da.avg_sal
FROM employees e
JOIN DeptAvg da ON e.dept_id = da.dept_id
WHERE e.salary > da.avg_sal;

--  Creating the VIEW named employee_department_report
DROP VIEW IF EXISTS employee_department_report;
CREATE VIEW employee_department_report AS
SELECT e.emp_name, d.dept_name, e.salary, d.location
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;