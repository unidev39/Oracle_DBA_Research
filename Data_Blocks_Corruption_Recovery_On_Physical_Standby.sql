-- Issue seen on oracle Physical Standby - Oracle Alert Log
/*
Errors in file /opt/app/oracle/diag/rdbms/dr/racdb1/trace/racdb1_ora_8692.trc  (incident=388144):
ORA-01578: ORACLE data block corrupted (file # 16, block # 2305222)
ORA-01110: data file 16: '+DATA/dr/datafile/tbs_racdb.347.996020817'
ORA-26040: Data block was loaded using the NOLOGGING option
Incident details in: /opt/app/oracle/diag/rdbms/dr/racdb1/incident/incdir_388144/racdb1_ora_8692_i388144.trc
2021-07-23 18:44:24.216000 +05:45
Dumping diagnostic data in directory=[cdmp_20210723184424], requested by (instance=1, osid=8692), summary=[incident=388144].
2021-07-23 18:44:26.060000 +05:45
Sweep [inc][388144]: completed
Sweep [inc2][388144]: completed
2021-07-23 18:47:03.116000 +05:45
*/

1. Verify the Database Status

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,v$instance b;
/*
INST_ID STATUS  INSTANCE_NAME DATABASE_ROLE    OPEN_MODE
------- ------- ------------- ---------------- ---------
      1 MOUNTED racdb1        PHYSICAL STANDBY MOUNTED  
      2 MOUNTED racdb2        PHYSICAL STANDBY MOUNTED  
*/

2. Get the corrupted Blocks
SQL> SELECT * FROM v$database_block_corruption;
SQL> SELECT COUNT(*),file# FROM v$database_block_corruption GROUP BY file#;
--SQL> SELECT file#, bytes/(1024*1024*1024) gb,'backup datafile '||FILE#||' format ''+FRA/dump/datafile_'||FILE#||'.bkp'''||';' name  FROM v$datafile WHERE file# IN (SELECT DISTINCT file# FROM v$database_block_corruption);

3. Validate the Datafile from Alert Log 
RMAN> VALIDATE DATAFILE 16;
/*
Starting validate at 23-JUL-21
using target database control file instead of recovery catalog
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=399 instance=nplprod1 device type=DISK
channel ORA_DISK_1: starting validation of datafile
channel ORA_DISK_1: specifying datafile(s) for validation
input datafile file number=00018 name=+DATA/dr/datafile/tbs_silverbladebi.347.996020817
channel ORA_DISK_1: validation complete, elapsed time: 00:02:10
List of Datafiles
=================
File Status Marked Corrupt Empty Blocks Blocks Examined High SCN
---- ------ -------------- ------------ --------------- ----------
16   OK     4253           64483        4194309         50132299474
  File Name: +DATA/dr/datafile/tbs_silverbladebi.347.996020817
  Block Type Blocks Failing Blocks Processed
  ---------- -------------- ----------------
  Data       0              2556994
  Index      0              1544251
  Other      0              28574

Finished validate at 23-JUL-21
*/

4. Get the corrupted Blocks
SQL> SELECT * FROM v$database_block_corruption;
/*
FILE# BLOCK#  BLOCKS CORRUPTION_CHANGE# CORRUPTION_TYPE
----- ------  ------ ------------------ ---------------
16    64483   1      38968388646        NOLOGGING
*/

5. Recover the corrupted Blocks
RMAN> blockrecover datafile 16 block 64483;
/*
Starting recover at 23-JUL-21
using channel ORA_DISK_1

starting media recovery
media recovery complete, elapsed time: 00:00:00

Finished recover at 23-JUL-21
*/

6. Again Validate the Datafile 
RMAN> VALIDATE DATAFILE 16;
/*
Starting validate at 23-JUL-21
using channel ORA_DISK_1
channel ORA_DISK_1: starting validation of datafile
channel ORA_DISK_1: specifying datafile(s) for validation
input datafile file number=00016 name=+DATA/dr/datafile/tbs_racdb.347.996020817
channel ORA_DISK_1: validation complete, elapsed time: 00:02:35
List of Datafiles
=================
File Status Marked Corrupt Empty Blocks Blocks Examined High SCN
---- ------ -------------- ------------ --------------- ----------
16   OK     4253           64483        4194309         50132299474
  File Name: +DATA/dr/datafile/tbs_racdb.347.996020817
  Block Type Blocks Failing Blocks Processed
  ---------- -------------- ----------------
  Data       0              2556994
  Index      0              1544251
  Other      0              28574

Finished validate at 23-JUL-21
*/

7. Get the corrupted Blocks
SQL> SELECT * FROM v$database_block_corruption;
/*
FILE# BLOCK#  BLOCKS CORRUPTION_CHANGE# CORRUPTION_TYPE
----- ------  ------ ------------------ ---------------
16    64483   1      38968388646        NOLOGGING
*/

8. Recover all the corrupted Blocks
RMAN> RECOVER CORRUPTION LIST;
/*
Starting recover at 23-JUL-21
using channel ORA_DISK_1

starting media recovery
media recovery complete, elapsed time: 00:00:00

Finished recover at 23-JUL-21
*/

9. Verify the corrupted Blocks (Still Appeared)
SQL> SELECT * FROM v$database_block_corruption;
/*
FILE# BLOCK#  BLOCKS CORRUPTION_CHANGE# CORRUPTION_TYPE
----- ------  ------ ------------------ ---------------
16    64483   1      38968388646        NOLOGGING
*/

-- Resolution 
1. On the primary database, take backup of all the datafiles which reside on +FRA/dump/ mountpoint.

SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,v$instance b;
/*
INST_ID STATUS  INSTANCE_NAME DATABASE_ROLE    OPEN_MODE
------- ------- ------------- ---------------- ---------
      1 OPEN    racdb1        PRIMARY          READ WRITE
      2 OPEN    racdb1        PRIMARY          READ WRITE
*/

RMAN> backup datafile 16 format '+FRA/dump/datafile_16.bkp';

2. Transfer the backup pieces to the standby database

3. On the physical standby database, catalog the backuppieces.
SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,v$instance b;
/*
INST_ID STATUS  INSTANCE_NAME DATABASE_ROLE    OPEN_MODE
------- ------- ------------- ---------------- ---------
      1 MOUNTED racdb1        PHYSICAL STANDBY MOUNTED  
      2 MOUNTED racdb2        PHYSICAL STANDBY MOUNTED  
*/

RMAN> catalog backuppiece '+FRA/dump/datafile_16.bkp';
RMAN> list backuppiece '+FRA/dump/datafile_16.bkp';
RMAN> list backup of datafile 16;

4. Stop redo apply/MRP on the physical standby database.
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;

5. On the standby database, restore the datafile
RMAN> run
{
  ALLOCATE CHANNEL c1 DEVICE TYPE DISK;
  ALLOCATE CHANNEL c2 DEVICE TYPE DISK;
  ALLOCATE CHANNEL c3 DEVICE TYPE DISK;
  ALLOCATE CHANNEL c4 DEVICE TYPE DISK;
  restore datafile 16;
  release channel c1;
  release channel c2;
  release channel c3;
  release channel c4;
}

6. Cross Validate the Datafile
RMAN> VALIDATE DATAFILE 16;

7. Verify the corrupted Blocks
SQL> SELECT * FROM v$database_block_corruption;
-- No Row Returned

8. Start MRP on the physical standby database.

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT;

