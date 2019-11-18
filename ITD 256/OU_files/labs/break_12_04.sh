#!/bin/sh
#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
# Written by Jim Spiller, Modified for 12c by MBillings

. $LABS/set_db.sh > /tmp/break.log
echo $ORACLE_SID >> /tmp/break.log

echo 'Delete this password file:'  >> /tmp/break.log
ls $ORACLE_HOME/dbs/orapworcl >> /tmp/break.log
rm $ORACLE_HOME/dbs/orapworcl
echo 'Issue created.'  >> /tmp/break.log
exit
