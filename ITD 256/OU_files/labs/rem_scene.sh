#!/bin/sh
#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
# remote scenario activation

if [ $# < 2 ]
then
  echo usage ./rem_scene.sh workstation# scenario#
  exit
if
mach=$1
scenarionum=$2

#echo machine=$mach
#echo scenario_number=$scenarionum
string="s/\([tT]\)[0-9]\{1,2\}/\1$mach/"

#echo $string

target=`hostname`

target=`echo $target|sed $string`

#echo $target
plink vncuser@$target -pw vnctech "~/loc_scene.sh $scenarionum"

exit
