set echo on
clear screen

@connect "/ as sysdba"

shutdown immediate
startup mount
pause
clear screen

alter database archivelog;
alter system set db_flashback_retention_target = 1440 scope=both;
alter database flashback on;
show parameter db_recovery
pause
clear screen

alter database open;

@connect /
pause

@dbls
select count(*) from user_objects;
pause

clear screen
column SCN new_val S
select dbms_flashback.get_system_change_number SCN from dual;
@recreateme
set echo on
show user
select count(*) from user_objects;
pause
clear screen

@connect "/ as sysdba"
shutdown immediate
startup mount
pause
clear screen

flashback database to scn &s;
pause
clear screen
alter database open resetlogs;
pause
clear screen
@connect /
@dbls
select count(*) from user_objects;
pause

@connect "/ as sysdba"
shutdown immediate
startup mount
alter database flashback off;
alter database noarchivelog;
alter database open;
