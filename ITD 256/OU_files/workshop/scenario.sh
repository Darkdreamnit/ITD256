#!/bin/sh
#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
# Script is for educational use ONLY 
# running this script on a production database could result in permanent damage
#
# BAR Workshop Script
# by J Spiller
#
# Modified by DKK for non-ASM database January 2014
#
snum=$1
# point to ORCL from the $WORKS directory

cd $WORKS
. $LABS/set_db.sh

case $snum in

# Warmups
# Loss of a redo log file (inactive)
1)
   ./wksh_20_01.sh
   ;;
# Loss of a redo log file (current)
2)
   ./wksh_20_02.sh
   ;;
# Loss of an encryption wallet
3)
   ./wksh_20_03.sh
   ;;
# Loss of a RO tablespace
4) 
   ./wksh_20_04.sh
  ;;
# Loss of a tablespace without a backup
5)
   ./wksh_20_05.sh
   ;;
# Loss of a tablespace in no-archivelog mode
6)
   ./wksh_20_06.sh
   ;;
# Loss of control files (recover with control trace)
7)
   ./wksh_20_07.sh
   ;;
# Loss of a tablepace and current redo log group
8)
   ./wksh_20_08.sh
   ;;
# Loss all controlfiles and a tablespace
9)
   ./wksh_20_09.sh
   ;;
# Loss of all control files and tablespace dropped and recreated since the last backup
10)
   ./wksh_20_10.sh
   ;;
# Loss of tablespace with backups not cataloged
11)
   ./wksh_20_1xi12.sh
   ;;
# Loss of a single control file
*)
   echo 'Usage scenario.sh <scenario#> eg ./scenario.sh 3'
esac
exit
