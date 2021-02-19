-- To apply the Oracle Patch to import the partition table over network database link

Step 1:
[oracle@rac1/rac2 ~]$ srvctl stop database -d racdb
[oracle@rac1/rac2 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is not running on node rac1
Instance racdb2 is not running on node rac2
*/

Step 3:
[oracle@rac1/rac2 ~]$ /opt/app/oracle/product/19c/db_1/OPatch/opatch lspatches
/*
30805684;OJVM RELEASE UPDATE: 19.7.0.0.200414 (30805684)
30894985;OCW RELEASE UPDATE 19.7.0.0.0 (30894985)
30869156;Database Release Update : 19.7.0.0.200414 (30869156)

OPatch succeeded.
*/

Step 4:
[oracle@rac1/rac2 ~]$ /opt/app/oracle/product/19c/db_1/OPatch/opatch version
/*
OPatch Version: 12.2.0.1.21

OPatch succeeded.
*/

Step 5:
[oracle@rac1 ~]$ cd /tmp/
[oracle@rac1 tmp]$ unzip p30321076_197000DBRU_Linux-x86-64.zip
[oracle@rac1 tmp]$ chmod -R 775 30321076
[oracle@rac1 tmp]$ ls -ltr | grep 30321076
/*
drwxrwxr-x  4 oracle oinstall  4096 Apr 17  2020 30321076
-rw-r--r--  1 oracle oinstall 50222 Dec 16 20:17 p30321076_197000DBRU_Linux-x86-64.zip
*/

Step 6:
-- To applying the Oracle PSU on Node 1
[oracle@rac1 tmp]$ export ORACLE_HOME=/opt/app/oracle/product/19c/db_1
[oracle@rac1 tmp]$ export PATH=${ORACLE_HOME}/bin:$PATH
[oracle@rac1 tmp]$ export PATH=${PATH}:${ORACLE_HOME}/OPatch
[oracle@rac1 tmp]$ which opatch
/*
/opt/app/oracle/product/19c/db_1/OPatch/opatch
*/

Step 7:
[oracle@rac2 tmp]$ cd 30321076/
[oracle@rac1 30321076]$ /opt/app/oracle/product/19c/db_1/OPatch/opatch apply
/*
Oracle Interim Patch Installer version 12.2.0.1.21
Copyright (c) 2020, Oracle Corporation.  All rights reserved.


Oracle Home       : /opt/app/oracle/product/19c/db_1
Central Inventory : /opt/app/oraInventory
   from           : /opt/app/oracle/product/19c/db_1/oraInst.loc
OPatch version    : 12.2.0.1.21
OUI version       : 12.2.0.7.0
Log file location : /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatch/opatch2020-12-17_11-30-15AM_1.log

Verifying environment and performing prerequisite checks...
OPatch continues with these patches:   30321076

Do you want to proceed? [y|n]
y
User Responded with: Y
All checks passed.

Please shutdown Oracle instances running out of this ORACLE_HOME on the local system.
(Oracle Home = '/opt/app/oracle/product/19c/db_1')


Is the local system ready for patching? [y|n]
y
User Responded with: Y
Backing up files...
Applying interim patch '30321076' to OH '/opt/app/oracle/product/19c/db_1'

Patching component oracle.rdbms.rsf, 19.0.0.0.0...

Patching component oracle.rdbms, 19.0.0.0.0...
Patch 30321076 successfully applied.
Log file location: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatch/opatch2020-12-17_11-30-15AM_1.log

OPatch succeeded.
*/

Step 8:
[oracle@rac1 ~]$ /opt/app/oracle/product/19c/db_1/OPatch/opatch lspatches
/*
30321076;RTI 22224358   ORA-600 [QESMAGETPAMR-NULLCTX],
30805684;OJVM RELEASE UPDATE: 19.7.0.0.200414 (30805684)
30894985;OCW RELEASE UPDATE 19.7.0.0.0 (30894985)
30869156;Database Release Update : 19.7.0.0.200414 (30869156)

OPatch succeeded.
*/

Step 9:
[oracle@rac1 tmp]$ scp -r 30321076 oracle@rac2:/tmp/
/*
README.txt                                                   100% 6220     7.4MB/s   00:00
qct.o                                                        100%  116KB  24.5MB/s   00:00
actions.xml                                                  100%  879     1.2MB/s   00:00
inventory.xml                                                100% 1992     2.7MB/s   00:00
*/

Step 10:
[oracle@rac2 ~]$ /opt/app/oracle/product/19c/db_1/OPatch/opatch lspatches
/*
30805684;OJVM RELEASE UPDATE: 19.7.0.0.200414 (30805684)
30894985;OCW RELEASE UPDATE 19.7.0.0.0 (30894985)
30869156;Database Release Update : 19.7.0.0.200414 (30869156)

OPatch succeeded.
*/

Step 11:
[oracle@rac2 ~]$ /opt/app/oracle/product/19c/db_1/OPatch/opatch version
/*
OPatch Version: 12.2.0.1.21

OPatch succeeded.
*/

Step 12:
[oracle@rac2 ~]$ cd /tmp/
[oracle@rac2 tmp]$ ls -ltr | grep 30321076
/*
drwxrwxr-x  4 oracle oinstall  4096 Dec 17 11:36 30321076
*/

Step 13:
-- To applying the Oracle PSU on Node 2
[oracle@rac2 tmp]$ export ORACLE_HOME=/opt/app/oracle/product/19c/db_1
[oracle@rac2 tmp]$ export PATH=${ORACLE_HOME}/bin:$PATH
[oracle@rac2 tmp]$ export PATH=${PATH}:${ORACLE_HOME}/OPatch
[oracle@rac2 tmp]$ which opatch
/*
/opt/app/oracle/product/19c/db_1/OPatch/opatch
*/

Step 14:
[oracle@rac2 tmp]$ cd 30321076/
[oracle@rac2 30321076]$ /opt/app/oracle/product/19c/db_1/OPatch/opatch apply
/*
Oracle Interim Patch Installer version 12.2.0.1.21
Copyright (c) 2020, Oracle Corporation.  All rights reserved.


Oracle Home       : /opt/app/oracle/product/19c/db_1
Central Inventory : /opt/app/oraInventory
   from           : /opt/app/oracle/product/19c/db_1/oraInst.loc
OPatch version    : 12.2.0.1.21
OUI version       : 12.2.0.7.0
Log file location : /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatch/opatch2020-12-17_11-40-19AM_1.log

Verifying environment and performing prerequisite checks...
OPatch continues with these patches:   30321076

Do you want to proceed? [y|n]
y
User Responded with: Y
All checks passed.

Please shutdown Oracle instances running out of this ORACLE_HOME on the local system.
(Oracle Home = '/opt/app/oracle/product/19c/db_1')


Is the local system ready for patching? [y|n]
y
User Responded with: Y
Backing up files...
Applying interim patch '30321076' to OH '/opt/app/oracle/product/19c/db_1'

Patching component oracle.rdbms.rsf, 19.0.0.0.0...

Patching component oracle.rdbms, 19.0.0.0.0...
Patch 30321076 successfully applied.
Log file location: /opt/app/oracle/product/19c/db_1/cfgtoollogs/opatch/opatch2020-12-17_11-40-19AM_1.log

OPatch succeeded.
*/

Step 15:
[oracle@rac2 ~]$ /opt/app/oracle/product/19c/db_1/OPatch/opatch lspatches
/*
30321076;RTI 22224358   ORA-600 [QESMAGETPAMR-NULLCTX],
30805684;OJVM RELEASE UPDATE: 19.7.0.0.200414 (30805684)
30894985;OCW RELEASE UPDATE 19.7.0.0.0 (30894985)
30869156;Database Release Update : 19.7.0.0.200414 (30869156)

OPatch succeeded.
*/

Step 16:
[oracle@rac2 ~]$ /opt/app/oracle/product/19c/db_1/OPatch/opatch version
/*
OPatch Version: 12.2.0.1.21

OPatch succeeded.
*/

Step 17:
[oracle@rac1 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is not running on node rac1
Instance racdb2 is not running on node rac2
*/

Step 18:
[oracle@rac1 ~]$ srvctl start database -d racdb
[oracle@rac1 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is running on node rac1
Instance racdb2 is running on node rac2
*/

Step 19:
[oracle@rac1 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): rac1,rac2
*/

Step 20:
[oracle@rac1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Thu Dec 17 11:49:11 2020
Version 19.7.0.0.0

Copyright (c) 1982, 2019, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0

SQL> show con_name

CON_NAME
--------
CDB$ROOT

SQL> ALTER PLUGGABLE DATABASE racpdb OPEN INSTANCES=ALL;

Pluggable database altered.

SQL> SELECT status,instance_name FROM gv$instance;

STATUS       INSTANCE_NAME
------------ ----------------
OPEN         racdb1
OPEN         racdb2

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.7.0.0.0
*/