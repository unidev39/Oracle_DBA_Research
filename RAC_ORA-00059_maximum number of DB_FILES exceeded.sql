--Live Production DC - db_files
--Resolution for ORA-00059
/*
ORA-00059: maximum number of DB_FILES exceeded
ORA-06512: at line 5
*/

--Before
SELECT * FROM v$parameter WHERE name ='db_files';
/*
 NUM NAME     TYPE VALUE DISPLAY_VALUE ISDEFAULT ISSES_MODIFIABLE ISSYS_MODIFIABLE ISINSTANCE_MODIFIABLE ISMODIFIED ISADJUSTED ISDEPRECATED ISBASIC DESCRIPTION              UPDATE_COMMENT      HASH
---- -------- ---- ----- ------------- --------- ---------------- ---------------- --------------------- ---------- ---------- ------------ ------- ------------------------ -------------- ---------
1072 db_files    3 200   200           TRUE      FALSE            FALSE            FALSE                 FALSE      FALSE      FALSE        FALSE   max allowable # db files                314572703
*/


SELECT records_total,records_used FROM v$controlfile_record_section WHERE type = 'DATAFILE';
/*
RECORDS_TOTAL RECORDS_USED
------------- ------------
     1024              200
*/


SELECT type,record_size, records_total , records_used ,first_index , last_index , last_recid  FROM v$controlfile_record_section;

/*
TYPE                         RECORD_SIZE RECORDS_TOTAL RECORDS_USED FIRST_INDEX LAST_INDEX LAST_RECID
---------------------------- ----------- ------------- ------------ ----------- ---------- ----------
DATABASE                             316             1            1           0          0          0
CKPT PROGRESS                       8180            35            0           0          0          0
REDO THREAD                          256            32            2           0          0       1906
REDO LOG                              72           192           13           0          0         81
DATAFILE                             520          1024          200           0          0       8052
FILENAME                             524          4674          237           0          0          0
TABLESPACE                            68          1024           18           0          0         20
TEMPORARY FILENAME                    56          1024           13           0          0        626
RMAN CONFIGURATION                  1108            50            7           0          0       8709
LOG HISTORY                           56          4672         4672         425        424     129196
OFFLINE RANGE                        200          1063            0           0          0          0
ARCHIVED LOG                         584          3136         3136        1545       1544     233020
BACKUP SET                            40          1227         1227         591        590      16541
BACKUP PIECE                         736          4000         4000        3029       3028      80028
BACKUP DATAFILE                      200          4252         4252         857        856     132668
BACKUP REDOLOG                        76          8600         8600        4742       4741     146641
DATAFILE COPY                        736          1000         1000         125        124       1124
BACKUP CORRUPTION                     44          1115            0           0          0          0
COPY CORRUPTION                       40          1227            0           0          0          0
DELETED OBJECT                        20         11680        11680        8012       8011     289149
PROXY COPY                           928          1004            0           0          0          0
BACKUP SPFILE                        124           131          131          16         15       6696
DATABASE INCARNATION                  56           292            1           1          1          1
FLASHBACK LOG                         84          2048            0           0          0          0
RECOVERY DESTINATION                 180             1            1           0          0          0
INSTANCE SPACE RESERVATION            28          1055            2           0          0          0
REMOVABLE RECOVERY FILES              32          1000            1           0          0          0
RMAN STATUS                          116           511          511         141        140      23276
THREAD INSTANCE NAME MAPPING          80            32           32           0          0          0
MTTR                                 100            32            2           0          0          0
DATAFILE HISTORY                     568            57            0           0          0          0
STANDBY DATABASE MATRIX              400            31           31           0          0          0
GUARANTEED RESTORE POINT             212          2048            0           0          0          0
RESTORE POINT                        212          2083            0           0          0          0
DATABASE BLOCK CORRUPTION             80          8384            0           0          0          0
ACM OPERATION                        104            64            6           0          0          0
FOREIGN ARCHIVED LOG                 604          1002            0           0          0          0
*/

[oracle@racinv1 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is running on node racinv1
Instance racdb2 is running on node racinv2
*/

--Live Production DR - db_files
[oracle@drracinv1 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is running on node drracinv1
Instance racdb2 is running on node drracinv2
*/

SELECT * FROM v$parameter WHERE name ='db_files';
/*
 NUM NAME     TYPE VALUE DISPLAY_VALUE ISDEFAULT ISSES_MODIFIABLE ISSYS_MODIFIABLE ISINSTANCE_MODIFIABLE ISMODIFIED ISADJUSTED ISDEPRECATED ISBASIC DESCRIPTION              UPDATE_COMMENT      HASH
---- -------- ---- ----- ------------- --------- ---------------- ---------------- --------------------- ---------- ---------- ------------ ------- ------------------------ -------------- ---------
1072 db_files    3 200   200           TRUE      FALSE            FALSE            FALSE                 FALSE      FALSE      FALSE        FALSE   max allowable # db files                314572703
*/


SELECT records_total,records_used FROM v$controlfile_record_section WHERE type = 'DATAFILE';
/*
RECORDS_TOTAL RECORDS_USED
------------- ------------
     1024              200
*/


SELECT type,record_size, records_total , records_used ,first_index , last_index , last_recid  FROM v$controlfile_record_section;
/*
TYPE                         RECORD_SIZE RECORDS_TOTAL RECORDS_USED FIRST_INDEX LAST_INDEX LAST_RECID
---------------------------- ----------- ------------- ------------ ----------- ---------- ----------
DATABASE                             316             1            1           0          0          0
CKPT PROGRESS                       8180            35            0           0          0          0
REDO THREAD                          256            32            2           0          0       1846
REDO LOG                              72           192           13           0          0        135
DATAFILE                             520          1024          200           0          0       9154
FILENAME                             524          4674          240           0          0          0
TABLESPACE                            68          1024           18           0          0         20
TEMPORARY FILENAME                    56          1024           12           0          0         61
RMAN CONFIGURATION                  1108            50            7           0          0       3531
LOG HISTORY                           56          4672         4672         444        443     129215
OFFLINE RANGE                        200          1063            0           0          0          0
ARCHIVED LOG                         584          3136         3136        1874       1873      86545
BACKUP SET                            40          1227         1227         994        993       4674
BACKUP PIECE                         736          4000         4000        3747       3746      56746
BACKUP DATAFILE                      200          1063         1063         169        168      18239
BACKUP REDOLOG                        76          8600         8600        6014       6013      53313
DATAFILE COPY                        736          1000          960           1        960        960
BACKUP CORRUPTION                     44          1115            0           0          0          0
COPY CORRUPTION                       40          1227           14           1         14         14
DELETED OBJECT                        20         11680        11680        1176       1175     247273
PROXY COPY                           928          1004            0           0          0          0
BACKUP SPFILE                        124           131          131          69         68       1902
DATABASE INCARNATION                  56           292            7           1          7          7
FLASHBACK LOG                         84          2048           17           0          0          0
RECOVERY DESTINATION                 180             1            1           0          0          0
INSTANCE SPACE RESERVATION            28          1055            2           0          0          0
REMOVABLE RECOVERY FILES              32          1000            0           0          0          0
RMAN STATUS                          116           511          511          42         41      30331
THREAD INSTANCE NAME MAPPING          80            32           32           0          0          0
MTTR                                 100            32            2           0          0          0
DATAFILE HISTORY                     568            57            0           0          0          0
STANDBY DATABASE MATRIX              400            31           31           0          0          0
GUARANTEED RESTORE POINT             212          2048            1           0          0         12
RESTORE POINT                        212          2083            0           0          0          0
DATABASE BLOCK CORRUPTION             80          8384          356           1        356        356
ACM OPERATION                        104            64            6           0          0          0
FOREIGN ARCHIVED LOG                 604          1002            0           0          0          0
*/

-- Deploy In Live Production DC - db_files
SQL> create pfile='/home/oracle/spfileracdb.ora' from spfile;

SQL> !ls -ll | grep spfile
/*
-rw-r--r--. 1 oracle asmadmin   2429 Nov 13 10:22 spfileracdb.ora
-rw-r--r--. 1 oracle asmadmin   2249 Dec 25  2020 spfileracdb.ora.backup
*/

SQL> show parameter db_files
/*
NAME                                 TYPE                             VALUE
------------------------------------ -------------------------------- ------------------------------
db_files                             integer                          200
*/

SQL> alter system set db_files=500 scope=spfile sid='*';

-- Deploy In Live Production DR - db_files
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;

-- Resume Deploy In Live Production DC - db_files
[oracle@racinv1 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is running on node racinv1
Instance racdb2 is running on node racinv2
*/

[oracle@racinv1 ~]$ srvctl stop database -d racdb
[oracle@racinv1 ~]$ srvctl start database -d racdb
[oracle@racinv1 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is running on node racinv1
Instance racdb2 is running on node racinv2
*/

SQL>  show parameter db_files
/*
NAME                                 TYPE                             VALUE
------------------------------------ -------------------------------- ------------------------------
db_files                             integer                          500
*/

SQL> SELECT * FROM v$parameter WHERE name ='db_files';
/*
 NUM NAME     TYPE VALUE DISPLAY_VALUE ISDEFAULT ISSES_MODIFIABLE ISSYS_MODIFIABLE ISINSTANCE_MODIFIABLE ISMODIFIED ISADJUSTED ISDEPRECATED ISBASIC DESCRIPTION              UPDATE_COMMENT      HASH
---- -------- ---- ----- ------------- --------- ---------------- ---------------- --------------------- ---------- ---------- ------------ ------- ------------------------ -------------- ---------
1072 db_files    3 500   500           FALSE      FALSE            FALSE            FALSE                 FALSE      FALSE      FALSE        FALSE   max allowable # db files                314572703
*/

SELECT records_total,records_used FROM v$controlfile_record_section WHERE type = 'DATAFILE';
/*
RECORDS_TOTAL RECORDS_USED
------------- ------------
     1024              200
*/

SELECT type,record_size, records_total , records_used ,first_index , last_index , last_recid  FROM v$controlfile_record_section;

/*
TYPE                         RECORD_SIZE RECORDS_TOTAL RECORDS_USED FIRST_INDEX LAST_INDEX LAST_RECID
---------------------------- ----------- ------------- ------------ ----------- ---------- ----------
DATABASE                             316             1            1           0          0          0
CKPT PROGRESS                       8180            35            0           0          0          0
REDO THREAD                          256            32            2           0          0       1906
REDO LOG                              72           192           13           0          0         81
DATAFILE                             520          1024          200           0          0       8052
FILENAME                             524          4674          237           0          0          0
TABLESPACE                            68          1024           18           0          0         20
TEMPORARY FILENAME                    56          1024           13           0          0        626
RMAN CONFIGURATION                  1108            50            7           0          0       8709
LOG HISTORY                           56          4672         4672         430        429     129201
OFFLINE RANGE                        200          1063            0           0          0          0
ARCHIVED LOG                         584          3136         3136        1555       1554     233030
BACKUP SET                            40          1227         1227         591        590      16541
BACKUP PIECE                         736          4000         4000        3029       3028      80028
BACKUP DATAFILE                      200          4252         4252         857        856     132668
BACKUP REDOLOG                        76          8600         8600        4742       4741     146641
DATAFILE COPY                        736          1000         1000         125        124       1124
BACKUP CORRUPTION                     44          1115            0           0          0          0
COPY CORRUPTION                       40          1227            0           0          0          0
DELETED OBJECT                        20         11680        11680        8012       8011     289149
PROXY COPY                           928          1004            0           0          0          0
BACKUP SPFILE                        124           131          131          16         15       6696
DATABASE INCARNATION                  56           292            1           1          1          1
FLASHBACK LOG                         84          2048            0           0          0          0
RECOVERY DESTINATION                 180             1            1           0          0          0
INSTANCE SPACE RESERVATION            28          1055            2           0          0          0
REMOVABLE RECOVERY FILES              32          1000            3           0          0          0
RMAN STATUS                          116           511          511         141        140      23276
THREAD INSTANCE NAME MAPPING          80            32           32           0          0          0
MTTR                                 100            32            2           0          0          0
DATAFILE HISTORY                     568            57            0           0          0          0
STANDBY DATABASE MATRIX              400            31           31           0          0          0
GUARANTEED RESTORE POINT             212          2048            0           0          0          0
RESTORE POINT                        212          2083            0           0          0          0
DATABASE BLOCK CORRUPTION             80          8384            0           0          0          0
ACM OPERATION                        104            64            6           0          0          0
FOREIGN ARCHIVED LOG                 604          1002            0           0          0          0
*/

-- Deploy In Live Production DR - db_files
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;

SQL> SELECT inst_id,process,thread#,sequence#,status FROM gv$managed_standby;
/*
   INST_ID PROCESS      THREAD#  SEQUENCE# STATUS
---------- --------- ---------- ---------- ------------
         1 ARCH               1      62495 CLOSING
         1 ARCH               0          0 CONNECTED
         1 ARCH               2      66698 CLOSING
         1 ARCH               1      62496 CLOSING
         1 ARCH               2      66704 CLOSING
         1 ARCH               2      66697 CLOSING
         1 ARCH               2      66705 CLOSING
         1 ARCH               2      66703 CLOSING
         1 RFS                2      66706 IDLE
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 MRP0               1      62503 APPLYING_LOG
         2 ARCH               1      62502 CLOSING
         2 ARCH               0          0 CONNECTED
         2 ARCH               1      62497 CLOSING
         2 ARCH               1      62498 CLOSING
         2 ARCH               2      66702 CLOSING
         2 ARCH               1      62499 CLOSING
         2 ARCH               1      62500 CLOSING
         2 ARCH               1      62501 CLOSING
         2 RFS                0          0 IDLE
         2 RFS                0          0 IDLE
         2 RFS                1      62503 IDLE
         2 RFS                0          0 IDLE
         2 RFS                0          0 IDLE
         2 RFS                0          0 IDLE
         2 RFS                0          0 IDLE
         2 RFS                0          0 IDLE
         2 RFS                0          0 IDLE
         2 RFS                0          0 IDLE
         2 RFS                0          0 IDLE
         2 RFS                0          0 IDLE
         2 RFS                0          0 IDLE
         2 RFS                0          0 IDLE
         2 RFS                0          0 IDLE
         2 RFS                0          0 IDLE
         2 RFS                0          0 IDLE
         2 RFS                0          0 IDLE
         2 RFS                0          0 IDLE
*/

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;
/*
no rows selected
*/

SQL> SELECT * FROM gv$archive_gap;
/*
no rows selected
*/

-- Deploy In Live Production DR - db_files

[oracle@drracinv1 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is running on node drracinv1
Instance racdb2 is running on node drracinv2
*/

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;

SQL> create pfile='/home/oracle/spfileracdb.ora' from spfile;

SQL> !ls -ll | grep spfile
/*
-rw-r--r--. 1 oracle asmadmin   2262 Nov 13 10:39 spfileracdb.ora
-rw-r--r--. 1 oracle oinstall   2110 Dec 25  2020 spfileracdb.ora.backup
*/

SQL> show parameter db_files
/*
NAME                                 TYPE                             VALUE
------------------------------------ -------------------------------- ------------------------------
db_files                             integer                          200
*/

SQL> alter system set db_files=500 scope=spfile sid='*';

[oracle@drracinv1 ~]$ srvctl stop database -d racdb
[oracle@drracinv1 ~]$ srvctl start database -d racdb -o mount
[oracle@drracinv1 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is running on node drracinv1
Instance racdb2 is running on node drracinv2
*/


SQL> SELECT a.inst_id,b.status,b.instance_name,a.database_role,a.open_mode FROM gv$database a,v$instance b;
/*
   INST_ID STATUS       INSTANCE_NAME    DATABASE_ROLE    OPEN_MODE
---------- ------------ ---------------- ---------------- --------------------
         1 MOUNTED      racdb1         PHYSICAL STANDBY MOUNTED
         2 MOUNTED      racdb2         PHYSICAL STANDBY MOUNTED
*/

SQL> show parameter db_files
/*
NAME                                 TYPE                             VALUE
------------------------------------ -------------------------------- ------------------------------
db_files                             integer                          500
*/

SELECT * FROM v$parameter WHERE name ='db_files';
/*
 NUM NAME     TYPE VALUE DISPLAY_VALUE ISDEFAULT ISSES_MODIFIABLE ISSYS_MODIFIABLE ISINSTANCE_MODIFIABLE ISMODIFIED ISADJUSTED ISDEPRECATED ISBASIC DESCRIPTION              UPDATE_COMMENT      HASH
---- -------- ---- ----- ------------- --------- ---------------- ---------------- --------------------- ---------- ---------- ------------ ------- ------------------------ -------------- ---------
1072 db_files    3 500   500           FALSE      FALSE            FALSE            FALSE                 FALSE      FALSE      FALSE        FALSE   max allowable # db files                314572703
*/

SELECT records_total,records_used FROM v$controlfile_record_section WHERE type = 'DATAFILE';
/*
RECORDS_TOTAL RECORDS_USED
------------- ------------
     1024              200
*/

SELECT type,record_size, records_total , records_used ,first_index , last_index , last_recid  FROM v$controlfile_record_section;
/*
TYPE                         RECORD_SIZE RECORDS_TOTAL RECORDS_USED FIRST_INDEX LAST_INDEX LAST_RECID
---------------------------- ----------- ------------- ------------ ----------- ---------- ----------
DATABASE                             316             1            1           0          0          0
CKPT PROGRESS                       8180            35            0           0          0          0
REDO THREAD                          256            32            2           0          0       1846
REDO LOG                              72           192           13           0          0        135
DATAFILE                             520          1024          200           0          0       9154
FILENAME                             524          4674          240           0          0          0
TABLESPACE                            68          1024           18           0          0         20
TEMPORARY FILENAME                    56          1024           12           0          0         61
RMAN CONFIGURATION                  1108            50            7           0          0       3531
LOG HISTORY                           56          4672         4672         454        453     129225
OFFLINE RANGE                        200          1063            0           0          0          0
ARCHIVED LOG                         584          3136         3136        1884       1883      86555
BACKUP SET                            40          1227         1227         994        993       4674
BACKUP PIECE                         736          4000         4000        3747       3746      56746
BACKUP DATAFILE                      200          1063         1063         169        168      18239
BACKUP REDOLOG                        76          8600         8600        6014       6013      53313
DATAFILE COPY                        736          1000          960           1        960        960
BACKUP CORRUPTION                     44          1115            0           0          0          0
COPY CORRUPTION                       40          1227           14           1         14         14
DELETED OBJECT                        20         11680        11680        1176       1175     247273
PROXY COPY                           928          1004            0           0          0          0
BACKUP SPFILE                        124           131          131          69         68       1902
DATABASE INCARNATION                  56           292            7           1          7          7
FLASHBACK LOG                         84          2048           17           0          0          0
RECOVERY DESTINATION                 180             1            1           0          0          0
INSTANCE SPACE RESERVATION            28          1055            2           0          0          0
REMOVABLE RECOVERY FILES              32          1000            0           0          0          0
RMAN STATUS                          116           511          511          42         41      30331
THREAD INSTANCE NAME MAPPING          80            32           32           0          0          0
MTTR                                 100            32            2           0          0          0
DATAFILE HISTORY                     568            57            0           0          0          0
STANDBY DATABASE MATRIX              400            31           31           0          0          0
GUARANTEED RESTORE POINT             212          2048            1           0          0         12
RESTORE POINT                        212          2083            0           0          0          0
DATABASE BLOCK CORRUPTION             80          8384          356           1        356        356
ACM OPERATION                        104            64            6           0          0          0
FOREIGN ARCHIVED LOG                 604          1002            0           0          0          0
*/

SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;

SQL> SELECT inst_id,process,thread#,sequence#,status FROM gv$managed_standby;
/*
   INST_ID PROCESS      THREAD#  SEQUENCE# STATUS
---------- --------- ---------- ---------- ------------
         1 ARCH               1      62504 CLOSING
         1 ARCH               1      62506 CLOSING
         1 ARCH               0          0 CONNECTED
         1 ARCH               2      66708 CLOSING
         1 ARCH               1      62507 CLOSING
         1 ARCH               1      62505 CLOSING
         1 ARCH               0          0 CONNECTED
         1 ARCH               2      66709 CLOSING
         1 MRP0               1      62508 APPLYING_LOG
         1 RFS                0          0 IDLE
         1 RFS                1      62508 IDLE
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 RFS                0          0 IDLE
         1 RFS                2      66710 IDLE
         1 RFS                0          0 IDLE
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
         2 ARCH               0          0 CONNECTED
*/

SQL> SELECT DISTINCT error FROM gv$archive_dest_status;
/*
no rows selected
*/

SQL> SELECT * FROM gv$archive_gap;
/*
no rows selected
*/

-- Deploy In Live Production DC - db_files

SQL> ALTER TABLESPACE TBS_SCORING ADD DATAFILE '+DATAP' SIZE 5g AUTOEXTEND ON NEXT 512m MAXSIZE 30g ;
/*
Tablespace altered.
*/

SQL> SELECT records_total,records_used FROM v$controlfile_record_section WHERE type = 'DATAFILE';
/*
RECORDS_TOTAL RECORDS_USED
------------- ------------
     1024              201
*/

SQL> SELECT type,record_size, records_total , records_used ,first_index , last_index , last_recid  FROM v$controlfile_record_section;
/*
TYPE                         RECORD_SIZE RECORDS_TOTAL RECORDS_USED FIRST_INDEX LAST_INDEX LAST_RECID
---------------------------- ----------- ------------- ------------ ----------- ---------- ----------
DATABASE                             316             1            1           0          0          0
CKPT PROGRESS                       8180            35            0           0          0          0
REDO THREAD                          256            32            2           0          0       1906
REDO LOG                              72           192           13           0          0         81
DATAFILE                             520          1024          201           0          0       8053
FILENAME                             524          4674          237           0          0          0
TABLESPACE                            68          1024           18           0          0         20
TEMPORARY FILENAME                    56          1024           13           0          0        626
RMAN CONFIGURATION                  1108            50            7           0          0       8709
LOG HISTORY                           56          4672         4672         445        444     129216
OFFLINE RANGE                        200          1063            0           0          0          0
ARCHIVED LOG                         584          3136         3136        1585       1584     233060
BACKUP SET                            40          1227         1227         591        590      16541
BACKUP PIECE                         736          4000         4000        3029       3028      80028
BACKUP DATAFILE                      200          4252         4252         857        856     132668
BACKUP REDOLOG                        76          8600         8600        4742       4741     146641
DATAFILE COPY                        736          1000         1000         125        124       1124
BACKUP CORRUPTION                     44          1115            0           0          0          0
COPY CORRUPTION                       40          1227            0           0          0          0
DELETED OBJECT                        20         11680        11680        8012       8011     289149
PROXY COPY                           928          1004            0           0          0          0
BACKUP SPFILE                        124           131          131          16         15       6696
DATABASE INCARNATION                  56           292            1           1          1          1
FLASHBACK LOG                         84          2048            0           0          0          0
RECOVERY DESTINATION                 180             1            1           0          0          0
INSTANCE SPACE RESERVATION            28          1055            2           0          0          0
REMOVABLE RECOVERY FILES              32          1000           12           0          0          0
RMAN STATUS                          116           511          511         141        140      23276
THREAD INSTANCE NAME MAPPING          80            32           32           0          0          0
MTTR                                 100            32            2           0          0          0
DATAFILE HISTORY                     568            57            0           0          0          0
STANDBY DATABASE MATRIX              400            31           31           0          0          0
GUARANTEED RESTORE POINT             212          2048            0           0          0          0
RESTORE POINT                        212          2083            0           0          0          0
DATABASE BLOCK CORRUPTION             80          8384            0           0          0          0
ACM OPERATION                        104            64            6           0          0          0
FOREIGN ARCHIVED LOG                 604          1002            0           0          0          0
*/

-- Verify In Live Production DR - db_files
SQL> SELECT type,record_size, records_total , records_used ,first_index , last_index , last_recid  FROM v$controlfile_record_section;
/*
TYPE                         RECORD_SIZE RECORDS_TOTAL RECORDS_USED FIRST_INDEX LAST_INDEX LAST_RECID
---------------------------- ----------- ------------- ------------ ----------- ---------- ----------
DATABASE                             316             1            1           0          0          0
CKPT PROGRESS                       8180            35            0           0          0          0
REDO THREAD                          256            32            2           0          0       1846
REDO LOG                              72           192           13           0          0        135
DATAFILE                             520          1024          201           0          0       9155
FILENAME                             524          4674          240           0          0          0
TABLESPACE                            68          1024           18           0          0         20
TEMPORARY FILENAME                    56          1024           12           0          0         61
RMAN CONFIGURATION                  1108            50            7           0          0       3531
LOG HISTORY                           56          4672         4672         463        462     129234
OFFLINE RANGE                        200          1063            0           0          0          0
ARCHIVED LOG                         584          3136         3136        1893       1892      86564
BACKUP SET                            40          1227         1227         994        993       4674
BACKUP PIECE                         736          4000         4000        3747       3746      56746
BACKUP DATAFILE                      200          1063         1063         169        168      18239
BACKUP REDOLOG                        76          8600         8600        6014       6013      53313
DATAFILE COPY                        736          1000          960           1        960        960
BACKUP CORRUPTION                     44          1115            0           0          0          0
COPY CORRUPTION                       40          1227           14           1         14         14
DELETED OBJECT                        20         11680        11680        1176       1175     247273
PROXY COPY                           928          1004            0           0          0          0
BACKUP SPFILE                        124           131          131          69         68       1902
DATABASE INCARNATION                  56           292            7           1          7          7
FLASHBACK LOG                         84          2048           17           0          0          0
RECOVERY DESTINATION                 180             1            1           0          0          0
INSTANCE SPACE RESERVATION            28          1055            2           0          0          0
REMOVABLE RECOVERY FILES              32          1000            0           0          0          0
RMAN STATUS                          116           511          511          42         41      30331
THREAD INSTANCE NAME MAPPING          80            32           32           0          0          0
MTTR                                 100            32            2           0          0          0
DATAFILE HISTORY                     568            57            0           0          0          0
STANDBY DATABASE MATRIX              400            31           31           0          0          0
GUARANTEED RESTORE POINT             212          2048            1           0          0         12
RESTORE POINT                        212          2083            0           0          0          0
DATABASE BLOCK CORRUPTION             80          8384          356           1        356        356
ACM OPERATION                        104            64            6           0          0          0
FOREIGN ARCHIVED LOG                 604          1002            0           0          0          0
*/