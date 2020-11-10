1.SCAN Listener Log

1.1 Do it from Terminal One

-- Step 1 (To find the current status of SCAN Listener)
[root@rac1 ~]# cd /opt/app/19c/grid/bin/
[root@rac1 bin]# ./crsctl stat res -t
/*
---------------------------------------------------------------------------------------------
Name                     Target   State                Server                   State details
---------------------------------------------------------------------------------------------
ora.LISTENER_SCAN1.lsnr  1        ONLINE  ONLINE       rac2                     STABLE
ora.LISTENER_SCAN2.lsnr  1        ONLINE  ONLINE       rac1                     STABLE
*/


-- Step 2 (To find the running SCAN Listener name)
[oracle@rac1 ~]$ ps -ef | grep SCAN
/*
grid       5987      1  0 10:59 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2
oracle    24553  19633  0 11:15 pts/0    00:00:00 grep --color=auto SCAN
*/

-- Step 3 (To find the Location and status of SCAN Listener)
[grid@rac1 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 10-NOV-2020 11:18:09

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                10-NOV-2020 10:59:55
Uptime                    0 days 0 hr. 18 min. 13 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/rac1/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.80)(PORT=1521)))
Services Summary...
Service "86b637b62fdf7a65e053f706e80a27ca.mydomain" has 2 instance(s).
  Instance "racdb1", status READY, has 1 handler(s) for this service...
  Instance "racdb2", status READY, has 1 handler(s) for this service...
Service "b0498bf9e9a7091de0534b0110acb6be.mydomain" has 2 instance(s).
  Instance "racdb1", status READY, has 1 handler(s) for this service...
  Instance "racdb2", status READY, has 1 handler(s) for this service...
Service "racdb.mydomain" has 2 instance(s).
  Instance "racdb1", status READY, has 1 handler(s) for this service...
  Instance "racdb2", status READY, has 1 handler(s) for this service...
Service "racdbXDB.mydomain" has 2 instance(s).
  Instance "racdb1", status READY, has 1 handler(s) for this service...
  Instance "racdb2", status READY, has 1 handler(s) for this service...
Service "racpdb.mydomain" has 2 instance(s).
  Instance "racdb1", status READY, has 1 handler(s) for this service...
  Instance "racdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 4 (To Land the terminal into Listener)
[grid@rac1 ~]$ lsnrctl
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 10-NOV-2020 11:28:08

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Welcome to LSNRCTL, type "help" for information.

LSNRCTL> show current_listener
Current Listener is LISTENER

LSNRCTL> set current_listener LISTENER_SCAN2
Current Listener is LISTENER_SCAN2

LSNRCTL>  show current_listener
Current Listener is LISTENER_SCAN2

LSNRCTL> set log_status off
Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
LISTENER_SCAN2 parameter "log_status" set to OFF
The command completed successfully
*/

1.2 Do it from Terminal Two

-- Steps (To take a backup of relevant log files and Create a new SCAN Listener log file )
[grid@rac1 ~]$ cd /opt/app/oracle/diag/tnslsnr/rac1/listener_scan2/alert/
[grid@rac1 alert]$ ls -ltr | grep log
/*
-rw-r--r-- 1 grid oinstall   1236 Nov 10 11:37 log.xml
*/

[grid@rac1 alert]$ tar --remove-files -cvf LISTENER_SCAN2.xml.tar.gz log*.xml
[grid@rac1 alert]$ ls -ltr | grep log
/*
-rw-r--r-- 1 grid oinstall   1236 Nov 10 11:37 log.xml
-rw-r----- 1 grid oinstall 982873 Nov 10 11:40 LISTENER_SCAN2.xml.tar.gz
*/

[grid@rac1 alert]$ cd ..
[grid@rac1 listener_scan2]$ cd trace/
[grid@rac1 trace]$ ls -ltr | grep listener_scan2
/*
-rw-r--r-- 1 grid oinstall   1236 Nov 10 11:37 listener_scan2.log
*/

[grid@rac1 trace]$ gzip listener_scan2.log
[grid@rac1 trace]$ touch listener_scan2.log
[grid@rac1 trace]$ ls -ltr
/*
-rw-r----- 1 grid oinstall 982873 Nov 10 11:29 listener_scan2.log.gz
-rw-r--r-- 1 grid oinstall   1236 Nov 10 11:37 listener_scan2.log
*/

1.3 Resume The Task from Terminal One:

-- Step 5 (To resume the task from landed terminal into Listener)
/*
LSNRCTL> show current_listener
Current Listener is LISTENER_SCAN2

LSNRCTL> set log_status on
Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
LISTENER_SCAN2 parameter "log_status" set to ON
The command completed successfully

LSNRCTL> show current_listener
Current Listener is LISTENER_SCAN2
LSNRCTL> exit
*/

-- Step 6 (To verify the Location and status of SCAN Listener)
[grid@rac1 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 10-NOV-2020 11:39:42

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                10-NOV-2020 10:59:55
Uptime                    0 days 0 hr. 39 min. 47 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/rac1/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.1.80)(PORT=1521)))
Services Summary...
Service "86b637b62fdf7a65e053f706e80a27ca.mydomain" has 2 instance(s).
  Instance "racdb1", status READY, has 1 handler(s) for this service...
  Instance "racdb2", status READY, has 1 handler(s) for this service...
Service "b0498bf9e9a7091de0534b0110acb6be.mydomain" has 2 instance(s).
  Instance "racdb1", status READY, has 1 handler(s) for this service...
  Instance "racdb2", status READY, has 1 handler(s) for this service...
Service "racdb.mydomain" has 2 instance(s).
  Instance "racdb1", status READY, has 1 handler(s) for this service...
  Instance "racdb2", status READY, has 1 handler(s) for this service...
Service "racdbXDB.mydomain" has 2 instance(s).
  Instance "racdb1", status READY, has 1 handler(s) for this service...
  Instance "racdb2", status READY, has 1 handler(s) for this service...
Service "racpdb.mydomain" has 2 instance(s).
  Instance "racdb1", status READY, has 1 handler(s) for this service...
  Instance "racdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 7 (To verify the running SCAN Listener name)
[oracle@rac1 ~]$ ps -ef | grep SCAN
/*
grid       5987      1  0 10:59 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
oracle    42276  41739  0 11:40 pts/0    00:00:00 grep --color=auto SCAN
*/

-- Step 8 (To verify the running status of Listener on Nodes)
[oracle@rac1 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): rac1,rac2
*/

-- Step 9 (To verify the current status of SCAN Listener)
[root@rac1 bin]# cd /opt/app/19c/grid/bin/
[root@rac1 bin]# ./crsctl stat res -t
/*
---------------------------------------------------------------------------------------------
Name                     Target   State                Server                   State details
---------------------------------------------------------------------------------------------
ora.LISTENER_SCAN1.lsnr  1        ONLINE  ONLINE       rac2                     STABLE
ora.LISTENER_SCAN2.lsnr  1        ONLINE  ONLINE       rac1                     STABLE
*/

-- Step 10 (To remove the backup of relevant log files)
[grid@rac1 trace]$ cd /opt/app/oracle/diag/tnslsnr/rac1/listener_scan2/trace
[grid@rac1 trace]$ rm -rf listener_scan2.log.gz
[grid@rac1 trace]$ cd ..
[grid@rac1 listener_scan2]$ cd alert/
[grid@rac1 alert]$ rm -rf LISTENER_SCAN2.xml.tar.gz


