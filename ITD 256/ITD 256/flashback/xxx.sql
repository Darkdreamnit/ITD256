set echo on
clear screen
@connect /
drop user fb_demo cascade;
create user fb_demo identified by fb_demo;
grant dba to fb_demo;
@connect fb_demo/fb_demo;
@printtbl
clear screen

drop tablespace test_drop including contents;

create tablespace test_drop
datafile size 640k
autoextend on next 64k 
extent management local uniform size 64k
segment space management manual
/
alter user fb_demo default tablespace test_drop
/
pause
clear screen



@freespace on
pause
clear screen

begin
	for i in 1..9
	loop
		execute immediate
		'create table t' || i || ' ( x int )';
		execute immediate 
		'insert into t' || i || ' values ( :x )' using i;
	end loop;
end;
/
@freespace off
pause
clear screen



drop table t1;
exec print_table( q'|select * from user_recyclebin where original_name = 'T1'|' )
pause
clear screen
@freespace off
pause
clear screen

select * from t1;
flashback table t1 to before drop;
select * from t1;
@freespace off
pause
clear screen



drop table t1;
create table t0 ( x int );
@freespace off
pause
clear screen

flashback table t1 to before drop;
pause
clear screen

@freespace off
create index t0_idx on t0(x);
@freespace off
pause
clear screen

drop table t2;
exec print_table( 'select * from user_recyclebin' )
pause
clear screen
@freespace off
pause
clear screen

insert into t0 values ( 1 );
insert into t0 values ( 2 );
alter table t0 minimize records_per_block;
insert into t0 
select rownum 
  from all_objects 
 where rownum <= 6*2;
pause
clear screen

@freespace off
exec print_table( 'select * from user_recyclebin' )
pause
clear screen

insert into t0 values(1);
@freespace off
exec print_table( 'select * from user_recyclebin' )
