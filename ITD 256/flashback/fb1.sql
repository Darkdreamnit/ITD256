@connect scott/tiger


set echo on
clear screen
column scn new_val scn format 9999999999999999999
select dbms_flashback.get_system_change_number SCN from dual;
pause
clear screen

update emp set sal = sal * 1.5;
commit;
pause
clear screen

set numformat 999999999999999
select a.ename, a.sal new_sal, b.sal old_sal
  from emp a, emp as of scn &SCN b
 where a.empno = b.empno
/
pause
clear screen

update emp
   set sal = ( select sal 
                 from emp as of scn &SCN b
                where b.empno = emp.empno )
/
commit;
pause
clear screen

select ename, sal from emp;



