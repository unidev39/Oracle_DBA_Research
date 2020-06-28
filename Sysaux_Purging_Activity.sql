--1.
--STATISTICS_LEVEL
SELECT name,type,value FROM v$parameter WHERE Upper(name) = 'STATISTICS_LEVEL';
/*
NAME             TYPE VALUE
---------------- ---- -------
statistics_level 2    TYPICAL
*/

--2.
ALTER DATABASE DATAFILE '+DATA2/racdb/datafile/sysaux01.dbf' AUTOEXTEND OFF;

--3.
[oracle@racdbnode1 ~]$ cd /opt/app/oracle/product/11.2.0.3/db_1/rdbms/admin/
[oracle@racdbnode1 admin]$ ls | grep awrinfo.sql 
--awrinfo.sql
[oracle@racdbnode1 admin]$ pwd
--/opt/app/oracle/product/11.2.0.3/db_1/rdbms/admin
[oracle@racdbnode1 admin]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Fri May 1 20:35:35 2020

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> @awrinfo.sql
End of Report
Report written to Before_awrinfo_Node_1.txt
SQL> exit
*/

--4.
[oracle@racdbnode2 ~]$ cd /opt/app/oracle/product/11.2.0.3/db_1/rdbms/admin/
[oracle@racdbnode2 admin]$ ls | grep awrinfo.sql 
--awrinfo.sql
[oracle@racdbnode2 admin]$ pwd
--/opt/app/oracle/product/11.2.0.3/db_1/rdbms/admin
[oracle@racdbnode1 admin]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Fri May 1 20:35:35 2020

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> @awrinfo.sql
End of Report
Report written to Before_awrinfo_Node_2.txt
SQL> exit
*/

--5.
SELECT segment_name,segment_type,TRUNC(bytes/1024/1024/1024) gb 
FROM dba_segments 
WHERE segment_name IN ('WRI$_OPTSTAT_HISTHEAD_HISTORY','I_WRI$_OPTSTAT_HH_OBJ_ICOL_ST','I_WRI$_OPTSTAT_HH_ST'); 
/*
SEGMENT_NAME                  SEGMENT_TYPE GB
----------------------------- ------------ --
WRI$_OPTSTAT_HISTHEAD_HISTORY TABLE        13
I_WRI$_OPTSTAT_HH_OBJ_ICOL_ST INDEX        10
I_WRI$_OPTSTAT_HH_ST          INDEX        4
*/

--6.
SELECT occupant_name,schema_name,(space_usage_kbytes/(1024*1024)) gb 
FROM v$sysaux_occupants
ORDER BY 3 desc;
/*
OCCUPANT_NAME            SCHEMA_NAME                       GB
------------------------ ------------------ -----------------
SM/OPTSTAT               SYS                321.1317138671875
SM/AWR                   SYS                46.38055419921875
XDB                      XDB                   .2650146484375
SM/ADVISOR               SYS                  .12750244140625
SDO                      MDSYS                 .0672607421875
EM                       SYSMAN                .0606689453125
PL/SCOPE                 SYS                  .02630615234375
ORDIM/ORDDATA            ORDDATA              .02362060546875
LOGMNR                   SYSTEM               .01971435546875
SM/OTHER                 SYS                  .01556396484375
EXPRESSION_FILTER        EXFSYS                 .007080078125
WM                       WMSYS                 .0047607421875
SMON_SCN_TIME            SYS                   .0032958984375
SQL_MANAGEMENT_BASE      SYS                   .0032958984375
EM_MONITORING_USER       DBSNMP               .00311279296875
AO                       SYS                      .0029296875
XSOQHIST                 SYS                      .0029296875
LOGSTDBY                 SYSTEM                 .002685546875
STREAMS                  SYS                       .001953125
JOB_SCHEDULER            SYS                  .00164794921875
ORDIM                    ORDSYS                .0008544921875
AUTO_TASK                SYS                   .0006103515625
TEXT                     CTXSYS                             0
ULTRASEARCH              WKSYS                              0
AUDIT_TABLES             SYS                                0
TSM                      TSMSYS                             0
XSAMD                    OLAPSYS                            0
ORDIM/SI_INFORMTN_SCHEMA SI_INFORMTN_SCHEMA                 0
ORDIM/ORDPLUGINS         ORDPLUGINS                         0
STATSPACK                PERFSTAT                           0
ULTRASEARCH_DEMO_USER    WK_TEST                            0
*/

--7.
SELECT dbms_stats.get_stats_history_retention FROM dual;    
/*
GET_STATS_HISTORY_RETENTION
---------------------------
31
*/

--8.
SELECT dbms_stats.get_stats_history_availability FROM dual;
/*
GET_STATS_HISTORY_AVAILABILITY
------------------------------
25.05.2020 00:03:53.943 +05:45
*/

--9.
SELECT table_name,partition_name from dba_tab_partitions
WHERE table_name = 'WRH$_ACTIVE_SESSION_HISTORY';
/*
TABLE_NAME                  PARTITION_NAME
--------------------------- --------------------------
WRH$_ACTIVE_SESSION_HISTORY WRH$_ACTIVE_448326366_6780
WRH$_ACTIVE_SESSION_HISTORY WRH$_ACTIVE_SES_MXDB_MXSN
*/

--10.
SELECT /*+full(t) parallel(8)*/ TRUNC(sysdate)-TRUNC(MIN(savtime)) FROM sys.wri$_optstat_histhead_history t;
/*
TRUNC(SYSDATE)-TRUNC(MIN(SAVTIME))
----------------------------------
1077
*/


--11.
SET SERVEROUTPUT ON;
BEGIN
    Dbms_Output.Put_Line('Query Execution Start Time:=> '||systimestamp);
    dbms_stats.purge_stats(dbms_stats.purge_all);
    Dbms_Output.Put_Line('Query Execution End Time:=> '||systimestamp);
END;
/
-- 9sec run time
/*
Query Execution Start Time:=> 25-JUN-20 07.29.43.414504000 PM +05:45
Query Execution End Time:=> 25-JUN-20 07.29.52.801561000 PM +05:45
*/

--12.
ALTER DATABASE DATAFILE '+DATA2/racdb/datafile/sysaux01.dbf' AUTOEXTEND ON;

--13.
SET SERVEROUTPUT ON;
DECLARE
    TYPE cursor_rc   IS REF cursor;
    l_cursor         cursor_rc;
    l_sql            VARCHAR2(32767);
    l_query          VARCHAR2(500);
    l_index_name     VARCHAR2(50);
    l_owner          VARCHAR2(30);
BEGIN
    Dbms_Output.Put_Line('Query Execution Start Time:=> '||systimestamp);
    l_sql := 'SELECT ''ALTER INDEX ''||owner||''.''||index_name||'' REBUILD''      
                   query,index_name,owner 
              FROM dba_indexes
              WHERE owner LIKE ''%SYS%''
              ORDER BY index_name';
    OPEN l_cursor FOR l_sql;
    LOOP
        FETCH l_cursor INTO l_query,l_index_name,l_owner;
        EXIT WHEN l_cursor%NOTFOUND;
        BEGIN
            EXECUTE IMMEDIATE l_query;
        EXCEPTION WHEN OTHERS THEN
           IF (SQLCODE = -14086) THEN
                FOR i IN (SELECT partition_name
                          FROM dba_ind_partitions a
                          WHERE index_name =l_index_name AND index_owner = l_owner)
                LOOP 
                   BEGIN 
                       EXECUTE IMMEDIATE 'ALTER INDEX '||l_owner||'.'||l_index_name||' REBUILD PARTITION '||i.partition_name||' ';
                   EXCEPTION WHEN OTHERS THEN 
                       NULL;
                   END;
                END LOOP;
            ELSE
               NULL;
            END IF;
        END;
    END LOOP;          
    CLOSE l_cursor;
    Dbms_Output.Put_Line('Query Execution End Time:=> '||systimestamp);
END;
/
-- 27min runtime
/* 
Query Execution Start Time:=> 25-JUN-20 07.31.39.339856000 PM +05:45
Query Execution End Time:=> 25-JUN-20 07.58.45.019565000 PM +05:45
*/

--14.
SET SERVEROUTPUT ON;
BEGIN
    Dbms_Output.Put_Line('Query Execution Start Time:=> '||systimestamp);
    dbms_stats.gather_schema_stats('SYS');
    Dbms_Output.Put_Line('Query Execution End Time:=> '||systimestamp);
END;
/
-- 34min runtime 
/*
Query Execution Start Time:=> 25-JUN-20 08.10.57.015763000 PM +05:45
Query Execution End Time:=> 25-JUN-20 08.44.26.160961000 PM +05:45
*/

--15. 
SET SERVEROUTPUT ON;
BEGIN
    Dbms_Output.Put_Line('Query Execution Start Time:=> '||systimestamp);
    Dbms_Stats.gather_dictionary_stats;
    Dbms_Output.Put_Line('Query Execution End Time:=> '||systimestamp);
END;
/
-- 2min runtime
/*
Query Execution Start Time:=> 25-JUN-20 08.45.23.751365000 PM +05:45
Query Execution End Time:=> 25-JUN-20 08.47.08.693245000 PM +05:45
*/

--16.
SET SERVEROUTPUT ON;
BEGIN
    Dbms_Output.Put_Line('Query Execution Start Time:=> '||systimestamp);
    Dbms_Stats.gather_fixed_objects_stats;
    Dbms_Output.Put_Line('Query Execution End Time:=> '||systimestamp);
END;
/
-- 4min runtime
/*
Query Execution Start Time:=> 25-JUN-20 08.47.40.137509000 PM +05:45
Query Execution End Time:=> 25-JUN-20 08.51.09.972750000 PM +05:45
*/

--17.
SET SERVEROUTPUT ON;
DECLARE
    TYPE cursor_rc  IS REF cursor;
    l_cursor        cursor_rc;
    l_sql           VARCHAR2(32767);
    l_query         VARCHAR2(500);
BEGIN
    Dbms_Output.Put_Line('Query Execution Start Time:=> '||systimestamp);
    l_sql := 'SELECT DISTINCT
                   ''BEGIN
                       dbms_stats.gather_table_stats
                       (
                        ownname          => ''''''||OWNER||'''''',
                        tabname          => ''''''||TABLE_NAME||'''''', 
                        estimate_percent => 100,
                        cascade          => TRUE,
                        degree           => 10, 
                        method_opt       =>''''FOR ALL COLUMNS SIZE AUTO''''
                       );
                   END; '' gather_table_stats 
              FROM dba_tables WHERE NOT REGEXP_LIKE(table_name,''(BIN|BK)'') 
              ORDER BY 1';
    OPEN l_cursor FOR l_sql;
    LOOP
        FETCH l_cursor INTO l_query;
        EXIT WHEN l_cursor%NOTFOUND;
        BEGIN
            EXECUTE IMMEDIATE l_query;
        EXCEPTION WHEN OTHERS THEN
           NULL;
        END;
    END LOOP;
    CLOSE l_cursor;
    Dbms_Output.Put_Line('Query Execution End Time:=> '||systimestamp);
END;
/
-- 17hr after completion of process 32GB archive generated
/*
Query Execution End Time:=> 25-JUN-20 08.53.11.461530000 PM +05:45
Query Execution End Time:=> 26-JUN-20 12.59.24.610270000 PM +05:45
*/

--18.
--STATISTICS_LEVEL
SELECT name,type,value FROM v$parameter WHERE Upper(name) = 'STATISTICS_LEVEL';
/*
NAME             TYPE VALUE
---------------- ---- -------
statistics_level 2    TYPICAL
*/

--19.
[oracle@racdbnode1 ~]$ cd /opt/app/oracle/product/11.2.0.3/db_1/rdbms/admin/
[oracle@racdbnode1 admin]$ ls | grep awrinfo.sql 
--awrinfo.sql
[oracle@racdbnode1 admin]$ pwd
--/opt/app/oracle/product/11.2.0.3/db_1/rdbms/admin
[oracle@racdbnode1 admin]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Fri May 1 20:35:35 2020

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> @awrinfo.sql
End of Report
Report written to After_awrinfo_Node_1.txt
SQL> exit
*/

--20.
[oracle@racdbnode2 ~]$ cd /opt/app/oracle/product/11.2.0.3/db_1/rdbms/admin/
[oracle@racdbnode2 admin]$ ls | grep awrinfo.sql 
--awrinfo.sql
[oracle@racdbnode2 admin]$ pwd
--/opt/app/oracle/product/11.2.0.3/db_1/rdbms/admin
[oracle@racdbnode1 admin]$ sqlplus / as sysdba
/*
SQL*Plus: Release 11.2.0.3.0 Production on Fri May 1 20:35:35 2020

Copyright (c) 1982, 2011, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Real Application Clusters, Automatic Storage Management, OLAP,
Data Mining and Real Application Testing options

SQL> @awrinfo.sql
End of Report
Report written to After_awrinfo_Node_2.txt
SQL> exit
*/

--21.
SELECT segment_name,segment_type,TRUNC(bytes/1024/1024/1024) gb 
FROM dba_segments 
WHERE segment_name IN ('WRI$_OPTSTAT_HISTHEAD_HISTORY','I_WRI$_OPTSTAT_HH_OBJ_ICOL_ST','I_WRI$_OPTSTAT_HH_ST'); 
/*
SEGMENT_NAME                  SEGMENT_TYPE GB
----------------------------- ------------ --
WRI$_OPTSTAT_HISTHEAD_HISTORY TABLE        0
I_WRI$_OPTSTAT_HH_OBJ_ICOL_ST INDEX        0
I_WRI$_OPTSTAT_HH_ST          INDEX        0
*/

--22.
SELECT occupant_name,schema_name,(space_usage_kbytes/(1024*1024)) gb 
FROM v$sysaux_occupants
ORDER BY 3 desc;
/*
OCCUPANT_NAME            SCHEMA_NAME                      GB
------------------------ ------------------ ----------------
SM/AWR                   SYS                41.7969970703125
SM/OPTSTAT               SYS                   .659912109375
XDB                      XDB                  .2650146484375
SM/ADVISOR               SYS                   .085205078125
SDO                      MDSYS               .06707763671875
EM                       SYSMAN               .0606689453125
ORDIM/ORDDATA            ORDDATA             .02362060546875
LOGMNR                   SYSTEM              .01971435546875
PL/SCOPE                 SYS                    .01806640625
SM/OTHER                 SYS                 .01556396484375
EXPRESSION_FILTER        EXFSYS                .007080078125
WM                       WMSYS                .0047607421875
SQL_MANAGEMENT_BASE      SYS                  .0032958984375
SMON_SCN_TIME            SYS                   .003173828125
EM_MONITORING_USER       DBSNMP              .00311279296875
AO                       SYS                     .0029296875
XSOQHIST                 SYS                     .0029296875
LOGSTDBY                 SYSTEM                .002685546875
STREAMS                  SYS                      .001953125
JOB_SCHEDULER            SYS                    .00146484375
ORDIM                    ORDSYS               .0008544921875
AUTO_TASK                SYS                  .0006103515625
TEXT                     CTXSYS                            0
ULTRASEARCH              WKSYS                             0
AUDIT_TABLES             SYS                               0
TSM                      TSMSYS                            0
XSAMD                    OLAPSYS                           0
ORDIM/SI_INFORMTN_SCHEMA SI_INFORMTN_SCHEMA                0
ORDIM/ORDPLUGINS         ORDPLUGINS                        0
STATSPACK                PERFSTAT                          0
ULTRASEARCH_DEMO_USER    WK_TEST                           0
*/

--23.
SELECT dbms_stats.get_stats_history_retention FROM dual;    
/*
GET_STATS_HISTORY_RETENTION
---------------------------
31
*/

--24.
SELECT dbms_stats.get_stats_history_availability FROM dual;
/*
GET_STATS_HISTORY_AVAILABILITY
------------------------------
25.06.2020 19:29:43.542 +05:45
*/

--25.
SELECT /*+full(t) parallel(8)*/ TRUNC(sysdate)-TRUNC(MIN(savtime)) FROM sys.wri$_optstat_histhead_history t;
/*
TRUNC(SYSDATE)-TRUNC(MIN(SAVTIME))
----------------------------------
1
*/

--26.
EXEC DBMS_STATS.ALTER_STATS_HISTORY_RETENTION(15);

--27.
SELECT dbms_stats.get_stats_history_retention FROM dual;    
/*
GET_STATS_HISTORY_RETENTION
---------------------------
15
*/