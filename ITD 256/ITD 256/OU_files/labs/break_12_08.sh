#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
# Written by Jim Spiller, Modified for 12c by MBillings

. $LABS/set_db.sh > /tmp/break.log

# Shutdown the database abort
#srvctl stop database -d orcl -o abort

# Lines added by DKK for non-ASM database
sqlplus / as sysdba >> /tmp/break.log << EOF
shutdown abort
exit
EOF

sleep 10
echo 'ORCL should not be listed:'   >>/tmp/break.log
pgrep -lf pmon >>/tmp/break.log

# delete the SYSAUX data file from ASM
#su - grid -c $LABS/rm_asm_sysaux.sh

# Lines added by DKK for non-ASM database
rm -f /u01/app/oracle/oradata/orcl/sysaux01.dbf >> /tmp/break.log

echo 'SYSAUX Issue created.'  >> /tmp/break.log

rm -f /u01/app/oracle/admin/orcl/wallet/*
echo 'Wallet Issue created.'  >> /tmp/break.log

exit
