@connect scott/tiger

alter table dept enable row movement;
set echo on
clear screen


create index emp_idx1 on emp(ename);
pause
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


drop index emp_idx1;
create index emp_idx2 on emp(job);
pause
clear screen

select index_name from user_indexes where table_name = 'EMP';
flashback table dept, emp to scn &S;
pause
clear screen

select index_name from user_indexes where table_name = 'EMP';
pause
clear screen

drop index emp_idx2;
