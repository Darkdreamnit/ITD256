@connect scott/tiger


set echo on
column start_time new_val START
column stop       new_val STOP
column localtimestamp format a40
set autotrace on explain
set linesize 121
clear screen

select localtimestamp START_TIME, 'x' dummy from dual
union all
select localtimestamp, dummy from dual;
set autotrace off
pause
clear screen


declare
    l_rec emp%rowtype;
begin
    -- Perform a couple of transactions, each about 1 second apart on the same row...
    for i in 1 .. 10
    loop
        update emp set sal = sal*1.1 where empno = 7788;
        commit;
        dbms_lock.sleep(1);
        -- in the middle, lets shake it up a bit and do something else.  We'll 
        -- kick in some non-related transactions to the king record and 
        -- then a multi-statment transaction involving SCOTT
        if ( i = 5 ) 
        then
            for i in 1 .. 10
            loop
                update emp set ename = ename where ename = 'KING';
                commit;
            end loop;
            select * into l_rec from emp where empno = 7788;
            delete from emp where empno = 7788;
            update dept set dname = initcap(dname) where deptno = 10;
            commit;
            insert into emp values L_REC;
            commit;
        end if;
    end loop;
end;
/
pause
clear screen



select localtimestamp STOP from dual;
pause
set pause on
column versions_starttime format a22
column versions_endtime format a22
clear screen

select ename, sal,
       versions_operation,
       versions_starttime,
       versions_endtime
  from emp versions between timestamp to_timestamp('&START') and to_timestamp('&STOP')
 where empno = 7788
 order by versions_startscn nulls first
/
pause
clear screen

select ename, sal,
       versions_operation,
       versions_startscn,
       versions_endscn
  from emp versions between timestamp to_timestamp('&START') and to_timestamp('&STOP')
 where empno = 7788
 order by versions_startscn nulls first
/
pause
clear screen

select ename, sal,
       versions_operation,
       versions_xid
  from emp versions between timestamp to_timestamp('&START') and to_timestamp('&STOP')
 where empno = 7788
 order by versions_startscn nulls first
/
pause
clear screen


column versions_xid new_val XID
select versions_xid
  from emp versions between timestamp to_timestamp('&START') and to_timestamp('&STOP')
 where empno = 7788
   and versions_operation = 'D'
/
pause
set echo off
clear screen
prompt
prompt sys@ORA10GR1> grant SELECT ANY TRANSACTION to scott;
prompt  Grant succeeded.
prompt
set echo on


select * 
  from flashback_transaction_query
 where xid = hextoraw( '&XID' )
/

pause
set pause off
@reset
clear screen
