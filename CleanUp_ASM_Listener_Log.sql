1.ASM Listener Log

1.1 Do it from Terminal One

-- Step 1 (To find the current status of ASM Listener)
[root@pdb1 ~]# cd /opt/app/19c/grid/bin/
[root@pdb1 bin]# ./crsctl stat res -t
/*
---------------------------------------------------------------------------------------------
Name                     Target   State                Server                   State details
---------------------------------------------------------------------------------------------
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1              STABLE
      2        ONLINE  ONLINE       pdb2              STABLE
*/

-- Step 2 (To find the running ASM Listener name)
[grid@pdb1 ~]$ ps -ef | grep ASMNET1LSNR
/*
grid     18177     1  0 10:50 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr ASMNET1LSNR_ASM -no_crs_notify -inherit
grid     27469 27260  0 10:55 pts/2    00:00:00 grep --color=auto ASMNET1LSNR
*/

-- Step 3 (To find the Location and status of ASM Listener)
[grid@pdb1 ~]$ lsnrctl status ASMNET1LSNR_ASM
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 14-JUN-2025 10:56:14

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=ASMNET1LSNR_ASM)))
STATUS of the LISTENER
------------------------
Alias                     ASMNET1LSNR_ASM
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                14-JUN-2025 10:50:57
Uptime                    0 days 0 hr. 5 min. 17 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/account-dr1/asmnet1lsnr_asm/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=ASMNET1LSNR_ASM)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=10.0.1.150)(PORT=1525)))
Services Summary...
Service "+ASM" has 2 instance(s).
  Instance "+ASM1", status READY, has 2 handler(s) for this service...
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 2 instance(s).
  Instance "+ASM1", status READY, has 2 handler(s) for this service...
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 2 instance(s).
  Instance "+ASM1", status READY, has 2 handler(s) for this service...
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 2 instance(s).
  Instance "+ASM1", status READY, has 2 handler(s) for this service...
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 4 (To Land the terminal into Listener)
[grid@pdb1 ~]$ lsnrctl
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 14-JUN-2025 11:01:36

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Welcome to LSNRCTL, type "help" for information.

LSNRCTL> show current_listener
Current Listener is LISTENER

LSNRCTL> set current_listener ASMNET1LSNR_ASM
Current Listener is ASMNET1LSNR_ASM

LSNRCTL> show current_listener
Current Listener is ASMNET1LSNR_ASM

LSNRCTL> set log_status off
Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=ASMNET1LSNR_ASM)))
ASMNET1LSNR_ASM parameter "log_status" set to OFF
The command completed successfully

*/

1.2 Do it from Terminal Two

-- Steps (To take a backup of relevant log files and Create a new ASM Listener log file )
[grid@pdb1 ~]$ cd /opt/app/oracle/diag/tnslsnr/account-dr1/asmnet1lsnr_asm/alert/
[grid@pdb1 alert]$ ll
/*
-rw-r----- 1 grid oinstall 314573067 Oct  8  2024 log_1.xml
-rw-r----- 1 grid oinstall 314573106 Nov  5  2024 log_2.xml
-rw-r----- 1 grid oinstall 314572943 Dec  3  2024 log_3.xml
-rw-r----- 1 grid oinstall 314572892 Dec 31 01:01 log_4.xml
-rw-r----- 1 grid oinstall 314572998 Jan 28 00:58 log_5.xml
-rw-r----- 1 grid oinstall 314572918 Feb 25 00:36 log_6.xml
-rw-r----- 1 grid oinstall 314573182 Mar 25 00:11 log_7.xml
-rw-r----- 1 grid oinstall 314573106 Apr 22 03:10 log_8.xml
-rw-r----- 1 grid oinstall 314572856 May 20 03:14 log_9.xml
-rw-r----- 1 grid oinstall 284929337 Jun 14 11:02 log.xml
*/

[grid@pdb1 alert]$ tar --remove-files -cvf asmnet1lsnr_asm.xml.tar.gz log_*.xml
/*
log_1.xml
log_2.xml
log_3.xml
log_4.xml
log_5.xml
log_6.xml
log_7.xml
log_8.xml
log_9.xml
*/

[grid@pdb1 alert]$ ll
/*
-rw-r--r-- 1 grid oinstall 2831165440 Jun 14 11:05 asmnet1lsnr_asm.xml.tar.gz
-rw-r----- 1 grid oinstall  284929337 Jun 14 11:02 log.xml
*/

[grid@pdb1 alert]$ cd ..
[grid@pdb1 asmnet1lsnr_asm]$ cd trace/
[grid@pdb1 trace]$ ll
/*
-rw-r----- 1 grid oinstall 109544781 Oct  8  2024 asmnet1lsnr_asm_1.log
-rw-r----- 1 grid oinstall 176310539 Nov  5  2024 asmnet1lsnr_asm_2.log
-rw-r----- 1 grid oinstall 176327110 Dec  3  2024 asmnet1lsnr_asm_3.log
-rw-r----- 1 grid oinstall 176315431 Dec 31 01:01 asmnet1lsnr_asm_4.log
-rw-r----- 1 grid oinstall 176370840 Jan 28 00:58 asmnet1lsnr_asm_5.log
-rw-r----- 1 grid oinstall 176418604 Feb 25 00:36 asmnet1lsnr_asm_6.log
-rw-r----- 1 grid oinstall 176414809 Mar 25 00:11 asmnet1lsnr_asm_7.log
-rw-r----- 1 grid oinstall 176054015 Apr 22 03:10 asmnet1lsnr_asm_8.log
-rw-r----- 1 grid oinstall 176486060 May 20 03:14 asmnet1lsnr_asm_9.log
-rw-r----- 1 grid oinstall 159637865 Jun 14 11:02 asmnet1lsnr_asm.log
*/

[grid@pdb1 trace]$ tar --remove-files -cvf asmnet1lsnr_asm.log.tar.gz asmnet1lsnr_asm_*.log
/*
asmnet1lsnr_asm_1.log
asmnet1lsnr_asm_2.log
asmnet1lsnr_asm_3.log
asmnet1lsnr_asm_4.log
asmnet1lsnr_asm_5.log
asmnet1lsnr_asm_6.log
asmnet1lsnr_asm_7.log
asmnet1lsnr_asm_8.log
asmnet1lsnr_asm_9.log
*/

[grid@pdb1 trace]$ ll
/*
-rw-r----- 1 grid oinstall  159637865 Jun 14 11:02 asmnet1lsnr_asm.log
-rw-r--r-- 1 grid oinstall 1520250880 Jun 14 11:07 asmnet1lsnr_asm.log.tar.gz
*/

[grid@pdb1 trace]$ gzip asmnet1lsnr_asm.log && touch asmnet1lsnr_asm.log && chmod -R 640 asmnet1lsnr_asm.log
[grid@pdb1 trace]$ ll
/*
-rw-r----- 1 grid oinstall          0 Jun 14 11:09 asmnet1lsnr_asm.log
-rw-r----- 1 grid oinstall    7191764 Jun 14 11:02 asmnet1lsnr_asm.log.gz
-rw-r--r-- 1 grid oinstall 1520250880 Jun 14 11:07 asmnet1lsnr_asm.log.tar.gz
*/

1.3 Resume The Task from Terminal One:
-- Step 5 (To resume the task from landed terminal into Listener)
/*
LSNRCTL> show current_listener
Current Listener is ASMNET1LSNR_ASM
LSNRCTL> set log_status on
Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=ASMNET1LSNR_ASM)))
ASMNET1LSNR_ASM parameter "log_status" set to ON
The command completed successfully
LSNRCTL> show current_listener
Current Listener is ASMNET1LSNR_ASM
LSNRCTL> exit
*/

-- Step 6 (To Verification of log write)
[grid@pdb1 trace]$ ll /opt/app/oracle/diag/tnslsnr/pdb1/asmnet1lsnr_asm/trace
/*
-rw-r----- 1 grid oinstall        947 Jun 14 11:35 asmnet1lsnr_asm.log
-rw-r----- 1 grid oinstall    3627788 Jun 14 11:28 asmnet1lsnr_asm.log.gz
-rw-r--r-- 1 grid oinstall 1611274240 Jun 14 11:33 asmnet1lsnr_asm.log.tar.gz
*/

-- Step 6.1 (To verify the Location and status of ASM Listener)
[grid@pdb1 ~]$ lsnrctl status ASMNET1LSNR_ASM
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 14-JUN-2025 11:31:04

Copyright (c) 1991, 2019, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=ASMNET1LSNR_ASM)))
STATUS of the LISTENER
------------------------
Alias                     ASMNET1LSNR_ASM
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                14-JUN-2025 11:23:46
Uptime                    0 days 0 hr. 7 min. 17 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/account-dr1/asmnet1lsnr_asm/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=ASMNET1LSNR_ASM)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=10.0.1.150)(PORT=1525)))
Services Summary...
Service "+ASM" has 2 instance(s).
  Instance "+ASM1", status READY, has 2 handler(s) for this service...
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 2 instance(s).
  Instance "+ASM1", status READY, has 2 handler(s) for this service...
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 2 instance(s).
  Instance "+ASM1", status READY, has 2 handler(s) for this service...
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 2 instance(s).
  Instance "+ASM1", status READY, has 2 handler(s) for this service...
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

-- Step 7 (To verify the running ASM Listener name)
[grid@pdb1 ~]$ ps -ef | grep ASMNET1LSNR
/*
grid     17065     1  0 11:23 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr ASMNET1LSNR_ASM -no_crs_notify -inherit
grid     27040 26626  0 11:30 pts/2    00:00:00 grep --color=auto ASMNET1LSNR
*/

-- Step 9 (To verify the current status of SCAN Listener)
[root@pdb1 ~]# cd /opt/app/19c/grid/bin/
[root@pdb1 bin]# ./crsctl stat res -t
/*
---------------------------------------------------------------------------------------------
Name                     Target   State                Server                   State details
---------------------------------------------------------------------------------------------
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1              STABLE
      2        ONLINE  ONLINE       pdb2              STABLE
*/

-- Step 10 (To remove the backup of relevant log files)
[grid@pdb1 ~]$ cd /opt/app/oracle/diag/tnslsnr/pdb1/asmnet1lsnr_asm/trace
[grid@pdb1 trace]$ rm -rf asmnet1lsnr_asm.log.*
[grid@pdb1 trace]$ cd ..
[grid@pdb1 asmnet1lsnr_asm]$ cd alert/
[grid@pdb1 alert]$ rm -rf asmnet1lsnr_asm.xml.tar.gz