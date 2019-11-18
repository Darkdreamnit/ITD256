#!/bin/bash
#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
# Run as oracle OS user
. $LABS/set_db.sh > /tmp/setup.log

if [ `whoami` != "oracle" ]; then
  echo "You are supposed to be logged on as oracle when running this script."
  exit
fi
x=`hostname --short`
echo $x           >> /tmp/setup.log
sed 's/edrsr04p1/'$x'/' osb_in.sh > osb_out.sh

cat $LABS/osb_out.sh >> /tmp/setup.log
. $LABS/osb_out.sh

ls /u01 >> /tmp/setup.log

obtool --user admin --password oracle_4U mkuser --class oracle --password oracle_4U --unixname oracle --unixgroup dba --ndmpuser no --preauth *:*:*+rman+cmdline oracle
echo "Created preauthorized OSB user oracle with password oracle_4U" >> /tmp/setup.log

echo "OSB configuration script completed." >> /tmp/setup.log