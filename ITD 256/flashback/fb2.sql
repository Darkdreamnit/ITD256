@connect scott/tiger


alter table emp disable row movement;
set echo on
clear screen

column SCN new_val S
select dbms_flashback.get_system_change_number SCN from dual;
pause
clear screen

update emp set sal = sal * 1.5;
commit;
pause
clear screen

column SCN new_val S2
select dbms_flashback.get_system_change_number SCN from dual;
pause
clear screen

select a.ename, a.sal new_sal, b.sal old_sal
  from emp a, emp as of SCN &S b
 where a.empno = b.empno
/
pause
clear screen

flashback table emp to scn &S;
pause
clear screen


alter table emp enable row movement;
pause
clear screen


flashback table emp to scn &S;
pause
clear screen


select ename, sal from emp;
pause
clear screen


update emp set ename = initcap(ename);
commit;
pause
clear screen

select ename, sal from emp;
pause
clear screen


flashback table emp to scn &S2;
pause
clear screen


select ename, sal from emp;
pause
clear screen

flashback table emp to scn &S;
select ename, sal from emp;
