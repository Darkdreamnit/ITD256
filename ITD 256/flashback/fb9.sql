@connect scott/tiger


clear screen
set echo on

drop table temp;
create table temp as select * from emp;
pause
clear screen

select ename, ora_rowscn from temp where empno = 7788;

begin
	for x in ( select empno from temp where empno <> 7788 )
	loop
		update temp set ename=ename where empno=x.empno;
		commit;
	end loop;
end;
/
pause
clear screen

select ename, ora_rowscn from temp where empno = 7788;
pause
clear screen

drop table temp;
create table temp rowdependencies as select * from emp ;
pause
clear screen

select ename, ora_rowscn from temp where empno = 7788;

begin
	for x in ( select empno from temp where empno <> 7788 )
	loop
		update temp set ename=ename where empno=x.empno;
		commit;
		dbms_lock.sleep(1);
	end loop;
end;
/
pause
clear screen

select ename, ora_rowscn from temp where empno = 7788;
pause
clear screen
column scn2ts format a33

select empno, ora_rowscn, scn_to_timestamp(ora_rowscn) scn2ts
  from temp
 order by 2
/
