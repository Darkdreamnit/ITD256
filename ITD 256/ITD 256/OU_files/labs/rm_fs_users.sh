#!/bin/sh
#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
# Run as: grid OS user
# Deletes USERS data files in ASM file.
#
# Copied from rm_asm_users.sh and edited by DKK for non-ASM database Jan 2014
#
# ORACLE_SID=+ASM
# ORAENV_ASK='NO'
# . oraenv
# ORAENV_ASK=''
echo $ORACLE_SID >> /tmp/break.log
# asmcmd rm -f +DATA/ORCL/DATAFILE/USERS* >> /tmp/break.log
rm -f /u01/app/oracle/oradata/orcl/users01.dbf
exit

