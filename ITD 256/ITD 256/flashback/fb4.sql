@connect scott/tiger


alter table dept enable row movement;
set echo on
clear screen

column SCN new_val S
select dbms_flashback.get_system_change_number SCN from dual;
pause 
clear screen

insert into dept values ( 50, 'NewDept', 'Reston' );
commit;
insert into emp ( empno, deptno ) values ( 1234, 50 );
commit;
pause
clear screen

flashback table dept to scn &S;
pause
clear screen

select * from dept;
select empno from emp where deptno = 50;
pause 
clear screen

flashback table dept, emp to scn &S;
pause
clear screen

select * from dept;
select empno from emp where deptno = 50;
pause
clear screen

rollback;
select * from dept;
