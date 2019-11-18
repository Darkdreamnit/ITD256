#!/bin/sh
#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
# backup_orcl.sh.sh
cd $LABS
. $LABS/set_db.sh

rman target "'/ as sysbackup'" catalog rcatowner/oracle_4U@rcat  > /tmp/backup.log 2>&1 <<EOF
BACKUP DATABASE PLUS ARCHIVELOG delete input;
exit;
EOF
echo "End of backup_orcl.sh"  >> /tmp/backup.log
exit
