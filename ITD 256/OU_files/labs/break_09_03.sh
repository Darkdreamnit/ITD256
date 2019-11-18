#!/bin/sh
#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
export ORACLE_SID=orcl
# create the command file to delete the BARTBS tablespace from ASM
sqlplus  / as sysdba @rm_named_file.sql BAR93TBS >/tmp/break.log
chmod 777 /tmp/break.log

# Shutdown the database abort
srvctl stop database -d orcl -o abort

sleep 30

# make the command file executable and run it.
chmod 777 rm_file.sh
./rm_file.sh >> /tmp/break.log
exit
echo 'End of break script.'  >> /tmp/break.log