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

SQL> SELECT status, filename FROM v$block_change_tracking;

STATUS   FILENAME
-------- -----------------------------------
DISABLED

SQL> ALTER DATABASE ENABLE BLOCK CHANGE TRACKING using FILE '+DATA/racdb/bct/rman_change_track.f';

Database altered.

SQL> SELECT status, filename FROM v$block_change_tracking;

STATUS  FILENAME
------- -----------------------------------
ENABLED +DATA/racdb/bct/rman_change_track.f

SQL> exit;
*/

/*
-- To Disable Block Change Tracking:
ALTER DATABASE DISABLE BLOCK CHANGE TRACKING;
*/