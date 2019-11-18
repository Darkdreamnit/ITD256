#!/bin/sh
# -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
# Script WKSH_20_04.SH is for educational use ONLY
# running this script on a production database could result in permanent damage
#
# BAR Workshop Script
# by J Spiller, updated by M Billings
#
# setup for ASM disk group faiure external disk.
. $LABS/set_db.sh

# For ORCL switch logfiles 3 times
sqlplus / as sysdba > /tmp/setup.log <<EOF
ALTER SYSTEM SWITCH LOGFILE;
ALTER SYSTEM SWITCH LOGFILE;
ALTER SYSTEM SWITCH LOGFILE;
exit;
EOF

# stop orcl DB
srvctl stop database -d orcl

#stop DBTEST instance if it is started
if $(ps -ef |grep -qi DBTEST)
then
   tmp=$(pgrep -lf smon| grep -i DBTEST)
   ORACLE_SID=${tmp: -6}
sqlplus / as sysdba >> /tmp/setup.log <<-EOF
	shutdown immediate
EOF
fi 
# move ASM files to +FRA disk group
su - grid -c $LABS/asm_dg_data_copy.sh

exit
