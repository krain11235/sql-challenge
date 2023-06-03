-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/


CREATE TABLE "departments" (
    "dept_no" varchar(8)   NOT NULL,
    "dept_name" varchar(40)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" varchar(8)   NOT NULL,
    "dept_no" varchar(8)   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" varchar(8)   NOT NULL,
    "emp_no" varchar(8)   NOT NULL
);

CREATE TABLE "employees" (
    "emp_no" varchar(8)   NOT NULL,
    "emp_title_id" varchar(8)   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" varchar(40)   NOT NULL,
    "last_name" varchar(40)   NOT NULL,
    "sex" varchar(1)   NOT NULL,
    "hire_date" date   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" varchar(8)   NOT NULL,
    "salary" money   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "titles" (
    "title_id" varchar(8)   NOT NULL,
    "title" varchar(40)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

--ALTER TABLE "titles" ADD CONSTRAINT "fk_titles_title_id" FOREIGN KEY("title_id")
--REFERENCES "employees" ("emp_title_id");

--1. List the employee number, last name, first name, sex, and salary of each employee.
-- from employees: emp_no, last_name, first_name, sex
-- from salaries: emp_no, salary
SELECT salaries.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees 
INNER JOIN salaries
ON salaries.emp_no = employees.emp_no
ORDER BY employees.emp_no
;

--2. List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name, last_name,hire_date 
FROM employees
WHERE extract(year from hire_date) = 1986
;

--3. List the manager of each department along with their department number, department name, employee number, last name, and first name.
--from dept_manager: dept_no, emp_no
--from departments: dept_no, dept_name
--from employees, emp_no, last_name, first_name
SELECT dept_manager.dept_no, departments.dept_name, dept_manager.emp_no, employees.last_name, employees.first_name
FROM dept_manager
JOIN departments ON dept_manager.dept_no = departments.dept_no
JOIN employees ON dept_manager.emp_no = employees.emp_no
ORDER BY last_name
;

--4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
--from dept_emp table: emp_no, dept_no
--from departments table: dept_no, dept_name
--from employees table: emp_no, last_name, first_name
SELECT dept_emp.dept_no, employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
JOIN employees ON dept_emp.emp_no = employees.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
ORDER BY dept_no
;

--5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
--from employees table: last_name, first_name, sex
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%'
ORDER BY last_name
;

--6. List each employee in the Sales department, including their employee number, last name, and first name.
--from employees table: emp_no, first_name, last_name
--from dept_emp table: dept_no, emp_no
--from departments table: dept_no, dept_name
--where dept_name = Sales
SELECT employees.emp_no, employees.last_name, employees.first_name
FROM employees
JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales'
ORDER BY last_name
;

--7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM employees
JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales' OR departments.dept_name = 'Development'
ORDER BY last_name
;

--8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
--from employees table:last_name
SELECT last_name, COUNT(*) AS name_count
FROM employees
GROUP BY last_name
ORDER BY name_count DESC
;
