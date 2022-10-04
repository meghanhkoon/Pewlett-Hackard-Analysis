-- Deliverable 1: The Number of Retiring Employees by Title 
-- Retirement Titles Table
SELECT e.emp_no,
e.first_name,
e.last_name,
t.title,
t.from_date,
t.to_date
INTO retirement_titles
FROM employees as e
	INNER JOIN titles as t
		ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no ASC;
-- Check retirement_titles table
SELECT * FROM retirement_titles;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
rt.first_name,
rt.last_name,
rt.title
INTO unique_titles
FROM retirement_titles as rt
WHERE (rt.to_date = '9999-01-01')
ORDER BY emp_no, to_date DESC;
-- Check unique_titles table
SELECT * FROM unique_titles;

-- Number of retiring employees by title 
SELECT COUNT(ut.emp_no),
ut.title
INTO retiring_titles 
FROM unique_titles as ut
GROUP BY title
ORDER BY COUNT(title) DESC;
-- Check retiring titles table 
SELECT * FROM retiring_titles;

-- Deliverable 2: The Employees Eligible for the Mentorship Program 

-- mentorship eligibility
SELECT DISTINCT ON (e.emp_no) e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	t.title
INTO mentorship_eligibility
FROM employees as e
	INNER JOIN dept_emp as de
		ON (e.emp_no = de.emp_no)
	INNER JOIN titles as t
		ON (e.emp_no = t.emp_no) 
WHERE (t.to_date = '9999-01-01')
	AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;
-- Check mentorship_eligibility table
SELECT * FROM mentorship_eligibility 

-- Deliverable 3: ReadMe
-- positions in each dept to be filled 
SELECT * FROM unique_titles
SELECT * FROM retirement_titles

SELECT DISTINCT ON (ut.emp_no)
ut.emp_no,
ut.first_name,
ut.last_name,
ut.title,
de.dept_no,
d.dept_name
INTO titles_by_dept
FROM unique_titles as ut
	INNER JOIN dept_emp as de
		ON (ut.emp_no = de.emp_no) 
	INNER JOIN departments as d 
		ON (d.dept_no = de.dept_no) 
ORDER BY ut.emp_no, de.to_date DESC;

-- vacant positions by dept name and title 
SELECT tbd.dept_name, tbd.title, COUNT(tbd.title) 
INTO positions_to_fill_dept
FROM titles_by_dept as tbd
GROUP BY tbd.dept_name, tbd.title
ORDER BY tbd.dept_name DESC;

-- new mentorship eligibility - increased age gap and included senior titles
SELECT DISTINCT ON (e.emp_no) 
	e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	t.title
INTO new_mentorship
FROM employees as e
	INNER JOIN dept_emp as de
		ON (e.emp_no = de.emp_no)
	INNER JOIN titles as t
		ON (e.emp_no = t.emp_no) 
WHERE (t.title = 'Senior Staff')
	OR (t.title = 'Senior Engineer')
	AND (t.to_date = '9999-01-01')
	AND (e.birth_date BETWEEN '1965-01-01' AND '1975-12-31')
ORDER BY e.emp_no;