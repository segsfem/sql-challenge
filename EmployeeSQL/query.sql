-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/2MWyow
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

-- Modify this code to update the DB schema diagram.
-- To reset the sample schema, replace everything with
-- two dots ('..' - without quotes).

CREATE TABLE "departments" (
    "dept_no" varchar   NOT NULL,
    "dept_name" varchar   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "employees" (
    "emp_no" int   NOT NULL,
    "emp_title" varchar   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" varchar   NOT NULL,
    "last_name" varchar   NOT NULL,
    "sex" varchar   NOT NULL,
    "hire_date" date   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "titles" (
    "title_id" varchar   NOT NULL,
    "title" varchar   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

DROP TABLE dept_emp;
CREATE TABLE "dept_emp" (
    "emp_no" int   NOT NULL,
    "dept_no" varchar   NOT NULL,
    CONSTRAINT "pk_dept_emp" PRIMARY KEY (
        "emp_no", "dept_no"
     )
);

DROP TABLE dept_manager;
CREATE TABLE "dept_manager" (
    "dept_no" varchar   NOT NULL,
    "emp_no" int   NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "dept_no", "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" int   NOT NULL,
    "salary" int   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);



ALTER TABLE "departments" ADD CONSTRAINT "fk_departments_dept_no" FOREIGN KEY("dept_no")
REFERENCES "dept_emp" ("dept_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "salaries" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "dept_manager" ("dept_no");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_no" FOREIGN KEY("emp_no")
REFERENCES "dept_emp" ("emp_no");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title" FOREIGN KEY("emp_title")
REFERENCES "titles" ("title_id");

CREATE INDEX "idx_departments_dept_name"
ON "departments" ("dept_name");

-- List of employee: emp_no, last_name, first_name, sex and salary
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees as e
INNER JOIN salaries as s ON
e.emp_no = s.emp_no;

-- List of last_name, first_name and hire date of employees hired in 1986
SELECT first_name, last_name, hire_date 
from employees 
WHERE to_char(hire_date, 'DD/MM/YYYY') LIKE '__/__/1986';

-- List of manager in each department with department no, department name, emp_no, last_name and first_name
SELECT d.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name
from departments as d
inner join dept_manager as dm ON
d.dept_no = dm.dept_no
inner  join employees as e ON 
dm.emp_no = e.emp_no;

-- List of emp_no, last_name, first_name and department name

SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
from employees as e
inner join dept_emp as de ON
e.emp_no = de.emp_no
inner  join departments as d ON 
de.dept_no = d.dept_no;

-- List of first_name, last_name and sex for employees where first name is "Hercules" and last name begin with "B"
SELECT first_name, last_name, sex
from employees
where first_name = 'Hercules'
AND last_name like 'B%';

-- List of emp_no, last_name, first_name and department name in the Sales department
	
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
from employees as e
inner join dept_emp as de ON
e.emp_no = de.emp_no
inner  join departments as d ON 
de.dept_no = d.dept_no
WHERE dept_name = 'Sales';

-- List of emp_no, last_name, first_name and department name in the Sales and Development department
	
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
from employees as e
inner join dept_emp as de ON
e.emp_no = de.emp_no
inner  join departments as d ON 
de.dept_no = d.dept_no
WHERE dept_name = 'Sales' 
OR dept_name = 'Research';

-- Count of employee last name in descending order
SELECT last_name, COUNT(last_name) as count
FROM employees
GROUP BY last_name 
ORDER BY count DESC;