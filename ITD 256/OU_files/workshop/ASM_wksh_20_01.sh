#!/bin/sh
# -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
# Script WKSH_20_01.SH is for educational use ONLY
# running this script on a production database could result in permanent damage
#
# BAR Workshop Script
# by J Spiller
#
# configure the environment

cd $WORKS
. $LABS/set_db.sh

# setup environment
# prepare for loss of  inacive redo log (complete recovery possible)

# This script creates the BAR user the bartbs tablespace
# and barcopy table. The table is populated
# and a backup is made.  
# the databse is updated to prepare for this practice.

sqlplus -S /nolog > /tmp/setup.log 2>&1 <<EOF
connect / as sysdba

-- CLEANUP from previous run
DROP USER bar CASCADE;
DROP TABLESPACE bartbs INCLUDING CONTENTS AND DATAFILES;

-- Create tablespace
CREATE TABLESPACE bartbs
DATAFILE '/u01/backup/orcl/bartbs.dbf' SIZE 10M REUSE
SEGMENT SPACE MANAGEMENT MANUAL;

-- Create user
CREATE USER BAR IDENTIFIED BY oracle_4U 
DEFAULT TABLESPACE bartbs
QUOTA UNLIMITED ON bartbs;

GRANT CREATE SESSION TO BAR;

-- create table and populate 
-- be sure table is at least 2 blocks long
CREATE TABLE BAR.barcopy
TABLESPACE bartbs
AS SELECT * FROM HR.EMPLOYEES;

INSERT INTO BAR.BARCOPY
SELECT * FROM BAR.BARCOPY;

INSERT INTO BAR.BARCOPY
SELECT * FROM BAR.BARCOPY;

EOF

#  Switch logfile

sqlplus / as sysdba >> /tmp/setup.log 2>&1 <<EOF

ALTER SYSTEM SWITCH Logfile;
ALTER system checkpoint;
exit;
EOF

#-- Create backup of the bartbs tablespace

rman target / >> /tmp/setup.log 2>&1 <<EOF

BACKUP AS COPY TABLESPACE bartbs;
EOF

#update other parts of the database
sqlplus / as sysdba >> /tmp/setup.log 2>&1 <<EOF
-- CLEANUP from previous run
DROP USER bar20 CASCADE;

-- Create user
CREATE USER BAR20 IDENTIFIED BY oracle_4U
DEFAULT TABLESPACE USERS
QUOTA UNLIMITED ON USERS;

GRANT CREATE SESSION TO BAR20;
CREATE TABLE BAR20.barcopy
AS SELECT * FROM HR.EMPLOYEES;

UPDATE BAR.BARCOPY SET SALARY = SALARY+1;
UPDATE BAR.BARCOPY SET SALARY = SALARY+1;
UPDATE BAR.BARCOPY SET SALARY = SALARY+1;
UPDATE BAR.BARCOPY SET SALARY = SALARY+1;

COMMIT;

exit
EOF


# break database
cd $LABS
sqlplus / as sysdba @rm_redo_log_inactive.sql > /tmp/break.log

# Shutdown the database abort
srvctl stop database -d orcl -o abort
sleep 10

# make the command file executable and run it.
chmod 777 rm_asm_log_file.sh
su - grid -c "$LABS/rm_asm_log_file.sh" >> /tmp/break.log

exit
