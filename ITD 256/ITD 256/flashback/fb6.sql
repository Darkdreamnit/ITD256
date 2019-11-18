@connect scott/tiger

alter table dept enable row movement;
set echo on
clear screen

column SCN new_val S
select dbms_flashback.get_system_change_number SCN from dual;
pause
clear screen


update emp set ename = initcap(ename);
commit;
pause
clear screen

alter table emp add constraint emp_ename_unique unique(ename);
pause
clear screen

flashback table emp to scn &S;
pause
clear screen

update emp set ename = upper(ename);
alter table emp drop constraint emp_ename_unique;
flashback table emp to scn &S;
