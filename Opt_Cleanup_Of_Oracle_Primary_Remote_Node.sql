/**********************************************************************************/
----------------------------------Primary Node:-------------------------------------
/**********************************************************************************/

1. Oracle audit log
[oracle@racdb1 ~]$ cd /opt/app/oracle/product/11.2.0.3/db_1/rdbms/
[oracle@racdb1 rdbms]$ rm -rf audit && mkdir audit

2. Grid audit log
[grid@racdb1 rdbms]$ cd /opt/app/11.2.0.3/grid/rdbms
[grid@racdb1 rdbms]$ rm -rf audit && mkdir audit

4. Listener Log
4.1 Do it from Terminal One
[grid@racdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 23-AUG-2020 10:31:46

Copyright (c) 1991, 2011, Oracle. All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias LISTENER
Version TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date 15-AUG-2020 12:03:30
Uptime 7 days 22 hr. 28 min. 15 sec
Trace Level off
Security ON: Local OS Authentication
SNMP OFF
Listener Parameter File /opt/app/11.2.0.3/grid/network/admin/listener.ora
Listener Log File /opt/app/oracle/diag/tnslsnr/racdb1/listener/alert/log.xml
Listening Endpoints Summary...
(DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.5.111)(PORT=1521)))
(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.5.121)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "PRIMARY" has 1 instance(s).
Instance "racdb1", status READY, has 1 handler(s) for this service...
Service "racdb" has 1 instance(s).
Instance "racdb", status UNKNOWN, has 1 handler(s) for this service...
Service "racdbXDB" has 1 instance(s).
Instance "racdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

[grid@racdb1 ~]$ lsnrctl
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 23-AUG-2020 10:32:03

Copyright (c) 1991, 2011, Oracle. All rights reserved.

Welcome to LSNRCTL, type "help" for information.

LSNRCTL> show current_listener
Current Listener is LISTENER

LSNRCTL> set current_listener LISTENER
Current Listener is LISTENER

LSNRCTL> set log_status off
Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
LISTENER parameter "log_status" set to OFF
The command completed successfully
*/

4.2 Do it from Terminal Two
[grid@racdb1 ~]$ cd /opt/app/oracle/diag/tnslsnr/racdb1/
/*
drwxr-xr-x. 13 grid oinstall 4096 Apr 18 2014 listener
drwxr-xr-x. 13 grid oinstall 4096 Jun 18 2014 listener_scan1
drwxr-xr-x. 13 grid oinstall 4096 Jun 18 2014 listener_scan3
drwxr-xr-x. 13 grid oinstall 4096 Jun 18 2014 listener_scan2
*/
[grid@racdb1 racdb1]$ cd listener/alert
[grid@racdb1 alert]$ tar --remove-files -cvf listener.xml.tar.gz log_*.xml
[grid@racdb1 alert]$ cd ..
[grid@racdb1 listener]$ cd trace/
[grid@racdb1 trace]$ gzip listener.log

4.3 Resume The Task from Terminal One:
/*
LSNRCTL> set log_status on
Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
LISTENER parameter "log_status" set to ON
The command completed successfully

LSNRCTL> exit
*/

[grid@racdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 23-AUG-2020 10:46:17

Copyright (c) 1991, 2011, Oracle. All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias LISTENER
Version TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date 15-AUG-2020 12:03:30
Uptime 7 days 22 hr. 42 min. 46 sec
Trace Level off
Security ON: Local OS Authentication
SNMP OFF
Listener Parameter File /opt/app/11.2.0.3/grid/network/admin/listener.ora
Listener Log File /opt/app/oracle/diag/tnslsnr/racdb1/listener/alert/log.xml
Listening Endpoints Summary...
(DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.5.111)(PORT=1521)))
(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.5.121)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "PRIMARY" has 1 instance(s).
Instance "racdb1", status READY, has 1 handler(s) for this service...
Service "racdb" has 1 instance(s).
Instance "racdb", status UNKNOWN, has 1 handler(s) for this service...
Service "racdbXDB" has 1 instance(s).
Instance "racdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

4.4 Resume The Task from Terminal Two:
[grid@racdb1 ~]$ cd /opt/app/oracle/diag/tnslsnr/racdb1/listener/alert
[grid@racdb1 alert]$ rm -rf listener.xml.tar.gz

[grid@racdb1 listener]$ cd ..
[grid@racdb1 listener]$ cd trace/
[grid@racdb1 trace]$ rm -rf listener.log.gz

5. Remove the Oracle Log
[grid@racdb1 ~]$ cd /opt/app/11.2.0.3/grid/log/racdb1/
[grid@racdb1 racdb1]$ gzip alertracdb1.log
[grid@racdb1 racdb1]$ rm -rf alertracdb1.log.gz

6. Remove Oracle Log
[oracle@racdb1 ~]$ cd /opt/app/oracle/diag/rdbms/primary/racdb1/trace/
[oracle@racdb1 trace]$ gzip alert_racdb1.log
[oracle@racdb1 trace]$ rm -rf alert_racdb1.log.zip


/**********************************************************************************/
---------------------------------Remote Nodes:-------------------------------------
/**********************************************************************************/
1. Oracle audit log
[oracle@racdb2 ~]$ cd /opt/app/oracle/product/11.2.0.3/db_1/rdbms/
[oracle@racdb2 rdbms]$ rm -rf audit && mkdir audit

2. Grid audit log
[grid@racdb2 rdbms]$ cd /opt/app/11.2.0.3/grid/rdbms
[grid@racdb2 rdbms]$ rm -rf audit && mkdir audit

4. Listener Log
4.1 Do it from Terminal One
[grid@racdb2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 23-AUG-2020 10:31:46

Copyright (c) 1991, 2011, Oracle. All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias LISTENER
Version TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date 15-AUG-2020 12:03:30
Uptime 7 days 22 hr. 28 min. 15 sec
Trace Level off
Security ON: Local OS Authentication
SNMP OFF
Listener Parameter File /opt/app/11.2.0.3/grid/network/admin/listener.ora
Listener Log File /opt/app/oracle/diag/tnslsnr/racdb2/listener/alert/log.xml
Listening Endpoints Summary...
(DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.5.111)(PORT=1521)))
(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.5.121)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "PRIMARY" has 1 instance(s).
Instance "racdb2", status READY, has 1 handler(s) for this service...
Service "racdb" has 1 instance(s).
Instance "racdb", status UNKNOWN, has 1 handler(s) for this service...
Service "racdbXDB" has 1 instance(s).
Instance "racdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

[grid@racdb2 ~]$ lsnrctl
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 23-AUG-2020 10:32:03

Copyright (c) 1991, 2011, Oracle. All rights reserved.

Welcome to LSNRCTL, type "help" for information.

LSNRCTL> show current_listener
Current Listener is LISTENER

LSNRCTL> set current_listener LISTENER
Current Listener is LISTENER

LSNRCTL> set log_status off
Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
LISTENER parameter "log_status" set to OFF
The command completed successfully
*/

4.2 Do it from Terminal Two
[grid@racdb2 ~]$ cd /opt/app/oracle/diag/tnslsnr/racdb2/
/*
drwxr-xr-x. 13 grid oinstall 4096 Apr 18 2014 listener
drwxr-xr-x. 13 grid oinstall 4096 Jun 18 2014 listener_scan1
drwxr-xr-x. 13 grid oinstall 4096 Jun 18 2014 listener_scan3
drwxr-xr-x. 13 grid oinstall 4096 Jun 18 2014 listener_scan2
*/
[grid@racdb2 racdb2]$ cd listener/alert
[grid@racdb2 alert]$ tar --remove-files -cvf listener.xml.tar.gz log_*.xml
[grid@racdb2 alert]$ cd ..
[grid@racdb2 listener]$ cd trace/
[grid@racdb2 trace]$ gzip listener.log

4.3 Resume The Task from Terminal One:
/*
LSNRCTL> set log_status on
Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
LISTENER parameter "log_status" set to ON
The command completed successfully

LSNRCTL> exit
*/

[grid@racdb2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 23-AUG-2020 10:46:17

Copyright (c) 1991, 2011, Oracle. All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias LISTENER
Version TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date 15-AUG-2020 12:03:30
Uptime 7 days 22 hr. 42 min. 46 sec
Trace Level off
Security ON: Local OS Authentication
SNMP OFF
Listener Parameter File /opt/app/11.2.0.3/grid/network/admin/listener.ora
Listener Log File /opt/app/oracle/diag/tnslsnr/racdb2/listener/alert/log.xml
Listening Endpoints Summary...
(DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.5.111)(PORT=1521)))
(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.16.5.121)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "PRIMARY" has 1 instance(s).
Instance "racdb2", status READY, has 1 handler(s) for this service...
Service "racdb" has 1 instance(s).
Instance "racdb", status UNKNOWN, has 1 handler(s) for this service...
Service "racdbXDB" has 1 instance(s).
Instance "racdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

4.4 Resume The Task from Terminal Two:
[grid@racdb2 ~]$ cd /opt/app/oracle/diag/tnslsnr/racdb2/listener/alert
[grid@racdb2 alert]$ rm -rf listener.xml.tar.gz

[grid@racdb2 listener]$ cd ..
[grid@racdb2 listener]$ cd trace/
[grid@racdb2 trace]$ rm -rf listener.log.gz

5. Remove the Oracle Log
[grid@racdb2 ~]$ cd /opt/app/11.2.0.3/grid/log/racdb2/
[grid@racdb2 racdb2]$ gzip alertracdb2.log
[grid@racdb2 racdb2]$ rm -rf alertracdb2.log.gz

6. Remove Oracle Log
[oracle@racdb2 ~]$ cd /opt/app/oracle/diag/rdbms/primary/racdb2/trace/
[oracle@racdb2 trace]$ gzip alert_racdb2.log
[oracle@racdb2 trace]$ rm -rf alert_racdb2.log.zip

 