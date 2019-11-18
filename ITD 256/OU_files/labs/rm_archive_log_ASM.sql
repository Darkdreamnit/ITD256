-- DISCLAIMER:
-- This script is provided for educational purposes only. It is 
-- NOT supported by Oracle World Wide Technical Support.
-- The script has been tested and appears to work as intended.
-- You should always run new scripts on a test instance initially.
/* remove an archive log file that is minus 2 from the maximum sequence# */
SET TERMOUT OFF
SET FEEDBACK OFF 
SET VERIFY OFF 
/* SET PAGESIZE 0 */
SET HEADING OFF 
SET SERVEROUTPUT ON
SET SQLPROMPT ''
SPOOL rm_asm_log_file.sh REPLACE
select 'export ORACLE_SID=+ASM' from dual;
select 'ORAENV_ASK=''NO''' from dual;
select '. oraenv' from dual;
select 'ORAENV_ASK=''''' from dual;

select 'asmcmd rm -f "'||name||'"' 
  from v$archived_log 
  where (sequence#, resetlogs_id) = 
  (select SEQUENCE# - 2, resetlogs_id from v$archived_log
	 where first_time = (select distinct(max(first_time)) from v$archived_log));

SPOOL OFF
SET SQLPROMPT 'SQL> '
exit
