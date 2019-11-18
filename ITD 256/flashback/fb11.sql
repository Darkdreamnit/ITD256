set echo on
clear screen
@connect fb_demo/fb_demo

select table_name, index_name from user_indexes;
drop table t0;
pause
clear screen
exec print_table( 'select * from user_recyclebin' )
pause
clear screen

flashback table t0 to before drop;
column index_name new_val I
select table_name, index_name from user_indexes;
alter index "&I" rename to t0_idx;
select table_name, index_name from user_indexes;

