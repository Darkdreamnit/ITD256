-- DISCLAIMER:
-- This script is provided for educational purposes only. It is 
-- NOT supported by Oracle World Wide Technical Support.
-- The script has been tested and appears to work as intended.
-- You should always run new scripts on a test instance initially.
-- Modified by DKK for non-ASM database December 2014
/* RM_REDO_LOG_INACTIVE.SQL: remove an archive log file */

SET TERMOUT OFF
SET FEEDBACK OFF 
SET VERIFY OFF 
SET PAGESIZE 0 
SET HEADING OFF
SET SERVEROUTPUT ON
/* SPOOL rm_asm_log_file.sh REPLACE */
SPOOL rm_fs_log_file.sh REPLACE
/* select 'export ORACLE_SID=+ASM' from dual; */
/* select 'ORAENV_ASK=''NO''' from dual; */
/* select '. oraenv' from dual; */
/* select 'ORAENV_ASK=''''' from dual; */

/* select 'asmcmd rm -f "'||member||'"' */ 
select 'rm -f "'||member||'"'
	from v$log l, v$logfile lf
	where l.group# = lf.group#
	and sequence# = (select max(sequence#) from v$log 
		where status = 'INACTIVE')
        and rownum < 2;

SPOOL OFF
SET SQLPROMPT 'SQL> '
exit
