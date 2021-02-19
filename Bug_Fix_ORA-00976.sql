-- To apply the Oracle 11.2.0.3.0 patchset to, a query having "CONNECT BY PRIOR" clause started to fail with:
-- ORA-00976: Specified pseudo column or operator not allowed here

Step 1:
[oracle@PDB-RAC1 ~]$ /opt/app/oracle/product/11.2.0.3/db_1/OPatch/opatch lsinventory
/*
Invoking OPatch 11.2.0.1.7

Oracle Interim Patch Installer version 11.2.0.1.7
Copyright (c) 2011, Oracle Corporation.  All rights reserved.


Oracle Home       : /opt/app/oracle/product/11.2.0.3/db_1
Central Inventory : /opt/app/oraInventory
   from           : /etc/oraInst.loc
OPatch version    : 11.2.0.1.7
OUI version       : 11.2.0.3.0
Log file location : /opt/app/oracle/product/11.2.0.3/db_1/cfgtoollogs/opatch/opatch2021-02-19_10-02-08AM.log

Lsinventory Output file location : /opt/app/oracle/product/11.2.0.3/db_1/cfgtoollogs/opatch/lsinv/lsinventory2021-02-19_10-02-08AM.txt

--------------------------------------------------------------------------------
Installed Top-level Products (1):

Oracle Database 11g                                                  11.2.0.3.0
There are 1 products installed in this Oracle Home.


There are no Interim patches installed in this Oracle Home.


Rac system comprising of multiple nodes
  Local node = pdb-rac1
  Remote node = pdb-rac2

--------------------------------------------------------------------------------

OPatch succeeded.
*/

Step 2:
[oracle@PDB-RAC2 ~]$ /opt/app/oracle/product/11.2.0.3/db_1/OPatch/opatch lsinventory
/*
Invoking OPatch 11.2.0.1.7

Oracle Interim Patch Installer version 11.2.0.1.7
Copyright (c) 2011, Oracle Corporation.  All rights reserved.


Oracle Home       : /opt/app/oracle/product/11.2.0.3/db_1
Central Inventory : /opt/app/oraInventory
   from           : /etc/oraInst.loc
OPatch version    : 11.2.0.1.7
OUI version       : 11.2.0.3.0
Log file location : /opt/app/oracle/product/11.2.0.3/db_1/cfgtoollogs/opatch/opatch2021-02-19_10-02-54AM.log

Lsinventory Output file location : /opt/app/oracle/product/11.2.0.3/db_1/cfgtoollogs/opatch/lsinv/lsinventory2021-02-19_10-02-54AM.txt

--------------------------------------------------------------------------------
Installed Top-level Products (1):

Oracle Database 11g                                                  11.2.0.3.0
There are 1 products installed in this Oracle Home.


There are no Interim patches installed in this Oracle Home.


Rac system comprising of multiple nodes
  Local node = pdb-rac2
  Remote node = pdb-rac1

--------------------------------------------------------------------------------

OPatch succeeded.
*/

Step 3:
[oracle@PDB-RAC1 ~]$ /opt/app/oracle/product/11.2.0.3/db_1/OPatch/opatch version
/*
Invoking OPatch 11.2.0.1.7

OPatch Version: 11.2.0.1.7

OPatch succeeded.
*/

[oracle@PDB-RAC2 ~]$ /opt/app/oracle/product/11.2.0.3/db_1/OPatch/opatch version
/*
Invoking OPatch 11.2.0.1.7

OPatch Version: 11.2.0.1.7

OPatch succeeded.
*/

Step 4:
[oracle@PDB-RAC1 ~]$ srvctl stop database -d nplprod
[oracle@PDB-RAC1 ~]$ srvctl status database -d nplprod
/*
Instance nplprod1 is not running on node PDB-RAC1
Instance nplprod2 is not running on node PDB-RAC2
*/

Step 5:
[oracle@PDB-RAC1 ~]$ cd /tmp/
[oracle@PDB-RAC1 tmp]$ unzip p14230270_112030_Linux-x86-64.zip
[oracle@PDB-RAC1 tmp]$ chmod -R 775 14230270
[oracle@PDB-RAC1 tmp]$ ls -ltr | grep 14230270
/*
drwxrwxr-x  4 oracle oinstall  4096 Apr 17  2020 14230270
-rw-r--r--  1 oracle oinstall 50222 Dec 16 20:17 p14230270_112030_Linux-x86-64.zip
*/

Step 6:
-- To applying the Oracle PSU
[oracle@PDB-RAC1 tmp]$ export ORACLE_HOME=/opt/app/oracle/product/11.2.0.3/db_1
[oracle@PDB-RAC1 tmp]$ export PATH=${ORACLE_HOME}/bin:$PATH
[oracle@PDB-RAC1 tmp]$ export PATH=${PATH}:${ORACLE_HOME}/OPatch
[oracle@PDB-RAC1 tmp]$ which opatch
/*
/opt/app/oracle/product/11.2.0.3/db_1/OPatch/opatch
*/

Step 7:
[oracle@PDB-RAC1 tmp]$ cd 14230270/
[oracle@PDB-RAC1 14230270]$ /opt/app/oracle/product/11.2.0.3/db_1/OPatch/opatch apply
/*
Invoking OPatch 11.2.0.1.7

Oracle Interim Patch Installer version 11.2.0.1.7
Copyright (c) 2011, Oracle Corporation.  All rights reserved.


Oracle Home       : /opt/app/oracle/product/11.2.0.3/db_1
Central Inventory : /opt/app/oraInventory
   from           : /etc/oraInst.loc
OPatch version    : 11.2.0.1.7
OUI version       : 11.2.0.3.0
Log file location : /opt/app/oracle/product/11.2.0.3/db_1/cfgtoollogs/opatch/opatch2021-02-19_10-17-41AM.log

Applying interim patch '14230270' to OH '/opt/app/oracle/product/11.2.0.3/db_1'
Verifying environment and performing prerequisite checks...

Do you want to proceed? [y|n]
y
User Responded with: Y
All checks passed.

This node is part of an Oracle Real Application Cluster.
Remote nodes: 'pdb-rac2'
Local node: 'pdb-rac1'
Please shutdown Oracle instances running out of this ORACLE_HOME on the local system.
(Oracle Home = '/opt/app/oracle/product/11.2.0.3/db_1')


Is the local system ready for patching? [y|n]
y
User Responded with: Y
Backing up files...

Patching component oracle.rdbms, 11.2.0.3.0...

Patching component oracle.rdbms.rsf, 11.2.0.3.0...

The local system has been patched.  You can restart Oracle instances on it.


Patching in rolling mode.


The node 'pdb-rac2' will be patched next.


Please shutdown Oracle instances running out of this ORACLE_HOME on 'pdb-rac2'.
(Oracle Home = '/opt/app/oracle/product/11.2.0.3/db_1')

Is the node ready for patching? [y|n]
y
User Responded with: Y
Updating nodes 'pdb-rac2'
   Apply-related files are:
     FP = "/opt/app/oracle/product/11.2.0.3/db_1/.patch_storage/14230270_Aug_7_2012_22_20_10/rac/copy_files.txt"
     DP = "/opt/app/oracle/product/11.2.0.3/db_1/.patch_storage/14230270_Aug_7_2012_22_20_10/rac/copy_dirs.txt"
     MP = "/opt/app/oracle/product/11.2.0.3/db_1/.patch_storage/14230270_Aug_7_2012_22_20_10/rac/make_cmds.txt"
     RC = "/opt/app/oracle/product/11.2.0.3/db_1/.patch_storage/14230270_Aug_7_2012_22_20_10/rac/remote_cmds.txt"

Instantiating the file "/opt/app/oracle/product/11.2.0.3/db_1/.patch_storage/14230270_Aug_7_2012_22_20_10/rac/copy_files.txt.instantiated" by replacing $ORACLE_HOME in "/opt/app/oracle/product/11.2.0.3/db_1/.patch_storage/14230270_Aug_7_2012_22_20_10/rac/copy_files.txt" with actual path.
Propagating files to remote nodes...
Instantiating the file "/opt/app/oracle/product/11.2.0.3/db_1/.patch_storage/14230270_Aug_7_2012_22_20_10/rac/copy_dirs.txt.instantiated" by replacing $ORACLE_HOME in "/opt/app/oracle/product/11.2.0.3/db_1/.patch_storage/14230270_Aug_7_2012_22_20_10/rac/copy_dirs.txt" with actual path.
Propagating directories to remote nodes...
Instantiating the file "/opt/app/oracle/product/11.2.0.3/db_1/.patch_storage/14230270_Aug_7_2012_22_20_10/rac/make_cmds.txt.instantiated" by replacing $ORACLE_HOME in "/opt/app/oracle/product/11.2.0.3/db_1/.patch_storage/14230270_Aug_7_2012_22_20_10/rac/make_cmds.txt" with actual path.
Running command on remote node 'pdb-rac2':
cd /opt/app/oracle/product/11.2.0.3/db_1/rdbms/lib; /usr/bin/make -f ins_rdbms.mk irenamedg ORACLE_HOME=/opt/app/oracle/product/11.2.0.3/db_1 || echo REMOTE_MAKE_FAILED::>&2

Running command on remote node 'pdb-rac2':
cd /opt/app/oracle/product/11.2.0.3/db_1/rdbms/lib; /usr/bin/make -f ins_rdbms.mk ioracle ORACLE_HOME=/opt/app/oracle/product/11.2.0.3/db_1 || echo REMOTE_MAKE_FAILED::>&2

Running command on remote node 'pdb-rac2':
cd /opt/app/oracle/product/11.2.0.3/db_1/rdbms/lib; /usr/bin/make -f ins_rdbms.mk client_sharedlib ORACLE_HOME=/opt/app/oracle/product/11.2.0.3/db_1 || echo REMOTE_MAKE_FAILED::>&2

Running command on remote node 'pdb-rac2':
cd /opt/app/oracle/product/11.2.0.3/db_1/network/lib; /usr/bin/make -f ins_net_client.mk client_sharedlib ORACLE_HOME=/opt/app/oracle/product/11.2.0.3/db_1 || echo REMOTE_MAKE_FAILED::>&2


The node 'pdb-rac2' has been patched.  You can restart Oracle instances on it.

There were relinks on remote nodes.  Remember to check the binary size and timestamp on the nodes 'pdb-rac2' .
The following make commands were invoked on remote nodes:
'cd /opt/app/oracle/product/11.2.0.3/db_1/rdbms/lib; /usr/bin/make -f ins_rdbms.mk irenamedg ORACLE_HOME=/opt/app/oracle/product/11.2.0.3/db_1
cd /opt/app/oracle/product/11.2.0.3/db_1/rdbms/lib; /usr/bin/make -f ins_rdbms.mk ioracle ORACLE_HOME=/opt/app/oracle/product/11.2.0.3/db_1
cd /opt/app/oracle/product/11.2.0.3/db_1/rdbms/lib; /usr/bin/make -f ins_rdbms.mk client_sharedlib ORACLE_HOME=/opt/app/oracle/product/11.2.0.3/db_1
cd /opt/app/oracle/product/11.2.0.3/db_1/network/lib; /usr/bin/make -f ins_net_client.mk client_sharedlib ORACLE_HOME=/opt/app/oracle/product/11.2.0.3/db_1
'

Patch 14230270 successfully applied
Log file location: /opt/app/oracle/product/11.2.0.3/db_1/cfgtoollogs/opatch/opatch2021-02-19_10-17-41AM.log

OPatch succeeded.

*/

Step 8:
[oracle@PDB-RAC1 14230270]$ /opt/app/oracle/product/11.2.0.3/db_1/OPatch/opatch lsinventory
/*
Invoking OPatch 11.2.0.1.7

Oracle Interim Patch Installer version 11.2.0.1.7
Copyright (c) 2011, Oracle Corporation.  All rights reserved.


Oracle Home       : /opt/app/oracle/product/11.2.0.3/db_1
Central Inventory : /opt/app/oraInventory
   from           : /etc/oraInst.loc
OPatch version    : 11.2.0.1.7
OUI version       : 11.2.0.3.0
Log file location : /opt/app/oracle/product/11.2.0.3/db_1/cfgtoollogs/opatch/opatch2021-02-19_10-21-22AM.log

Lsinventory Output file location : /opt/app/oracle/product/11.2.0.3/db_1/cfgtoollogs/opatch/lsinv/lsinventory2021-02-19_10-21-22AM.txt

--------------------------------------------------------------------------------
Installed Top-level Products (1):

Oracle Database 11g                                                  11.2.0.3.0
There are 1 products installed in this Oracle Home.


Interim patches (1) :

Patch  14230270     : applied on Fri Feb 19 10:18:29 NPT 2021
Unique Patch ID:  15357561
   Created on 7 Aug 2012, 22:20:10 hrs PST8PDT
   Bugs fixed:
     14230270



Rac system comprising of multiple nodes
  Local node = pdb-rac1
  Remote node = pdb-rac2

--------------------------------------------------------------------------------

OPatch succeeded.
*/

Step 9:
[oracle@PDB-RAC2 14230270]$ /opt/app/oracle/product/11.2.0.3/db_1/OPatch/opatch lsinventory
/*
Invoking OPatch 11.2.0.1.7

Oracle Interim Patch Installer version 11.2.0.1.7
Copyright (c) 2011, Oracle Corporation.  All rights reserved.


Oracle Home       : /opt/app/oracle/product/11.2.0.3/db_1
Central Inventory : /opt/app/oraInventory
   from           : /etc/oraInst.loc
OPatch version    : 11.2.0.1.7
OUI version       : 11.2.0.3.0
Log file location : /opt/app/oracle/product/11.2.0.3/db_1/cfgtoollogs/opatch/opatch2021-02-19_10-31-18AM.log

Lsinventory Output file location : /opt/app/oracle/product/11.2.0.3/db_1/cfgtoollogs/opatch/lsinv/lsinventory2021-02-19_10-31-18AM.txt

--------------------------------------------------------------------------------
Installed Top-level Products (1):

Oracle Database 11g                                                  11.2.0.3.0
There are 1 products installed in this Oracle Home.


Interim patches (1) :

Patch  14230270     : applied on Fri Feb 19 10:25:00 NPT 2021
Unique Patch ID:  15357561
   Created on 7 Aug 2012, 22:20:10 hrs PST8PDT
   Bugs fixed:
     14230270



Rac system comprising of multiple nodes
  Local node = pdb-rac2
  Remote node = pdb-rac1

--------------------------------------------------------------------------------

OPatch succeeded.
*/

Step 10:
[oracle@PDB-RAC1 ~]$ srvctl status database -d nplprod
/*
Instance nplprod1 is not running on node PDB-RAC1
Instance nplprod2 is not running on node PDB-RAC2
*/

Step 11:
[oracle@PDB-RAC1 ~]$ srvctl start database -d nplprod
[oracle@PDB-RAC1 ~]$ srvctl status database -d nplprod
/*
Instance nplprod1 is running on node PDB-RAC1
Instance nplprod2 is running on node PDB-RAC2
*/

Step 12:
[oracle@PDB-RAC1 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): PDB-RAC1,PDB-RAC2
*/