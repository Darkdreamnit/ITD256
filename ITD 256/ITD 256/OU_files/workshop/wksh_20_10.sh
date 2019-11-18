#!/bin/sh
# -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
# Script WKSH_20_11.SH is for educational use ONLY
# running this script on a production database could result in permanent damage
# by J Spiller, updated M Billings
#
# Modified by DKK for non-ASM database January 2015
#
# configure the environment
cd $WORKS
. $LABS/set_db.sh

# This script creates the BAR user the bartbs tablespace
# and barcopy table. The table is populated
# and a backup is made.
# the databse is updated to prepare for this practice.

# drop tablespace BARTBS and user BAR before a backup is taken.
sqlplus -S /nolog > /tmp/setup.log 2>&1 <<EOF
connect / as sysdba

-- CLEANUP from previous run
DROP USER bar CASCADE;
DROP TABLESPACE bartbs INCLUDING CONTENTS AND DATAFILES;
exit 
EOF

# take a full backup
rman target / >> /tmp/setup.log 2>&1 <<EOF
backup database format '/u01/backup/orcl/%U';
exit;
EOF

#create BARTBS

sqlplus -S /nolog >> /tmp/setup.log 2>&1 <<EOF
connect / as sysdba

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
ALter system checkpoint;
exit;
EOF

#-- DO NOT Create backup of the bartbs tablespace
#rman target / >> /tmp/setup.log 2>&1 <<EOF
#
#BACKUP AS COPY TABLESPACE bartbs;
#EOF

#update other parts of the database
sqlplus / as sysdba >> /tmp/setup.log 2>&1 <<EOF
-- CLEANUP from previous run
DROP USER bar20 CASCADE;

-- Create user
CREATE USER bar20 IDENTIFIED BY oracle_4U
DEFAULT TABLESPACE USERS
QUOTA UNLIMITED ON USERS;

GRANT CREATE SESSION TO bar20;
CREATE TABLE bar20.barcopy
AS SELECT * FROM HR.EMPLOYEES;

ALTER SYSTEM SWITCH LOGFILE;
ALTER SYSTEM SWITCH LOGFILE;
ARCHIVE LOG LIST;
UPDATE BAR.BARCOPY SET SALARY = SALARY+1;
UPDATE BAR.BARCOPY SET SALARY = SALARY+1;
UPDATE BAR.BARCOPY SET SALARY = SALARY+1;
UPDATE BAR.BARCOPY SET SALARY = SALARY+1;

COMMIT;

exit
EOF


# break database
cd $LABS

# Shutdown the database abort
# srvctl stop database -d orcl -o abort
sqlplus / as sysdba >> /tmp/reak.log << EOF
shutdown abort
exit
EOF
sleep 10

# make the command file executable and run it.
# chmod 777 rm_asm_2_ctl.sh
# su - grid -c "$LABS/rm_asm_2_ctl.sh" >> /tmp/break.log
$LABS/rm_fs_2_ctl.sh >> /tmp/break.log

# remove asm file for USERS tablespace
# Comment from DKK: EXAMPLE tablespace is what is in the script, not USERS
# chmod 777 rm_asm_example.sh
# su - grid -c "$LABS/rm_asm_example.sh" >> /tmp/break.log
$LABS/rm_fs_example.sh >> /tmp/break.log
exit

# hintS if needed
echo "check for newly created tablespaces"
exit
