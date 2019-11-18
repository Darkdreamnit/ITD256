#!/bin/sh
#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
# cleanup_08_02.sh
cd $LABS
. $LABS/set_db.sh

rman target / > /tmp/cleanup.log 2>&1 <<EOF
delete NOPROMPT backup of tablespace enctbs;
exit;
EOF

sqlplus -S /nolog >> /tmp/cleanup.log 2>&1 <<EOF
connect / as sysdba

DROP USER ENC CASCADE;
DROP TABLESPACE ENCTBS INCLUDING CONTENTS AND DATAFILES;
EOF

exit
