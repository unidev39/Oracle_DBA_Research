/*sga_max_size should not be Gretter than sga_target*/

-------------------------------------------------------------------------------------------------
----------------------------------------2 Node DC------------------------------------------------
-------------------------------------------------------------------------------------------------
--Step 1
create pfile='/home/oracle/spfileracdb.ora' from spfile;

--Step 2
alter system set sga_max_size=14G scope=spfile sid='*';
alter system set sga_target=12G scope=spfile sid='*';

--Step 3
srvctl stop database -d racdb

--Step 4
srvctl start database -d racdb 

-- Revert back Steps
--Step 1
SQL> create SPFILE='+DATA/racdb/spfileracdb.ora' from pfile='/home/oracle/spfileracdb.ora';

--Step 2
srvctl start database -d racdb

-------------------------------------------------------------------------------------------------
----------------------------------------2 Node DR------------------------------------------------
-------------------------------------------------------------------------------------------------

--Step 1
-- To Disable MRP on STANDBY
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
SQL> create pfile='/home/oracle/spfileracdb.ora' from spfile;

--Step 2
alter system set sga_max_size=14G scope=spfile sid='*';
alter system set sga_target=12G scope=spfile sid='*';

--Step 3
srvctl stop database -d racdb

--Step 4
srvctl start database -d racdb -o mount
-- To Enable MRP on STANDBY
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;
SQL> SELECT process,thread#,sequence#,status FROM gv$managed_standby;
SQL> SELECT * FROM gv$archive_gap;
SQL> SELECT DISTINCT error FROM v$archive_dest_status;

-- Revert back Steps
--Step 1
-- To Disable MRP on STANDBY
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
SQL> create SPFILE='+DATA/racdb/spfileracdb.ora' from pfile='/home/oracle/spfileracdb.ora';

--Step 2
srvctl start database -d racdb -o mount

--Step 3
-- To Enable MRP on STANDBY
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;
SQL> SELECT process,thread#,sequence#,status FROM gv$managed_standby;
SQL> SELECT * FROM gv$archive_gap;
SQL> SELECT DISTINCT error FROM v$archive_dest_status;
