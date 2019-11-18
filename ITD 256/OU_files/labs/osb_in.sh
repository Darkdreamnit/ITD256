#!/bin/bash
#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
# OSB script, run as admin OSB user
echo " Creating a test training library and virtual tapes" >> /tmp/setup.log

obtool -u admin --password oracle_4U chhost -r client,admin,mediaserver "edrsr04p1"
obtool -u admin --password oracle_4U mkdev -t library -o -S 36 -I 4 -a edrsr04p1:/u01/vlib -v vlib > NULL
obtool -u admin --password oracle_4U mkdev -t tape -o -a edrsr04p1:/u01/vdte1 -v -l vlib -d 1 vdte1 > NULL
obtool -u admin --password oracle_4U mkdev -t tape -o -a edrsr04p1:/u01/vdte2 -v -l vlib -d 2 vdte2 > NULL
obtool -u admin --password oracle_4U mkdev -t tape -o -a edrsr04p1:/u01/vdte3 -v -l vlib -d 3 vdte3 > NULL
obtool -u admin --password oracle_4U mkdev -t tape -o -a edrsr04p1:/u01/vdte4 -v -l vlib -d 4 vdte4 > NULL

obtool -u admin --password oracle_4U mkdev -t library -o -I 4 -a edrsr04p1:/u01/vlib2 -v vlib2 > NULL
obtool -u admin --password oracle_4U mkdev -t tape -o -a edrsr04p1:/u01/vdrive1 -v -l vlib2 -d 1 vdrive1 > NULL
obtool -u admin --password oracle_4U mkdev -t tape -o -a edrsr04p1:/u01/vdrive2 -v -l vlib2 -d 2 vdrive2  > NULL
# obtool -u admin --password oracle_4U lsdev

obtool -u admin --password oracle_4U insertvol -L vlib -c 250 unlabeled 1-32  > NULL
obtool -u admin --password oracle_4U insertvol -L vlib2 -c 250 unlabeled 1-14  > NULL
# obtool -u admin --password oracle_4U lsvol -L vlib2
