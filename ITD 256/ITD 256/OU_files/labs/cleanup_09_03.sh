#!/bin/sh
#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is NOT
#  -- supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
#-- Cleanup practice tablespace and user

rman target / > /tmp/cleanup.log 2>&1 <<EOF
delete NOPROMPT copy of tablespace bar93tbs;
exit;
EOF

sqlplus -S /nolog >> /tmp/cleanup.log 2>&1 <<EOF
connect / as sysdba

-- CLEANUP from previous run
DROP USER bar93 CASCADE;
DROP TABLESPACE bar93tbs INCLUDING CONTENTS AND DATAFILES;

EXIT;
EOF
