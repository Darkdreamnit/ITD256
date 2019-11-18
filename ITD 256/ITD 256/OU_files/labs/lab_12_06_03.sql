-- DISCLAIMER:
-- This script is provided for educational purposes only. It is 
-- NOT supported by Oracle World Wide Technical Support.
-- The script has been tested and appears to work as intended.
-- You should always run new scripts on a test instance initially.

/* display the backup pieces and the encryption status of each */
/* Where the Tag is 'TRANSPARENT' */
SET PAGES 99
COL_BS_REC FORMAT 99999
COL BP_REC FORMAT 99999
COL ENCRYPTED FORMAT A7
COL TAG    FORMAT A12
COL MEDIA_HANDLE FORMAT a40

SELECT s.recid as BS_REC, P.RECID as BP_REC, P.ENCRYPTED, P.TAG, p.HANDLE as MEDIA_HANDLE
from v$BACKUP_PIECE P, V$BACKUP_SET S
WHERE P.SET_STAMP=S.SET_STAMP
and P.SET_COUNT = S.SET_COUNT
and P.TAG='TRANSPARENT'
/

exit
