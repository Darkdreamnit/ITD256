@connect scott/tiger

alter session set optimizer_dynamic_sampling=0;

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

@trace
flashback table emp to scn &S;
pause
clear screen

@tk "sys=no"
