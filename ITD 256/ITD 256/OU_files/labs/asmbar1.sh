#!/bin/sh
#  -- DISCLAIMER:
#  -- This script is provided for educational purposes only. It is
#  -- NOT supported by Oracle World Wide Technical Support.
#  -- The script has been tested and appears to work as intended.
#  -- You should always run new scripts on a test instance initially.
#
echo "Executing file asmbar1.sh"  >>/tmp/dontouch.log
pwd >>/tmp/dontouch.log

export ORACLE_SID=+ASM
ORACLE_SID=+ASM
ORAENV_ASK='NO'
. oraenv >>/dev/null
ORAENV_ASK=''
echo $ORACLE_SID >>/tmp/dontouch.log
date >>/tmp/dontouch.log

# backup the database for a failed recovery  as the GRID user

/u01/app/grid/product/12.1.0/grid/bin/asmcmd md_backup /u01/backup/dontouch/dgbackup >>/tmp/dontouch.log

/u01/app/grid/product/12.1.0/grid/bin/asmcmd cp +DATA/ORCL/DATAFILE/EXAMPLE* /u01/backup/dontouch/example.dbf>> /tmp/dontouch.log
/u01/app/grid/product/12.1.0/grid/bin/asmcmd cp +DATA/ORCL/DATAFILE/SYSTEM* /u01/backup/dontouch/system.dbf>> /tmp/dontouch.log
/u01/app/grid/product/12.1.0/grid/bin/asmcmd cp +DATA/ORCL/DATAFILE/SYSAUX* /u01/backup/dontouch/sysaux.dbf>> /tmp/dontouch.log
/u01/app/grid/product/12.1.0/grid/bin/asmcmd cp +DATA/ORCL/DATAFILE/UNDOTBS* /u01/backup/dontouch/undotbs.dbf>> /tmp/dontouch.log
/u01/app/grid/product/12.1.0/grid/bin/asmcmd cp +DATA/ORCL/DATAFILE/USER* /u01/backup/dontouch/users.dbf>> /tmp/dontouch.log
/u01/app/grid/product/12.1.0/grid/bin/asmcmd cp +DATA/ORCL/CONTROLFILE/* /u01/backup/dontouch/control01.ctl>> /tmp/dontouch.log
/u01/app/grid/product/12.1.0/grid/bin/asmcmd cp +FRA/ORCL/CONTROLFILE/* /u01/backup/dontouch/control02.ctl>> /tmp/dontouch.log
/u01/app/grid/product/12.1.0/grid/bin/asmcmd cp +DATA/ORCL/spfileorcl.ora /u01/backup/dontouch/spfileorcl.ora>> /tmp/dontouch.log

# exit GRID user
exit
