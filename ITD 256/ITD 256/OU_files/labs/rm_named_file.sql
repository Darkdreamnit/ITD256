-- DISCLAIMER:
-- This script is provided for educational purposes only. It is 
-- NOT supported by Oracle World Wide Technical Support.
-- The script has been tested and appears to work as intended.
-- You should always run new scripts on a test instance initially.
/*  remove the files associated with a tablespace */
/*  named in paramter 1 - &1 */
SET TERMOUT OFF
SET FEEDBACK OFF 
SET VERIFY OFF 
/* SET PAGESIZE 0 */
/* SET HEADING OFF */
SET SERVEROUTPUT ON
SPOOL rm_file.sh REPLACE
DECLARE
   file_name VARCHAR2(128);
   cmd_str VARCHAR2(500);
   first_char CHAR(1);
BEGIN 
select name into file_name from v$datafile where 
   TS# = (select TS# from v$tablespace 
	where name = '&1');
first_char := substr(file_name,1,1);
IF (first_char = '+') 
THEN
dbms_output.PUT_LINE('su - grid -c "$LABS/rm_asm_file.sh '||file_name||'"');
ELSE
   dbms_output.PUT_LINE( './rm_fs_file.sh '||file_name);
END IF;
END;
.
/
SPOOL OFF
exit
