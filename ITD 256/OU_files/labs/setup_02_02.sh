#!/bin/sh
#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
# configure the environment
. $LABS/set_db.sh

# This script creates the BAR22 user, the BAR22TBS tablespace
# and BARCOPY table. The table is populated
# and a backup is made.
# 

sqlplus -S /nolog > /tmp/setup.log 2>&1 <<EOF
connect / as sysdba

-- CLEANUP from previous run
DROP USER bar22 CASCADE;
DROP TABLESPACE bar22tbs INCLUDING CONTENTS AND DATAFILES;

-- Create tablespace
CREATE TABLESPACE bar22tbs
DATAFILE '/u01/backup/orcl/bar22tbs01.dbf' SIZE 10M REUSE
SEGMENT SPACE MANAGEMENT MANUAL;

-- Create user
CREATE USER BAR22 IDENTIFIED BY oracle_4U
DEFAULT TABLESPACE bar22tbs
QUOTA UNLIMITED ON bar22tbs;

GRANT CREATE SESSION TO BAR22;

-- create table and populate 
-- be sure table is at least 2 blocks long
CREATE TABLE BAR22.barcopy
TABLESPACE bar22tbs
AS SELECT * FROM HR.EMPLOYEES;

INSERT INTO BAR22.BARCOPY
SELECT * FROM BAR22.BARCOPY;

INSERT INTO BAR22.BARCOPY
SELECT * FROM BAR22.BARCOPY;

EOF

#  Switch logfile
sqlplus / as sysdba >> /tmp/setup.log 2>&1 <<EOF

ALTER SYSTEM SWITCH Logfile;
alter system checkpoint;
exit;
EOF
echo "Setup complete." >> /tmp/setup.log
exit
