#!/bin/sh
#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
# Run as: grid OS user
#
# moves the disk group DATA
#
export ORACLE_SID=+ASM
ORACLE_SID=+ASM
ORAENV_ASK='NO'
. oraenv
ORAENV_ASK=''

# move ASM files to +FRA disk group
srvctl config asm | grep -q +DATA
if $(srvctl config asm | grep -q +DATA) 
then
   asmcmd spcopy -u +DATA/asm/asmparameterfile/registry.253.737195509 +FRA/ASM/asmparameterfile/spfileASM.ora
   echo "ASM spfile has been moved to +FRA dg"
else
   echo " ASM spfile is on filesystem"
fi  
   srvctl stop asm -o immediate -f
   srvctl start asm

# remove previous copies of metadata
rm /u01/backup/orcl/dgbackupDATA

#backup the asm metadata for disk group DATA
asmcmd md_backup /u01/backup/orcl/dgbackupDATA -G DATA

# drop the diskgroup DATA
asmcmd dropdg -r data

exit


