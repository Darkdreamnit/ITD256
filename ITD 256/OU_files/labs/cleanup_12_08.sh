#!/bin/sh
#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
# Written by Jim Spiller, Modified for 12c by MBillings
#

rman target / > /tmp/cleanup.log 2>&1 <<EOF

delete NOPROMPT copy of tablespace bartbs;
delete NOPROMPT backup tag 'TRANSPARENT';
exit
EOF

sqlplus  /nolog >> /tmp/cleanup.log 2>&1 <<EOF
connect / as sysdba

-- CLEANUP from previous run
DROP USER bar CASCADE;
DROP TABLESPACE bartbs INCLUDING CONTENTS AND DATAFILES;

-- CLOSE keystore (encryption wallet)
ADMINISTER KEY MANAGEMENT SET KEYSTORE CLOSE IDENTIFIED BY secret;

EXIT
EOF

rm -f /u01/app/oracle/admin/orcl/wallet/*
echo 'Wallet removed. Cleanup complete.'  >>/tmp/cleanup.log

exit
echo "Cleanup done." >> /tmp/cleanup.log
