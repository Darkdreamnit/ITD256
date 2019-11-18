#!/bin/sh
#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
# Start this script as OS user: oracle
#   This script is CLEANUP_06_2.sh.

. $LABS/set_db.sh
rman target / > /tmp/cleanup.log 2>&1 <<EOF
delete NOPROMPT backup of tablespace INVENTORY;
exit;
EOF

sqlplus /nolog >> /tmp/cleanup.log 2>&1 <<EOF
connect / as sysdba
DROP USER inventory cascade;
DROP TABLESPACE INVENTORY INCLUDING CONTENTS and DATAFILES;

EOF

echo "Cleanup done." >> /tmp/cleanup.log
exit
