Snapshot Standby:
Oracle snapshot standby allows the standby database to be opened in read-write mode. When switched back into standby mode, all changes
made whilst in read-write mode are lost

A.) Steps During Oracle Standby Snapshot Mode Drill:

-- Step 1 
-- Status of Primary Database -> DC & Secondary Database -> DR
-- Step 1.1
-- Verification of Primary Database -> DC
SQL> SELECT status,instance_name,database_role,open_mode FROM v$database,v$instance;
/*
STATUS INSTANCE_NAME DATABASE_ROLE OPEN_MODE
------ ------------- ------------- ----------
OPEN   racdb1        PRIMARY       READ WRITE
*/

-- Step 1.2
-- Verification of Secondary Database -> DR
SQL> SELECT status,instance_name,database_role,open_mode FROM v$database,v$instance;
/*
STATUS  INSTANCE_NAME DATABASE_ROLE    OPEN_MODE
------- ------------- ---------------- ---------
MOUNTED racdb1        PHYSICAL STANDBY MOUNTED
*/

-- Step 2
-- Confirm Primary Database -> DC and Secondary Database -> DR Servers should be synchronized.
-- Step 2.1
-- Primary Database -> DC Server (Generate Archive Count)
SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;
/*
MAX(SEQUENCE#) THREAD#
-------------- -------
207            1
*/

-- Step 2.2
-- Secondary Database -> DR Servers (Recived Archive Count)
SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;
/*
MAX(SEQUENCE#) THREAD#
-------------- -------
207            1
*/

-- Step 2.3
-- Secondary Database -> DR Servers (Applied Archive Count)
SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log WHERE applied ='YES' GROUP BY thread#;
/*
MAX(SEQUENCE#) THREAD#
-------------- -------
206            1
*/

-- Step 3
-- Check the Database Links and Create a User with table to hold records
-- Step 3.1
-- Primary Database -> DC Server
SQL> SELECT dbms_metadata.get_ddl('DB_LINK',db.db_link,db.owner) columan_name FROM dba_db_links db;
/*
COLUMAN_NAME
-----------------------------------------------------------------
CREATE PUBLIC DATABASE LINK DBLINK_NAME
 CONNECT TO DBLINK_USER" IDENTIFIED BY DBLINK_PASSWORD
 USING '(DESCRIPTION =
  (ADDRESS_LIST =
    (ADDRESS = (PROTOCOL = TCP)(HOST =192.16.5.111)(PORT = 1521))
  )
  (CONNECT_DATA =
    (SERVICE_NAME = racdb_dc)
  )
)'
*/

-- Step 3.2
-- Create Application user
SQL> CREATE USER snapshotapplication IDENTIFIED BY oracle;
/*
User created.
*/
SQL> GRANT CONNECT, RESOURCE TO snapshotapplication;
/*
Grant succeeded.
*/

-- Step 3.3
-- Connect to Application user
SQL> CONN snapshotapplication/oracle
/*
Connected.
*/

SQL> show user
/*
USER is "SNAPSHOTAPPLICATION"
*/

-- Step 3.4
-- Create Table With Data
SQL> CREATE TABLE snapshotapplication.test_table
AS
SELECT
     LEVEL c1
FROM dual
CONNECT BY LEVEL <=10;
/*
Table created.
*/

-- Step 3.5
-- Verify table the table Data
SQL> SELECT c1 FROM snapshotapplication.test_table;
/*
C1
--
1
2
3
4
5
6
7
8
9
10
*/

SQL> COMMIT;
/*
Commit complete.
*/

-- Step 3.6
-- Create Auto Increment Oracle Sequence
SQL> CREATE SEQUENCE snapshotapplication.test_sequence
MINVALUE 1
MAXVALUE 100000
INCREMENT BY 1
NOCYCLE
NOORDER
CACHE 20;

-- Step 3.7
-- Increment the Oracle Sequence to 1
SELECT snapshotapplication.test_sequence.NEXTVAL FROM dual;
/*
NEXTVAL
-------
      1
*/

-- Step 3.8
-- Increment the Oracle Sequence to 2
SELECT snapshotapplication.test_sequence.NEXTVAL FROM dual;
/*
NEXTVAL
-------
      2
*/

-- Step 3.9
-- Verify the current Oracle Sequence number as 2
SELECT snapshotapplication.test_sequence.CURRVAL FROM dual;
/*
CURRVAL
-------
      2
*/

SQL> COMMIT;
/*
Commit complete.
*/

-- Step 4
-- Secondary Database -> DR Servers Site
-- Step 4.1
-- Make sure the db_recovery_file_dest_size and location is set properly
-- Note The oracle parameter "db_recovery_file_dest_size" should be greater than 5GB.
SQL> show parameters db_recovery_file_dest 
/*
NAME                       TYPE        VALUE
-------------------------- ----------- ------
db_recovery_file_dest      string      +FRA
db_recovery_file_dest_size big integer 5120M
*/

-- Step 4.2
-- Verify the restore point
SQL> SELECT flashback_on FROM v$database;
/*
FLASHBACK_ON
------------
NO
*/

-- Step 4.3
-- Cancel the managed standby recovery process
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
/*
Database altered.
*/

-- Step 4.4
-- Shutdown the database
SQL> SHUTDOWN IMMEDIATE;
/*
ORA-01109: database not open


Database dismounted.
ORACLE instance shut down.
*/

-- Step 4.5
-- Bring the database in mount mode
SQL> STARTUP MOUNT;
/*
ORACLE instance started.

Total System Global Area  626327552 bytes
Fixed Size            2230952 bytes
Variable Size          247465304 bytes
Database Buffers      369098752 bytes
Redo Buffers            7532544 bytes
Database mounted.
*/

-- Step 4.6
--  Covert physical standby database to snapshot standby database.
SQL> ALTER DATABASE CONVERT TO SNAPSHOT STANDBY;
/*
Database altered.
*/

-- Step 4.7
-- The physical standby database in snapshot standby database status shoud be in mount mode
SQL> select status,instance_name,database_role,open_mode from v$database,v$instance;
/*
STATUS  INSTANCE_NAME DATABASE_ROLE    OPEN_MODE
------- ------------- ---------------- ---------
MOUNTED racdb1        SNAPSHOT STANDBY MOUNTED
*/

-- Step 4.8
-- Bring the database in open mode
SQL> ALTER DATABASE OPEN;
/*
Database altered.
*/

-- Step 4.9
-- The physical standby database in snapshot standby database status shoud be in open mode (Read Write)
SQL> select status,instance_name,database_role,open_mode from v$database,v$instance;
/*
STATUS INSTANCE_NAME DATABASE_ROLE    OPEN_MODE
------ ------------- ---------------- ----------
OPEN   racdb1        SNAPSHOT STANDBY READ WRITE
*/

-- Step 4.10
-- Verify the restore point
SQL> SELECT flashback_on FROM v$database;
/*
FLASHBACK_ON
------------------
RESTORE POINT ONLY
*/


-- Step 4.11
-- Check the Database Links
SQL> SELECT dbms_metadata.get_ddl('DB_LINK',db.db_link,db.owner) columan_name FROM dba_db_links db;
/*
COLUMAN_NAME
-----------------------------------------------------------------
CREATE PUBLIC DATABASE LINK DBLINK_NAME
 CONNECT TO DBLINK_USER" IDENTIFIED BY DBLINK_PASSWORD
 USING '(DESCRIPTION =
  (ADDRESS_LIST =
    (ADDRESS = (PROTOCOL = TCP)(HOST =192.16.5.111)(PORT = 1521))
  )
  (CONNECT_DATA =
    (SERVICE_NAME = racdb_dc)
  )
)'
*/

-- Step 4.12
-- Re-Create Database Links
SQL> DROP PUBLIC DATABASE LINK DBLINK_NAME;
SQL> CREATE PUBLIC DATABASE LINK DBLINK_NAME
      CONNECT TO DBLINK_USER IDENTIFIED BY DBLINK_PASSWORD
      USING '(DESCRIPTION =
       (ADDRESS_LIST =
         (ADDRESS = (PROTOCOL = TCP)(HOST =192.16.25.111)(PORT = 1521))
       )
       (CONNECT_DATA =
         (SERVICE_NAME = racdb_dr)
       )
     )';

-- Step 4.13
-- Verify The Database Links
SQL> SELECT dbms_metadata.get_ddl('DB_LINK',db.db_link,db.owner) columan_name FROM dba_db_links db;
/*
COLUMAN_NAME
-----------------------------------------------------------------
CREATE PUBLIC DATABASE LINK DBLINK_NAME
 CONNECT TO DBLINK_USER" IDENTIFIED BY DBLINK_PASSWORD
 USING '(DESCRIPTION =
  (ADDRESS_LIST =
    (ADDRESS = (PROTOCOL = TCP)(HOST =192.16.25.111)(PORT = 1521))
  )
  (CONNECT_DATA =
    (SERVICE_NAME = racdb_dr)
  )
)'
*/

-- Step 5
-- DR Application can be tested on snapshot standby database in DR site with making necessary changes through DR Application interface.
-- Changes made during this step will not be applied to DC site. And when switched back into standby mode, all changes
-- made whilst in read-write mode will be lost.

-- Step 5.1
-- Connect to Application user
SQL> CONN snapshotapplication/oracle
/*
Connected.
*/

SQL> show user
/*
USER is "SNAPSHOTAPPLICATION"
*/

-- Step 5.2
-- Verfiy the Data from DR Site
SQL> SELECT c1 FROM snapshotapplication.test_table;
/*
C1
--
1
2
3
4
5
6
7
8
9
10
*/

-- Step 5.3
-- Change the Data from DR Site
SQL> UPDATE snapshotapplication.test_table
SET c1=55
WHERE c1=5;
/*
1 row updated.
*/

SQL> COMMIT;
/*
Commit complete.
*/

-- Step 5.4
-- Verify the Table Data from DR Site
SQL> SELECT c1 FROM snapshotapplication.test_table;
/*
C1
--
1
2
3
4
55
6
7
8
9
10
*/

-- Step 5.5
-- Increment the Oracle Sequence from 2 to 3
SELECT snapshotapplication.test_sequence.NEXTVAL FROM dual;
/*
NEXTVAL
-------
      3
*/

-- Step 5.6
-- Increment the Oracle Sequence to 4
SELECT snapshotapplication.test_sequence.NEXTVAL FROM dual;
/*
NEXTVAL
-------
      4
*/

-- Step 5.7
-- Verify the current Oracle Sequence number as 4 in DR Site
SELECT snapshotapplication.test_sequence.CURRVAL FROM dual;
/*
CURRVAL
-------
      4
*/

SQL> COMMIT;
/*
Commit complete.
*/

-- Step 5.8
-- Secondary Database -> DR Servers (Connect as SYSDBA)
SQL> conn sys/sys as sysdba
/*
Connected.
*/

SQL> show user
/*
USER is "SYS"
*/

-- Step 5.9
-- Secondary Database -> DR Servers (Genrate Archive Count)
-- This ste
SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;
/*
MAX(SEQUENCE#) THREAD#
-------------- -------
209            1
*/

-- Step 5.10
-- Cross Verify the Data in DC Site
-- Step 5.11
-- Connect to Application user
SQL> CONN snapshotapplication/oracle
/*
Connected.
*/

SQL> show user
/*
USER is "SNAPSHOTAPPLICATION"
*/

-- Step 5.12
-- Verfiy the Data from DR Site
SQL> SELECT c1 FROM snapshotapplication.test;
/*
C1
--
1
2
3
4
5
6
7
8
9
10
*/

-- Step 5.13
-- Verify the current Oracle Sequence number as 2 for DC site
SELECT snapshotapplication.test_sequence.CURRVAL FROM dual;
/*
CURRVAL
-------
      2
*/

B.) Step by Step to back from SNAPSHOT mode to STANDBY mode after completing the DR drill 

-- Step 6
-- Covert back to physical standby database from SNAPSHOT -DR

-- Step 6.1
-- Shutdown the DR database
SQL> shutdown immediate;
/*
Database closed.
Database dismounted.
ORACLE instance shut down.
*/

-- Step 6.2
-- Bring the database in mount mode
SQL> startup mount;
/*
ORACLE instance started.

Total System Global Area  626327552 bytes
Fixed Size                2230952 bytes
Variable Size             247465304 bytes
Database Buffers          369098752 bytes
Redo Buffers              7532544 bytes
Database mounted.
*/

-- Step 6.3
--  Covert back physical standby database from snapshot standby database.
SQL> ALTER DATABASE CONVERT TO PHYSICAL STANDBY;
/*
Database altered.
*/

-- Step 6.4
-- Shutdown the database
SQL> shutdown immediate;
/*
ORA-01507: database not mounted

ORACLE instance shut down.
*/

-- Step 6.5
-- Bring the database in nomount mode
SQL> startup nomount;
/*
ORACLE instance started.

Total System Global Area  626327552 bytes
Fixed Size            2230952 bytes
Variable Size          247465304 bytes
Database Buffers      369098752 bytes
Redo Buffers            7532544 bytes
*/

-- Step 6.7
-- Bring the database in mount mode
SQL> ALTER DATABASE MOUNT STANDBY DATABASE;
/*
Database altered.
*/

-- Step 6.8
-- Start the Recovery Process
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;
/*
Database altered.
*/

-- Step 6.9
-- Start the Recovery Process
SQL> SELECT flashback_on FROM v$database;
/*
FLASHBACK_ON
------------
NO
*/

-- Step 7
-- Status of Primary Database -> DC & Secondary Database -> DR
-- Step 7.1
-- Verification of Primary Database -> DC
SQL> SELECT status,instance_name,database_role,open_mode FROM v$database,v$instance;
/*
STATUS INSTANCE_NAME DATABASE_ROLE OPEN_MODE
------ ------------- ------------- ----------
OPEN   racdb1        PRIMARY       READ WRITE
*/

-- Step 7.2
-- Verification of Secondary Database -> DR
SQL> SELECT status,instance_name,database_role,open_mode FROM v$database,v$instance;
/*
STATUS  INSTANCE_NAME DATABASE_ROLE    OPEN_MODE
------- ------------- ---------------- ---------
MOUNTED racdb1        PHYSICAL STANDBY MOUNTED
*/

-- Step 8
-- Confirm Primary Database -> DC and Secondary Database -> DR Servers should be synchronized.
-- Step 8.1
-- Primary Database -> DC Server (Generate Archive Count)
SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;
/*
MAX(SEQUENCE#) THREAD#
-------------- -------
211            1
*/

-- Step 8.2
-- 
-- Secondary Database -> DR Servers (Recived Archive Count)
SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log GROUP BY thread#;
/*
MAX(SEQUENCE#) THREAD#
-------------- -------
211            1
*/

-- Step 8.3
-- Secondary Database -> DR Servers (Applied Archive Count)
SQL> SELECT MAX(sequence#), thread# FROM gv$archived_log WHERE applied ='YES' GROUP BY thread#;
/*
MAX(SEQUENCE#) THREAD#
-------------- -------
210            1
*/

-- Step 9
-- Verify the Data in DC Site
-- Step 9.1
-- Connect to Application user
SQL> CONN snapshotapplication/oracle
/*
Connected.
*/

SQL> show user
/*
USER is "SNAPSHOTAPPLICATION"
*/

-- Step 9.2
-- Verfiy the Data from DR Site
SQL> SELECT c1 FROM snapshotapplication.test;
/*
C1
--
1
2
3
4
5
6
7
8
9
10
*/

-- Step 9.3
-- Verify the current Oracle Sequence number as 2 for DC site
SELECT snapshotapplication.test_sequence.CURRVAL FROM dual;
/*
CURRVAL
-------
      2
*/

-- Step 9.3
-- Increment the Oracle Sequence from 2 to 3
SELECT snapshotapplication.test_sequence.NEXTVAL FROM dual;
/*
NEXTVAL
-------
      3
*/

-- Step 9.4
-- Verify the current Oracle Sequence number as 3
SELECT snapshotapplication.test_sequence.CURRVAL FROM dual;
/*
CURRVAL
-------
      3
*/

SQL> COMMIT;
/*
Commit complete.
*/