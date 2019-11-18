@connect scott/tiger
set echo on
clear screen
create table keep_scn( msg varchar2(25), scn number );
pause
clear screen

begin
    insert into keep_scn values 
	( 'start', dbms_flashback.get_system_change_number );

    for i in 1 .. 100
    loop
        update SCOTT.EMP set sal = sal * 1.01;
        commit;
    end loop;

    insert into keep_scn values 
	( 'stop', dbms_flashback.get_system_change_number );
    commit;
end;
/
pause
clear screen

variable x refcursor
declare
    l_scn number;
begin
    select scn into l_scn from keep_scn where msg = 'start';
    dbms_flashback.enable_at_system_change_number( l_scn );
    open :x for select ename, sal from SCOTT.EMP;
    dbms_flashback.disable;
end;
/
pause
clear screen
print x
pause 
clear screen

declare
    l_scn number;
begin
    select trunc(avg(scn)) into l_scn from keep_scn;
    dbms_flashback.enable_at_system_change_number( l_scn );
    open :x for select ename, sal from SCOTT.EMP;
    dbms_flashback.disable;
end;
/
pause
clear screen
print x

pause
clear screen
declare
    l_scn number;
begin
    select scn into l_scn from keep_scn where msg = 'stop';
    dbms_flashback.enable_at_system_change_number( l_scn );
    open :x for select ename, sal from SCOTT.EMP;
    dbms_flashback.disable;
end;
/
pause
clear screen
print x


pause
clear screen
declare
    cursor emp_cur is select empno, sal from SCOTT.emp;
    l_rec emp_cur%rowtype;
    l_scn number;
begin
    select scn into l_scn from keep_scn where msg = 'start';
    dbms_flashback.enable_at_system_change_number( l_scn );
    open emp_cur;
    dbms_flashback.disable;
    loop
        fetch emp_cur into l_rec;
        exit when emp_cur%notfound;
        update SCOTT.emp set sal = l_rec.sal where empno = l_rec.empno;
    end loop;
    close emp_cur;
    commit;
end;
/
pause
clear screen
select ename, sal from SCOTT.emp;
drop table keep_scn;

