#!/bin/sh
#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
#
# configure the environment
cd $LABS
. ./set_db.sh


# This script creates the ENC user, the ENCTBS tablespace
# and the ENC_COPY table with data from the HR.EMPLOYEES table
#

sqlplus -S /nolog > /tmp/setup.log 2>&1 <<EOF
connect / as sysdba

-- CLEANUP from previous run
DROP USER ENC CASCADE;
DROP TABLESPACE ENCTBS INCLUDING CONTENTS AND DATAFILES;

-- Create tablespace
CREATE TABLESPACE ENCTBS
DATAFILE '/u01/backup/orcl/enctbs01.dbf' SIZE 10M REUSE
SEGMENT SPACE MANAGEMENT MANUAL;

-- Create user
CREATE USER ENC IDENTIFIED BY oracle_4U 
DEFAULT TABLESPACE ENCtbs
QUOTA UNLIMITED ON ENCtbs;

GRANT CREATE SESSION TO ENC;

-- create table and populate 
-- be sure table is at least 2 blocks long
CREATE TABLE ENC.ENCcopy
TABLESPACE ENCtbs
AS SELECT * FROM HR.EMPLOYEES;

INSERT INTO ENC.ENCCOPY
SELECT * FROM ENC.ENCCOPY;

INSERT INTO ENC.ENCCOPY
SELECT * FROM ENC.ENCCOPY;

EOF
echo "Lab script complete." >> /tmp/setup.log
exit
