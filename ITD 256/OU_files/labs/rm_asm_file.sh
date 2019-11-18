#!/bin/sh
#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
# Run as: grid OS user
#
# Deletes an ASM file.
#
export ORACLE_SID=+ASM
ORACLE_SID=+ASM
ORAENV_ASK='NO'
. oraenv
ORAENV_ASK=''

asmcmd <<-EOI
 rm -f $1
 exit
EOI
exit

