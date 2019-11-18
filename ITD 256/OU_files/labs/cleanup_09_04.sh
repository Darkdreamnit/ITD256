#!/bin/sh
#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is NOT
#  -- supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
#-- Cleanup_09_04.sh: cleanup backup copy, tablespace, and user

rman target / > /tmp/cleanup.log 2>&1 <<EOF
delete NOPROMPT copy of tablespace bctbs;
exit;
EOF

sqlplus -S /nolog >> /tmp/cleanup.log 2>&1 <<EOF
connect / as sysdba
DROP USER bc CASCADE;
DROP TABLESPACE bctbs INCLUDING CONTENTS AND DATAFILES;
EXIT;
EOF

echo "End of cleanup_09_04.sh" >> /tmp/cleanup.log

