#!/bin/sh
#  -- DISCLAIMER:
#  -- This CLEANUP_20_03.SH script is provided for educational purposes
#  -- only. It is NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
. $LABS/set_db.sh

# delete encrypted backups
 rman target /  > /tmp/cleanup_20_03.log <<EOF
ALLOCATE CHANNEL FOR DELETE DISK TYPE DISK;
DELETE NOPROMPT BACKUP TAG TRANSPARENT;
EXIT;
EOF

# close the wallet
sqlplus / as sysdba >> /tmp/cleanup_20_03.log <<EOF
ADMINISTER KEY MANAGEMENT SET KEYSTORE CLOSE IDENTIFIED BY secret;
exit;
EOF

echo 'Remove copied keystore' >> /tmp/cleanup_20_03.log
rm /u01/backup/orcl/ewallet.p12

sqlplus -S /nolog > /tmp/setup.log 2>&1 <<EOF
connect / as sysdba
DROP USER bar20 CASCADE;
DROP USER bar CASCADE;
DROP TABLESPACE bartbs INCLUDING CONTENTS AND DATAFILES;
exit
EOF

# take a new unencrypted backup
rman target "'/ as sysbackup'" >> /tmp/cleanup_20_03.log <<EOF
backup incremental level 0 database format '/u01/backup/orcl/%U';
exit;
EOF

exit


