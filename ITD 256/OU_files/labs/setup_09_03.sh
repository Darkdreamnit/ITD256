#!/bin/sh
#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is NOT
#  -- supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
# Run as oracle OS user
# This script creates the BAR93 user, the BAR93TBS tablespace,
# and BARCOPY table. The table is polpulated, a backup is taken and the
# the table is updated to prepare for this practice.

sqlplus -S /nolog > /tmp/setup.log 2>&1 <<EOF
connect / as sysdba

-- CLEANUP from previous run
DROP USER bar93 CASCADE;
DROP TABLESPACE bar93tbs INCLUDING CONTENTS AND DATAFILES;

-- Create tablespace
CREATE TABLESPACE bar93tbs
DATAFILE '+DATA/ORCL/DATAFILE/bar93tbs01.dbf' SIZE 10M REUSE
SEGMENT SPACE MANAGEMENT MANUAL;

-- Create user
CREATE USER BAR93 IDENTIFIED BY oracle_4U
DEFAULT TABLESPACE bar93tbs
QUOTA UNLIMITED ON bar93tbs;

GRANT CREATE SESSION TO BAR93;

-- create table and populate 
-- be sure table is at least 2 blocks long
CREATE TABLE BAR93.barcopy
TABLESPACE bar93tbs
AS SELECT * FROM HR.EMPLOYEES;

INSERT INTO BAR93.BARCOPY
SELECT * FROM BAR93.BARCOPY;

INSERT INTO BAR93.BARCOPY
SELECT * FROM BAR93.BARCOPY;

EOF

#-- Create backup of the bar*tbs tablespace

rman target / >> /tmp/setup.log 2>&1 <<EOF

BACKUP AS COPY TABLESPACE bar93tbs;
EOF

#-- update the table
sqlplus -S /nolog >> /tmp/setup.log 2>&1 <<EOF
connect / as sysdba

UPDATE BAR93.BARCOPY SET salary = salary+1;
COMMIT;
EOF
echo "Setup complete." >> /tmp/setup.log
