#!/bin/sh
#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
# Modified by DKK for non-ASM database January 2015
#
# cleanup after a workshop
#

. $LABS/set_db.sh

# Drop the BAR and BAR20 users, and the BARTBS tablespace
# Added by DKK January 2015
sqlplus / as sysdba >> /tmp/cleanup_20_06.log << EOF
DROP USER bar CASCADE;
DROP TABLESPACE bartbs INCLUDING CONTENTS AND DATAFILES;
DROP USER bar20 CASCADE;
exit
EOF

# delete old backups first from rman then from /backup/orcl

rman target /  > /tmp/cleanup_20_06.log <<EOF
ALLOCATE CHANNEL FOR DELETE DEVICE TYPE DISK;
DELETE NOPROMPT BACKUP;
EXIT;
EOF

rm -rf /u01/backup/orcl/*

# put database in archivelog mode
# srvctl stop database -d orcl
# srvctl start database -d orcl -o mount

sqlplus / as sysdba >> /tmp/cleanup_20_06.log <<EOF
shutdown immediate
startup mount
alter database archivelog;
alter database open;
exit;
EOF

# take a new  backup

rman target /  >> /tmp/cleanup_20_06.log <<EOF
backup incremental level 0 database format '/u01/backup/orcl/%U';
exit;
EOF

# hints
echo 'New database backup was taken'

exit


