#!/bin/sh
#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
# Run RM_ASM_2_CTL.SH as: grid OS user
# Deletes control files in ASM.
 
ORACLE_SID=+ASM
ORAENV_ASK='NO'
. oraenv
ORAENV_ASK=''
echo $ORACLE_SID >> /tmp/break.log
echo 'remove control file:' >> /tmp/break.log
asmcmd ls -l +FRA/ORCL/CONTROLFILE/* >> /tmp/break.log 2>&1
if [ $? -eq 0 ]
then
asmcmd rm -f +FRA/ORCL/CONTROLFILE/*
fi
echo 'remove control file:' >> /tmp/break.log
asmcmd ls -l +DATA/ORCL/CONTROLFILE/* >> /tmp/break.log 2>&1
if [ $? -eq 0 ]
then
asmcmd rm -f +DATA/ORCL/CONTROLFILE/*
fi

exit

