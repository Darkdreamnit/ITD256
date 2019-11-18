#!/bin/sh
#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
# local scenario activation 

if [ $# != 1 ]
then
#  echo $#
  echo usage ./loc_scene.sh scenario#
  exit
fi
scenarionum=$1

#echo scenario_number=$scenarionum

target=host01

#echo target=$target
plink oracle@$target -pw oracle "scenario.sh $scenarionum"
exit
