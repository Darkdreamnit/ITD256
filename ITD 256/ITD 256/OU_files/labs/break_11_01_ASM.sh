#!/bin/sh
#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
# DO NOT use in a production database severe damage could occur.
# This script deletes the SYSTEM tablespace in ASM.
#
export ORACLE_SID=orcl    > /tmp/break.log
chmod 777 /tmp/break.log
ORACLE_SID=orcl
ORAENV_ASK='NO'
. oraenv >>/dev/null
ORAENV_ASK=''
echo $ORACLE_SID >> /tmp/break.log

echo "BREAK_11_01.SH: Abort ORCL database " >> /tmp/break.log
srvctl stop database -d orcl -o abort

sleep 10
date >> /tmp/break.log
echo "Confirm: ora_pmon_orcl should NOT be listed" >> /tmp/break.log
pgrep -lf pmon >> /tmp/break.log

echo "Remove data file as GRID user. Enter oracle as password" >> /tmp/break.log
su - grid -c "$LABS/rm_asm_users.sh"

echo 'Issue created.'  >> /tmp/break.log

ORACLE_SID=orcl
ORAENV_ASK='NO'
. oraenv >>/dev/null
ORAENV_ASK=''

exit
