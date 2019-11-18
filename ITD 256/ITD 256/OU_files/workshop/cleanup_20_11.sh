#!/bin/sh
#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
# cleanup after a workshop

. $LABS/set_db.sh

# delete old backups first from rman then from /backup/orcl

rman target /  > /tmp/cleanup_20_11.log <<EOF
ALLOCATE CHANNEL FOR DELETE DEVICE TYPE DISK;
DELETE NOPROMPT BACKUP;
EXIT;
EOF

# Drop the BAR user and tablespace, and the BAR20 user

sqlplus / as sysdba >> /tmp/cleanup_20_11.log <<EOF

DROP USER BAR CASCADE;
DROP TABLESPACE BARTBS including contents and datafiles;
DROP USER BAR20 CASCADE;
EXIT;
EOF

rm -rf /u01/backup/orcl/*
rm -rf /u01/backup/alt

# take a new  backup

rman target /  >> /tmp/cleanup_20_11.log <<EOF
backup incremental level 0 database format '/u01/backup/orcl/%U';
exit;
EOF

# hints
echo 'New database backup was taken'

exit


