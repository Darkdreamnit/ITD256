#!/bin/sh
# -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
# Script WKSH_20_08.SH is for educational use ONLY
# running this script on a production database could result in permanent damage
# by J Spiller
#
# Updated by DKK for non-ASM database January 2015
# configure the environment
cd $WORKS
. $LABS/set_db.sh

# setup environment
# prepare for loss of all control files

# This script creates the BAR user the bartbs tablespace
# and barcopy table. The table is populated,
# the databse is updated to prepare for this practice.

# remove prior backups of this tablespace
rman target / >> /tmp/setup.log 2>&1 <<EOF
ALLOCATE CHANNEL FOR DELETE DEVICE TYPE DISK;
DELETE NOPROMPT BACKUP of TABLESPACE BARTBS;
EOF

sqlplus -S /nolog >> /tmp/setup.log 2>&1 <<EOF
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

# backup BARTBS 
rman target /  >> /tmp/setup.log 2>&1 <<EOF
backup tablespace BARTBS;
EOF

# make a trace of the control file 
sqlplus / as sysdba  >> /tmp/setup.log 2>&1 <<EOF
alter database backup controlfile to trace as '/u01/backup/orcl/control.trc' REUSE;
exit;
EOF

# Update the tablespace
#update other parts of the database
sqlplus / as sysdba >> /tmp/setup.log 2>&1 <<EOF
-- CLEANUP from previous run
DROP USER bar20 CASCADE;

-- Create user
CREATE USER bar20 IDENTIFIED BY oracle_4U
DEFAULT TABLESPACE USERS
QUOTA UNLIMITED ON USERS;

GRANT CREATE SESSION TO BAR20;
CREATE TABLE bar20.barcopy
AS SELECT * FROM HR.EMPLOYEES;


UPDATE BAR.BARCOPY SET SALARY = SALARY+1;
UPDATE BAR.BARCOPY SET SALARY = SALARY+1;
UPDATE BAR.BARCOPY SET SALARY = SALARY+1;
UPDATE BAR.BARCOPY SET SALARY = SALARY+1;

COMMIT;

exit
EOF

# Shutdown the database abort
# srvctl stop database -d orcl -o abort
sqlplus / as sysdba >> /tmp/break.log << EOF
shutdown abort
exit
EOF
 sleep 10

# make the command file executable and run it.
# chmod 777 $LABS/rm_asm_2_ctl.sh
# su - grid -c "$LABS/rm_asm_2_ctl.sh" >> /tmp/break.log

$LABS/rm_fs_2_ctl.sh >> /tmp/break.log

exit
