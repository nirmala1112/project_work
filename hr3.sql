select * from emp_scd2_tgt;

create table emp_scd2_tgt as select * from employees where 1=2;

alter table emp_scd2_tgt add checksum varchar2(32);

alter table emp_scd2_tgt add flag number(1);

alter table emp_scd2_tgt add (insert_date date,update_date date,sk_id number(5));

select employee_id,manager_id from employees;



select emp1.employee_id,emp1.manager_id,emp2.manager_id,emp3.manager_id from employees emp1
left join employees emp2 on emp1.manager_id=emp2.employee_id 
left join employees emp3 on emp2.manager_id=emp3.employee_id;



select emp1.employee_id,emp1.manager_id,emp2.manager_id from employees emp1, employees emp2
where emp1.employee_id=emp2.manager_id;


select * from emp_Scd2_tgt;

update employees set salary=salary+1 where employee_id=100;
commit;

select * from employees order by department_id;

--second highest salary by department--

with employee_ranking as
(
select employee_id,first_name,last_name,salary,department_id,rank() over(partition by department_id order by salary desc) as ranking
from employees)
select employee_id,first_name,last_name,salary,department_id from employee_ranking where ranking=2 order by department_id;

--top five salaries--

with employee_ranking as
(
select employee_id,first_name,last_name,department_id,salary,row_number() over(order by salary desc) as rn from employees)
select employee_id,first_name,last_name,salary,department_id from employee_ranking where rn<=5 order by rn;






SELECT * FROM EMP_TGT_CMP;

SELECT
  first_name,
  last_name,
  salary
FROM employees e1
join (select avg(Salary) as avg_Salary,department_id from employees group by department_id) e2   
on e1.department_id = e2.department_id 
WHERE e1.salary > e2.avg_Salary;

SELECT
  first_name,
  last_name,
  salary
FROM employees e1
WHERE salary >
    (SELECT AVG(salary)
     FROM employees e2
     WHERE e1.department_id = e2.department_id)


SELECT
  SUM (CASE
    WHEN department_id IN ('80','40')
    THEN salary
    ELSE 0 END) AS total_salary_sales_and_hr,
  SUM (CASE
    WHEN department_id IN ('60','210')
    THEN salary
    ELSE 0 END) AS total_salary_it_and_support
FROM employees;



execute date_insert;


select * from (select employee_id,department_id from employees)
       PIVOT (count(employee_id) AS emp_count            
       FOR department_id IN (10, 20, 30,null));
       
--query for getting latest updated salary of all employees--     
with cte as
(select e.employee_id,e.department_id,a.update_date,a.salary,row_number() over(partition by e.employee_id order by e.salary desc) rn
from employees e
join lkp_emp a on e.employee_id=a.employee_id)
select * from cte 
where rn=1;

select emp1.employee_id,emp2.manager_id from employees emp1, employees emp2
where emp1.manager_id=emp2.employee_id;
       

select rownum from dual connect by rownum<=100;

select level from dual connect by level<=100;

select * from employees where department_id is null;

select * from
(select first_name,salary,department_id,dense_rank() over(partition by department_id order by salary desc)as drn from employees)
where drn=2;


--delete duplicate records

--1.
WITH cte AS
(
    SELECT ROW_NUMBER() OVER(PARTITION by empID ORDER BY ename) AS Rownum
    FROM emp
)
DELETE FROM cte
WHERE Rownum > 1
 
 --2.
  delete from table emp 
  where emp.salary in 
  (select salary from 
  (select salary, row_number() over (partition by employee_id order by salary) dup from emp) where dup>1);
  
--3.
  Delete from Employee a where rowid != (select max(rowid) from Employee b 
where a.Employee_num =b.Employee_num;
