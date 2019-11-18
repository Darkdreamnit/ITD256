#!/bin/sh
# -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
# Script WKSH_20_03.SH is for educational use ONLY
# running this script on a production database could result in permanent damage
#
# BAR Workshop Script
# by J Spiller, updated by M Billings
# Updated by DKK for non-ASM database January 2015
#
# configure the environment

cd $WORKS
. $LABS/set_db.sh

# setup environment
# prepare for loss of  encryption wallet.

# create the encryption wallet and open it
mkdir -p $ORACLE_BASE/admin/orcl/wallet 

sqlplus / as sysdba >  /tmp/setup.log 2>&1 <<EOF
ADMINISTER KEY MANAGEMENT CREATE KEYSTORE '/u01/app/oracle/admin/orcl/wallet' IDENTIFIED BY secret;
ADMINISTER KEY MANAGEMENT SET KEYSTORE OPEN IDENTIFIED BY secret;
ADMINISTER KEY MANAGEMENT SET KEY IDENTIFIED BY secret WITH BACKUP;
-- Backup keystore: ADMINISTER KEY MANAGEMENT BACKUP KEYSTORE IDENTIFIED BY secret;
EXIT
EOF

# copy keystore for training use
cp $ORACLE_BASE/admin/orcl/wallet/ewallet.p12 /u01/backup/orcl/ewallet.p12

# This script creates the BAR user the bartbs tablespace
# and barcopy table. The table is populated
# and a backup is made.  
# the databse is updated to prepare for this practice.

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

-- Switch logfile
ALTER SYSTEM SWITCH Logfile;
ALTER system checkpoint;
exit;
EOF

# create an encrypted backup
rman target / >> /tmp/setup.log 2>&1 <<EOF
SET encryption ON FOR ALL TABLESPACES; 
backup tag 'TRANSPARENT' incremental level 0 database format '/u01/backup/orcl/%U';
exit;
EOF

# report backups with tag TRANSPARENT
sqlplus / as sysdba >> /tmp/setup.log 2>&1 <<EOF
@$LABS/lab_12_06_03.sql
exit;
EOF

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

UPDATE BAR.BARCOPY SET SALARY = SALARY+1;
UPDATE BAR.BARCOPY SET SALARY = SALARY+1;
UPDATE BAR.BARCOPY SET SALARY = SALARY+1;
UPDATE BAR.BARCOPY SET SALARY = SALARY+1;

COMMIT;

exit
EOF

# break database
# Shutdown the database abort
# srvctl stop database -d orcl -o abort
sqlplus / as sysdba >> /tmp/break.log << EOF
shutdown abort
exit
EOF
sleep 10

# remove data file for BARTBS tablespace
rm -f /u01/backup/orcl/bartbs.dbf

# remove regular keystores
rm -f /u01/app/oracle/admin/orcl/wallet/*

echo 'Database broken.'   >> /tmp/setup.log
exit
