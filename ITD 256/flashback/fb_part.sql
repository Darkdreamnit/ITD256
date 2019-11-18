@connect scott/tiger
set echo on
clear screen
/*
drop table partitioned;

CREATE TABLE partitioned
(
  data       char(255),
  temp_date  date
)
PARTITION BY RANGE (temp_date) (
  PARTITION part1 VALUES LESS THAN (to_date('13-mar-2003','dd-mon-yyyy')) ,
  PARTITION part2 VALUES LESS THAN (to_date('14-mar-2003','dd-mon-yyyy')) ,
  PARTITION part3 VALUES LESS THAN (to_date('15-mar-2003','dd-mon-yyyy')) ,
  PARTITION part4 VALUES LESS THAN (to_date('16-mar-2003','dd-mon-yyyy')) ,
  PARTITION part5 VALUES LESS THAN (to_date('17-mar-2003','dd-mon-yyyy')) ,
  PARTITION part6 VALUES LESS THAN (to_date('18-mar-2003','dd-mon-yyyy')) ,
  PARTITION junk VALUES LESS THAN (MAXVALUE)
)
enable row movement
;
*/

pause
clear screen

column SCN new_val S
select dbms_flashback.get_system_change_number SCN from dual;
pause
clear screen

insert into partitioned 
select 'x', to_date('12-mar-2003')+mod(rownum,6)
  from all_users;
select count(*) from partitioned;
commit;
pause
clear screen

column SCN new_val S2
select dbms_flashback.get_system_change_number SCN from dual;
pause
clear screen

flashback table partitioned to scn &S;
select count(*) from partitioned;
pause
clear screen

flashback table partitioned to scn &S2;
select count(*) from partitioned;
pause
clear screen

flashback table partitioned partition(part1) to scn &S;
