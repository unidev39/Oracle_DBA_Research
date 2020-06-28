[oracle@racdb1 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is not running on node rac1
Instance racdb2 is not running on node rac2
*/

-- To Create Restore point 
SHOW PARAMETER DB_FLASHBACK_RETENTION;
SHOW PARAMETER DB_RECOVERY_FILE_DEST;
SHOW PARAMETER DB_RECOVERY_FILE_DEST_SIZE;

ALTER SYSTEM SET DB_RECOVERY_FILE_DEST_SIZE = 300G SCOPE=BOTH SID='*';
ALTER SYSTEM SET DB_RECOVERY_FILE_DEST='+fra' SCOPE=BOTH SID='*';
ALTER SYSTEM SET DB_FLASHBACK_RETENTION_TARGET=4320;

-- Flash Back ON in Open or Mount Mode
ALTER DATABASE FLASHBACK ON;

-- Guaranteed
CREATE RESTORE POINT befor_upgrade GUARANTEE FLASHBACK DATABASE;

-- Veirfication
LIST RESTORE POINT ALL;
/*
RMAN> LIST RESTORE POINT ALL;

using target database control file instead of recovery catalog
SCN              RSP Time  Type       Time      Name
---------------- --------- ---------- --------- ----
33894741502                GUARANTEED 25-JUN-20 befor_upgrade
*/

SELECT name,db_unique_name,database_role,log_mode,dbid,current_scn,flashback_on FROM gv$database;
/*
NAME    DB_UNIQUE_NAME DATABASE_ROLE LOG_MODE        DBID CURRENT_SCN FLASHBACK_ON
------- -------------- ------------- ---------- --------- ----------- ------------
racdb PRIMARY        PRIMARY       ARCHIVELOG 448326366 33894743069 YES         
racdb PRIMARY        PRIMARY       ARCHIVELOG 448326366 33894743069 YES         
*/

SELECT name, scn, time, database_incarnation#,guarantee_flashback_database,storage_size FROM gv$restore_point;
/*
NAME                   SCN TIME                  DATABASE_INCARNATION# GUARANTEE_FLASHBACK_DATABASE STORAGE_SIZE
-------------- ----------- --------------------- --------------------- ---------------------------- ------------
befor_upgrade  33894741502 25.06.20 19:17:01.000                     1 YES                            3145728000
befor_upgrade  33894741502 25.06.20 19:17:01.000                     1 YES                            3145728000
*/

archive log list
/*
SQL> archive log list
Database log mode              Archive Mode
Automatic archival             Enabled
Archive destination            +ARC/racdb/
Oldest online log sequence     54759
Next log sequence to archive   54761
Current log sequence           54761
*/

SELECT MAX(sequence#),thread# FROM gv$archived_log GROUP BY thread#;
/*
MAX(SEQUENCE#) THREAD#
-------------- -------
         54760       1
         52074       2
*/

[oracle@racdb1 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is not running on node rac1
Instance racdb2 is not running on node rac2
*/

[oracle@racdb1 ~]$ srvctl start database -d racdb -o mount
[oracle@racdb1 ~]$ sqlplus sys/sys as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Sun Apr 5 09:55:11 2020
Copyright (c) 1982, 2011, Oracle.  All rights reserved.
Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options
SQL> select status, instance_name from gv$instance;
STATUS       INSTANCE_NAME
------------ ----------------
OPEN         racdb1
OPEN         racdb2

SQL> FLASHBACK DATABASE TO RESTORE POINT 'before_upgrade';

SQL> DROP RESTORE POINT befor_upgrade;
SQL> ALTER DATABASE FLASHBACK OFF;
SQL> ALTER SYSTEM SET DB_RECOVERY_FILE_DEST='' SCOPE=BOTH SID="*";
SQL> exit
*/

[oracle@racdb1 ~]$ srvctl stop database -d racdb
[oracle@racdb1 ~]$ srvctl start database -d racdb
[oracle@racdb1 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is not running on node rac1
Instance racdb2 is not running on node rac2
*/