[oracle@DB-RAC1 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is running on node DB-RAC1
Instance racdb2 is running on node DB-RAC2
*/

[oracle@DB-RAC1 ~]$ srvctl stop database -d racdb
[oracle@DB-RAC1 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is not running on node DB-RAC1
Instance racdb2 is not running on node DB-RAC2
*/

[oracle@DB-RAC1 ~]$ srvctl remove instance -d racdb -i racdb1
/*
Remove instance from the database racdb? (y/[n]) y
*/

[oracle@DB-RAC1 ~]$ srvctl remove instance -d racdb -i racdb2
/*
Remove instance from the database racdb? (y/[n]) y
*/

[oracle@DB-RAC1 ~]$ srvctl status database -d racdb
/*
Database is not running.
*/

[oracle@DB-RAC1 ~]$ srvctl remove database -d racdb
/*
Remove the database racdb? (y/[n]) y
*/

[oracle@DB-RAC1 ~]$ srvctl status database -d racdb
/*
PRCD-1120 : The resource for database racdb could not be found.
PRCR-1001 : Resource ora.racdb.db does not exist
*/

[oracle@DB-RAC1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Tue Jun 16 10:59:31 2020

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to an idle instance.

SQL> startup
ORACLE instance started.

Total System Global Area 1.2827E+10 bytes
Fixed Size                  2240344 bytes
Variable Size            1811939496 bytes
Database Buffers         1.1006E+10 bytes
Redo Buffers                7335936 bytes
Database mounted.
Database opened.

SQL> alter system set cluster_database=false scope=spfile;

System altered.

SQL> alter system set cluster_database_instances=1 scope=spfile;

System altered.

SQL> alter database disable thread 2;

Database altered.

SQL> select thread#, group# from v$log;

   THREAD#     GROUP#
---------- ----------
         1          1
         1          2
         1          3
         2          4
         2          5
         2          6

6 rows selected.

SQL> alter database drop logfile group 4;

Database altered.

SQL> alter database drop logfile group 5;

Database altered.

SQL> alter database drop logfile group 6;

Database altered.

SQL> select thread#, group# from v$log;

   THREAD#     GROUP#
---------- ----------
         1          1
         1          2
         1          3

SQL> select tablespace_name from dba_data_files where tablespace_name like 'UNDOTBS%';

TABLESPACE_NAME
------------------------------
UNDOTBS1
UNDOTBS1
UNDOTBS1
UNDOTBS1
UNDOTBS1
UNDOTBS1
UNDOTBS1
UNDOTBS2
UNDOTBS2
UNDOTBS2
UNDOTBS2

TABLESPACE_NAME
------------------------------
UNDOTBS2
UNDOTBS2

13 rows selected.

SQL> drop tablespace UNDOTBS2 including contents and datafiles;

Tablespace dropped.

SQL> select tablespace_name from dba_data_files where tablespace_name like 'UNDOTBS%';

TABLESPACE_NAME
------------------------------
UNDOTBS1
UNDOTBS1
UNDOTBS1
UNDOTBS1
UNDOTBS1
UNDOTBS1
UNDOTBS1

7 rows selected.

SQL> create pfile from spfile;

File created.

SQL> shut immediate;
Database closed.
Database dismounted.
ORACLE instance shut down.
SQL> startup mount restrict
ORACLE instance started.

Total System Global Area 1.2827E+10 bytes
Fixed Size                  2240344 bytes
Variable Size            1811939496 bytes
Database Buffers         1.1006E+10 bytes
Redo Buffers                7335936 bytes
Database mounted.


SQL> drop database;

Database dropped.

Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
SQL> exit
Disconnected
*/

[root@DB-RAC1 bin]# su - grid
[grid@DB-RAC1 ~]$ asmcmd
/*
ASMCMD> ls
ARC/
DATA/
DATA2/
FRA/
OCR/
ASMCMD> cd +ARC/primary/archivelog
ASMCMD> ls
2020_06_16/
ASMCMD> cd 2020_06_16
ASMCMD> ls
thread_1_seq_1705.396.1043231407
thread_2_seq_790.370.1043232749
ASMCMD> rm thread*
You may delete multiple files and/or directories. 
Are you sure? (y/n) y
ASMCMD> cd +DATA/racdb
ASMCMD> ls
controlfile/
datafile/
onlinelog/
parameterfile/
redo0401.log
redo0402.log
redo0501.log
redo0502.log
redo0601.log
redo0602.log
spfileracdb.ora
tempfile/
ASMCMD> rm redo*
You may delete multiple files and/or directories. 
Are you sure? (y/n) y
ASMCMD> rm spfileracdb.ora
ASMCMD> exit
*/

[root@DB-RAC1 dbs]# cd /opt/app/oracle/product/11.2.0.3/db_1/dbs
[root@DB-RAC1 dbs]# vi initracdb1.ora
/*
SPFILE='+DATA/racdb/spfileracdb.ora'                # line added by Agent
*/

-- Required file from SOURCE_DB Server
[oracle@SOURCE_DB1 backup]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Sun Apr 5 09:55:11 2020

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> create pfile='/home/oracle/backup/spfileracdb.ora' from spfile;

File created.

SQL> exit;
*/

[oracle@DB-RAC1 Old_DB_Config_File]$ ls -ltr
/*
-rwxrwxr-x 1 oracle oinstall 26435 May 24 00:40 sorcedb_ramn_fullbackup_log.log
-rwxrwxr-x 1 oracle oinstall  2229 May 24 11:27 spfileracdb.ora
-rwxrwxr-x 1 oracle oinstall  1536 May 24 11:29 orapwracdb1
-rwxrwxr-x 1 oracle oinstall    64 May 24 11:29 initracdb1.ora
-rwxrwxr-x 1 oracle oinstall  1536 May 24 11:31 orapwracdb2
-rwxrwxr-x 1 oracle oinstall    41 May 24 11:31 initracdb2.ora
*/ 


[oracle@DB-RAC1 Old_DB_Config_File]$ cd /opt/app/oracle/product/11.2.0.3/db_1/dbs/
[oracle@DB-RAC1 dbs]$ ls
/*
initracdb1.ora  init.ora  orapwracdb1
*/
   
[oracle@DB-RAC1 Old_DB_Config_File]$ ssh oracle@DB-RAC2
[oracle@DB-RAC2 ~]$ cd /opt/app/oracle/product/11.2.0.3/db_1/dbs/
[oracle@DB-RAC2 dbs]$ ls
/*
initracdb2.ora  init.ora  orapwracdb2
*/

[oracle@DB-RAC2 dbs]$ exit
/*
logout
Connection to DB-RAC2 closed.
*/

[oracle@DB-RAC1 Old_DB_Config_File]$ vi spfileracdb.ora
/* 
racdb2.__db_cache_size=8657043456
racdb1.__db_cache_size=7717519360
racdb2.__java_pool_size=201326592
racdb1.__java_pool_size=201326592
racdb1.__large_pool_size=201326592
racdb2.__large_pool_size=167772160
racdb2.__oracle_base='/opt/app/oracle'#ORACLE_BASE set from environment
racdb1.__oracle_base='/opt/app/oracle'#ORACLE_BASE set from environment
racdb1.__pga_aggregate_target=3388997632
racdb2.__pga_aggregate_target=3388997632
racdb1.__sga_target=12884901888
racdb2.__sga_target=12884901888
racdb1.__shared_io_pool_size=536870912
racdb2.__shared_io_pool_size=536870912
racdb2.__shared_pool_size=3221225472
racdb1.__shared_pool_size=4127195136
racdb2.__streams_pool_size=33554432
racdb1.__streams_pool_size=33554432
*.audit_file_dest='/opt/app/oracle/admin/racdb/adump'
*.audit_trail='NONE'
*.cluster_database=true
*.compatible='11.2.0.0.0'
*.control_files='+DATA/racdb/control01.ctl','+DATA/racdb/control02.ctl'
*.cursor_sharing='FORCE'
*.db_block_size=16384
*.db_domain=''
*.db_name='racdb'
*.db_recovery_file_dest_size=42949672960
*.db_unique_name='PRIMARY'
*.db_writer_processes=8
*.diagnostic_dest='/opt/app/oracle'
*.dispatchers='(PROTOCOL=TCP) (SERVICE=racdbXDB)'
racdb2.instance_number=2
racdb1.instance_number=1
*.job_queue_processes=1000
*.log_archive_dest_1='LOCATION=+ARC/racdb/'
*.log_archive_dest_state_1='ENABLE'
*.log_archive_format='racdb_%t_%s_%r.arc'
*.log_archive_max_processes=8
*.open_cursors=300
*.optimizer_index_caching=50
*.optimizer_index_cost_adj=15
*.pga_aggregate_target=3363831808
*.processes=1500
*.remote_listener='SDB-RAC-scan:1521'
*.remote_login_passwordfile='exclusive'
*.sec_case_sensitive_logon=FALSE
*.sga_max_size=12884901888
*.sga_target=12884901888
racdb2.thread=2
racdb1.thread=1
racdb2.undo_tablespace='UNDOTBS2'
racdb1.undo_tablespace='UNDOTBS1'
*/

[root@DB-RAC1 adump]# cd /opt/app/oracle/admin/racdb/adump
[root@DB-RAC1 adump]# rm -rf *.aud
[root@DB-RAC1 adump]# cd /opt/app/11.2.0.3/grid/rdbms/audit
[root@DB-RAC1 audit]# rm -rf *.aud
[root@DB-RAC1 audit]# cd /opt/app/oracle/product/11.2.0.3/db_1/rdbms/audit/
[root@DB-RAC1 audit]# rm -rf *.aud
[root@DB-RAC1 audit]# cd /opt/app/oracle/diag/rdbms/primary/racdb1/trace
[root@DB-RAC1 trace]# rm -rf *

[oracle@DB-RAC1 ~]$ ssh oracle@DB-RAC2
[oracle@DB-RAC2 ~]$ cd /opt/app/oracle/admin/racdb/adump
[root@DB-RAC2 adump]# rm -rf *.aud
[root@DB-RAC2 adump]# cd /opt/app/11.2.0.3/grid/rdbms/audit
[root@DB-RAC2 audit]# rm -rf *.aud
[root@DB-RAC2 audit]# cd /opt/app/oracle/product/11.2.0.3/db_1/rdbms/audit/
[root@DB-RAC2 audit]# rm -rf *.aud
[root@DB-RAC2 audit]# cd /opt/app/oracle/diag/rdbms/primary/racdb1/trace
[root@DB-RAC2 trace]# rm -rf *

[oracle@DB-RAC1 ~]$ init 6
[oracle@DB-RAC1 ~]$ ssh oracle@DB-RAC2
[oracle@DB-RAC2 ~]$ init 6

[root@DB-RAC1 bin]# ./crsctl check cluster -all
/*
**************************************************************
DB-RAC1:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
DB-RAC2:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
*/

[root@DB-RAC2 bin]# ./crsctl check cluster -all
/*
**************************************************************
DB-RAC1:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
DB-RAC2:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
*/
[oracle@DB-RAC1 ~]$ srvctl status listener -l listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): DB-RAC1,DB-RAC2
*/

[oracle@DB-RAC2 ~]$ srvctl status listener -l listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): DB-RAC1,DB-RAC2
*/

[oracle@DB-RAC1 ~]$ cd /home/oracle/Old_DB_Config_File/
[oracle@DB-RAC1 Old_DB_Config_File]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Sun May 24 15:32:00 2020

Copyright (c) 1982, 2011, Oracle.  All rights reserved.

Connected to an idle instance.

SQL> !ls
sorcedb_ramn_fullbackup_log.log  initracdb1.ora  orapwracdb1  spfileracdb.ora
fullbkp_filename.txt            initracdb2.ora  orapwracdb2  spfileracdb.ora.backup

SQL> startup nomount pfile='/home/oracle/Old_DB_Config_File/spfileracdb.ora';
ORACLE instance started.

Total System Global Area 1.2827E+10 bytes
Fixed Size                  2240344 bytes
Variable Size            4563402920 bytes
Database Buffers         8254390272 bytes
Redo Buffers                7335936 bytes

SQL> create SPFILE='+DATA/racdb/spfileracdb.ora' from pfile='/home/oracle/Old_DB_Config_File/spfileracdb.ora';

File created.

SQL> shut immediate;
ORA-01507: database not mounted


ORACLE instance shut down.
SQL> startup nomount;
ORACLE instance started.

Total System Global Area 1.2827E+10 bytes
Fixed Size                  2240344 bytes
Variable Size            4563402920 bytes
Database Buffers         8254390272 bytes
Redo Buffers                7335936 bytes
SQL> sho parameter pfile

NAME   TYPE   VALUE
------ ------ -------------------------------
spfile string +DATA/racdb/spfileracdb.ora

SQL> exit
*/

[oracle@DB-RAC1 ~]$ ps -ef | grep pmon
/*
grid       4159      1  0 May23 ?        00:00:28 asm_pmon_+ASM1
oracle    44019      1  0 15:36 ?        00:00:00 ora_pmon_racdb1
oracle    44241  43007  0 15:42 pts/0    00:00:00 grep pmon
*/

[oracle@DB-RAC1 ~]$ rman target /
/*
Recovery Manager: Release 11.2.0.3.0 - Production on Thu Apr 2 17:10:20 2020

Copyright (c) 1982, 2011, Oracle and/or its affiliates.  All rights reserved.

connected to target database: racdb (not mounted)

RMAN> restore controlfile from '+FRA/racdb/racdb_cf_racdb_fcv0v5g3_14828_20200524';
Starting restore at 16-JUN-20
using target database control file instead of recovery catalog
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=853 instance=racdb1 device type=DISK

channel ORA_DISK_1: restoring control file
channel ORA_DISK_1: restore complete, elapsed time: 00:00:02
output file name=+DATA/racdb/control01.ctl
output file name=+DATA/racdb/control02.ctl
Finished restore at 16-JUN-20

RMAN> sql 'alter database mount';

sql statement: alter database mount
released channel: ORA_DISK_1

RMAN> show all;

RMAN configuration parameters for database with db_unique_name PRIMARY are:
CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 30 DAYS;
CONFIGURE BACKUP OPTIMIZATION OFF; # default
CONFIGURE DEFAULT DEVICE TYPE TO DISK; # default
CONFIGURE CONTROLFILE AUTOBACKUP ON;
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '+FRA/racdb/control_arc_%F_%T';
CONFIGURE DEVICE TYPE DISK PARALLELISM 1 BACKUP TYPE TO BACKUPSET; # default
CONFIGURE DATAFILE BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE ARCHIVELOG BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE MAXSETSIZE TO UNLIMITED; # default
CONFIGURE ENCRYPTION FOR DATABASE OFF; # default
CONFIGURE ENCRYPTION ALGORITHM 'AES128'; # default
CONFIGURE COMPRESSION ALGORITHM 'BASIC' AS OF RELEASE 'DEFAULT' OPTIMIZE FOR LOAD TRUE;
CONFIGURE ARCHIVELOG DELETION POLICY TO APPLIED ON ALL STANDBY;
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '+FRA/racdb/snapcontrolfile/snapcf_racdb1.f';
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '+FRA/racdb/snapcontrolfile/snapcf_racdb1.f';

RMAN> CONFIGURE DEVICE TYPE DISK PARALLELISM 8 BACKUP TYPE TO BACKUPSET;

new RMAN configuration parameters:
CONFIGURE DEVICE TYPE DISK PARALLELISM 8 BACKUP TYPE TO BACKUPSET;
new RMAN configuration parameters are successfully stored

RMAN> show all;

RMAN configuration parameters for database with db_unique_name PRIMARY are:
CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 30 DAYS;
CONFIGURE BACKUP OPTIMIZATION OFF; # default
CONFIGURE DEFAULT DEVICE TYPE TO DISK; # default
CONFIGURE CONTROLFILE AUTOBACKUP ON;
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '+FRA/racdb/control_arc_%F_%T';
CONFIGURE DEVICE TYPE DISK PARALLELISM 8 BACKUP TYPE TO BACKUPSET;
CONFIGURE DATAFILE BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE ARCHIVELOG BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE MAXSETSIZE TO UNLIMITED; # default
CONFIGURE ENCRYPTION FOR DATABASE OFF; # default
CONFIGURE ENCRYPTION ALGORITHM 'AES128'; # default
CONFIGURE COMPRESSION ALGORITHM 'BASIC' AS OF RELEASE 'DEFAULT' OPTIMIZE FOR LOAD TRUE;
CONFIGURE ARCHIVELOG DELETION POLICY TO APPLIED ON ALL STANDBY;
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '+FRA/racdb/snapcontrolfile/snapcf_racdb1.f';
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '+FRA/racdb/snapcontrolfile/snapcf_racdb1.f';


RMAN> catalog start with '+FRA/racdb/';
RMAN> restore database;

channel ORA_DISK_3: restored backup piece 14
channel ORA_DISK_3: restore complete, elapsed time: 06:25:58
Finished restore at 16-JUN-20


RMAN> list backup of archivelog all;

BS Key  Size       Device Type Elapsed Time Completion Time
------- ---------- ----------- ------------ ---------------
13482   43.71M     DISK        00:00:00     24-MAY-20      
        BP Key: 46085   Status: AVAILABLE  Compressed: YES  Tag: TAG20200524T100017
        Piece Name: +FRA/racdb/arc_racdb_frv1069h_1_1_20200524

  List of Archived Logs in backup set 13482
  Thrd Seq     Low SCN    Low Time  Next SCN   Next Time
  ---- ------- ---------- --------- ---------- ---------
  1    53489   32521098570 24-MAY-20 32521626221 24-MAY-20
  2    50737   32520174398 24-MAY-20 32521098574 24-MAY-20
  2    50738   32521098574 24-MAY-20 32521626264 24-MAY-20

RMAN> recover database;

archived log file name=+ARC/racdb/racdb_2_50737_846526302.arc thread=2 sequence=50737
archived log file name=+ARC/racdb/racdb_1_53488_846526302.arc thread=1 sequence=53488
archived log file name=+ARC/racdb/racdb_1_53489_846526302.arc thread=1 sequence=53489
archived log file name=+ARC/racdb/racdb_2_50738_846526302.arc thread=2 sequence=50738
unable to find archived log
archived log thread=1 sequence=53490
RMAN-00571: ===========================================================
RMAN-00569: =============== ERROR MESSAGE STACK FOLLOWS ===============
RMAN-00571: ===========================================================
RMAN-03002: failure of recover command at 06/16/2020 20:33:37
RMAN-06054: media recovery requesting unknown archived log for thread 1 with sequence 53490 and starting SCN of 32521626221

RMAN> exit

Recovery Manager complete.
*/

SELECT sid, serial#, context, sofar, totalwork,
 round(sofar/totalwork*100,2) "% Complete"
 FROM v$session_longops
 WHERE opname LIKE 'RMAN%'
 AND opname NOT LIKE '%aggregate%'
 AND totalwork != 0
 AND sofar != totalwork;

[oracle@DB-RAC1 Old_DB_Config_File]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Mon May 25 11:52:55 2020

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> alter database open;
alter database open
*
ERROR at line 1:
ORA-01589: must use RESETLOGS or NORESETLOGS option for database open


SQL> ALTER DATABASE OPEN RESETLOGS;

Database altered.

SQL> select status, instance_name from gv$instance;

STATUS       INSTANCE_NAME
------------ ----------------
OPEN         racdb1


SQL> select name, open_mode, dbid from v$database;

NAME      OPEN_MODE                  DBID
--------- -------------------- ----------
racdb   READ WRITE            448326366

*/

[oracle@DB-RAC1 ~]$ which srvctl
/opt/app/oracle/product/11.2.0.3.0/db_1/bin/srvctl
[oracle@DB-RAC1 ~]$ srvctl add database -d racdb -o /opt/app/oracle/product/11.2.0.3/db_1
[oracle@DB-RAC1 ~]$ srvctl config database -d racdb -a
/*
Database unique name: racdb
Database name: 
Oracle home: /opt/app/oracle/product/11.2.0.3/db_1
Oracle user: oracle
Spfile: 
Domain: 
Start options: open
Stop options: immediate
Database role: PRIMARY
Management policy: AUTOMATIC
Server pools: racdb
Database instances: 
Disk Groups: 
Mount point paths: 
Services: 
Type: RAC
Database is enabled
Database is administrator managed
*/

[oracle@DB-RAC1 ~]$ srvctl add instance -d racdb -i racdb1 -n DB-RAC1
[oracle@DB-RAC1 ~]$ srvctl add instance -d racdb -i racdb2 -n DB-RAC2
[oracle@DB-RAC1 ~]$ srvctl config database -d racdb -a
/*
Database unique name: racdb
Database name: 
Oracle home: /opt/app/oracle/product/11.2.0.3/db_1
Oracle user: oracle
Spfile: 
Domain: 
Start options: open
Stop options: immediate
Database role: PRIMARY
Management policy: AUTOMATIC
Server pools: racdb
Database instances: racdb1,racdb2
Disk Groups: 
Mount point paths: 
Services: 
Type: RAC
Database is enabled
Database is administrator managed
*/

[oracle@DB-RAC1 ~]$ srvctl status database -d racdb

/*
Instance racdb1 is not running on node rac1
Instance racdb2 is not running on node rac2
*/

[oracle@DB-RAC1 ~]$ srvctl start database -d  racdb
[oracle@DB-RAC1 ~]$ srvctl status database -d  racdb
/*
Instance racdb1 is running on node DB-RAC1
Instance racdb2 is running on node DB-RAC2
*/

[oracle@DB-RAC1 ~]$ srvctl config database -d racdb -a
/*
Database unique name: racdb
Database name: 
Oracle home: /opt/app/oracle/product/11.2.0.3/db_1
Oracle user: oracle
Spfile: 
Domain: 
Start options: open
Stop options: immediate
Database role: PRIMARY
Management policy: AUTOMATIC
Server pools: racdb
Database instances: racdb1,racdb2
Disk Groups: 
Mount point paths: 
Services: 
Type: RAC
Database is enabled
Database is administrator managed
*/

[oracle@DB-RAC1 ~]$ srvctl stop database -d racdb
[oracle@DB-RAC1 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is not running on node DB-RAC1
Instance racdb2 is not running on node DB-RAC2
*/

[oracle@DB-RAC1 ~]$ srvctl start database -d racdb
[oracle@DB-RAC1 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is running on node DB-RAC1
Instance racdb2 is running on node DB-RAC2
*/

[oracle@DB-RAC1 ~]$ srvctl config database -d racdb -a
/*
Database unique name: racdb
Database name: 
Oracle home: /opt/app/oracle/product/11.2.0.3/db_1
Oracle user: oracle
Spfile: 
Domain: 
Start options: open
Stop options: immediate
Database role: PRIMARY
Management policy: AUTOMATIC
Server pools: racdb
Database instances: racdb1,racdb2
Disk Groups: 
Mount point paths: 
Services: 
Type: RAC
Database is enabled
Database is administrator managed
*/

[oracle@DB-RAC1 ~]$ srvctl modify database -d racdb -a "DATA,DATA2,ARC"
[oracle@DB-RAC1 ~]$ srvctl config database -d racdb -a
/*
Database unique name: racdb
Database name: 
Oracle home: /opt/app/oracle/product/11.2.0.3/db_1
Oracle user: oracle
Spfile: 
Domain: 
Start options: open
Stop options: immediate
Database role: PRIMARY
Management policy: AUTOMATIC
Server pools: racdb
Database instances: racdb1,racdb2
Disk Groups: DATA,DATA2,ARC
Mount point paths: 
Services: 
Type: RAC
Database is enabled
Database is administrator managed
*/

[oracle@DB-RAC1 ~]$ srvctl status listener -l listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): DB-RAC1,DB-RAC2
*/

[oracle@DB-RAC1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 25-MAY-2020 13:36:26

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                25-MAY-2020 13:29:15
Uptime                    0 days 0 hr. 7 min. 11 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/DB-RAC1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.71)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.69)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "PRIMARY" has 1 instance(s).
  Instance "racdb1", status READY, has 1 handler(s) for this service...
Service "racdbXDB" has 1 instance(s).
  Instance "racdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

[oracle@DB-RAC2 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is running on node DB-RAC1
Instance racdb2 is running on node DB-RAC2
*/
[oracle@DB-RAC2 ~]$ srvctl status listener -l listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): DB-RAC1,DB-RAC2
*/
[oracle@DB-RAC2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 25-MAY-2020 13:32:51

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                25-MAY-2020 13:29:19
Uptime                    0 days 0 hr. 3 min. 31 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/11.2.0.3/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/DB-RAC2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.72)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.70)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "PRIMARY" has 1 instance(s).
  Instance "racdb2", status READY, has 1 handler(s) for this service...
Service "racdbXDB" has 1 instance(s).
  Instance "racdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

[oracle@DB-RAC1/DB-RAC2 ~]$ vi /opt/app/oracle/product/11.2.0.3/db_1/network/admin/tnsnames.ora
/*
PRIMARY =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = DB-RAC-scan.mydomain.com)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = primary)
    )
  )

racdb =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = DB-RAC-scan.mydomain.com)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = racdb)
    )
  )
*/

[oracle@DB-RAC1/DB-RAC2 ~]$ tnsping primary
/*
TNS Ping Utility for Linux: Version 11.2.0.3.0 - Production on 22-JUN-2020 10:41:04

Copyright (c) 1997, 2011, Oracle.  All rights reserved.

Used parameter files:

Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = DB-RAC-scan.mydomain.com)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = primary)))
OK (0 msec)
*/

[oracle@DB-RAC1/DB-RAC2 ~]$ tnsping racdb
/*
TNS Ping Utility for Linux: Version 11.2.0.3.0 - Production on 22-JUN-2020 10:41:56

Copyright (c) 1997, 2011, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = DB-RAC-scan.mydomain.com)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = racdb)))
OK (0 msec)
*/
