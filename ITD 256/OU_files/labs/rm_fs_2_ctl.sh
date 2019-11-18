#!/bin/sh
#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
# Copied from rm_asm_2_ctl.sh and edited by DKK for non-ASM database Jan 2015
 
echo $ORACLE_SID >> /tmp/break.log
echo 'remove control file:' >> /tmp/break.log
ls -l /u01/app/oracle/fast_recovery_area/orcl/control* >> /tmp/break.log 2>&1
if [ $? -eq 0 ]
then
rm -f /u01/app/oracle/fast_recovery_area/orcl/control*
fi
echo 'remove control file:' >> /tmp/break.log
ls -l /u01/app/oracle/oradata/orcl/control* >> /tmp/break.log 2>&1
if [ $? -eq 0 ]
then
rm -f /u01/app/oracle/oradata/orcl/control*
fi

exit

