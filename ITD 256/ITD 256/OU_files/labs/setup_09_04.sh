#!/bin/sh
#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
# Run as oracle OS user

sqlplus -S /nolog > /tmp/setup.log 2>&1 <<EOF
connect / as sysdba

-- CLEANUP from previous run
DROP USER bc CASCADE;
DROP TABLESPACE bctbs INCLUDING CONTENTS AND DATAFILES;

-- Create tablespace
CREATE TABLESPACE bctbs 
DATAFILE '/u01/backup/orcl/bctbs01.dbf' SIZE 10M REUSE
SEGMENT SPACE MANAGEMENT MANUAL;

-- Create user
CREATE USER bc IDENTIFIED BY oracle_4U 
DEFAULT TABLESPACE bctbs
QUOTA UNLIMITED ON bctbs;

GRANT CREATE SESSION TO bc;

-- create table and populate 
-- be sure table is at least 2 blocks long
CREATE TABLE bc.bccopy
TABLESPACE bctbs
AS SELECT * FROM HR.EMPLOYEES;

INSERT INTO bc.bccopy
SELECT * FROM bc.bccopy;

INSERT INTO bc.bccopy
SELECT * FROM bc.bccopy;

EOF

#-- Create backup of the bctbs tablespace

rman target "'/ as sysbackup'" >> /tmp/setup.log 2>&1 <<EOF
BACKUP AS COPY TABLESPACE bctbs;
EOF

#-- update the table
sqlplus -S /nolog >> /tmp/setup.log 2>&1 <<EOF
connect / as sysdba

UPDATE bc.bccopy SET salary = salary+1;
COMMIT;
EOF
echo "Setup complete." >> /tmp/setup.log
