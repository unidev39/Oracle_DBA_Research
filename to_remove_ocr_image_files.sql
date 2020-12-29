[root@racdb1 ~]# du -h /opt/ | sort -rh | head -10
/*
41G     /opt/app
41G     /opt/
29G     /opt/app/11.2.0.3/grid
29G     /opt/app/11.2.0.3
24G     /opt/app/11.2.0.3/grid/cdata/RAC-SCAN
24G     /opt/app/11.2.0.3/grid/cdata
12G     /opt/app/oracle
7.4G    /opt/app/oracle/product/11.2.0.3/db_1
7.4G    /opt/app/oracle/product/11.2.0.3
7.4G    /opt/app/oracle/product
*/

/* We are going to erage the ocr image file */

-- Step 1
[root@racdb1 ~]# cd /opt/app/11.2.0.3/grid/bin/
[root@racdb1 bin]# ./crsctl check cluster
/*
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
*/

-- Step 2
[root@racdb1 bin]# ./crsctl check cluster -all
/*
**************************************************************
racdb1:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
racdb2:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
*/

-- Step 3
[oracle@racdb1 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is running on node racdb1
Instance racdb2 is running on node racdb2
*/

-- Step 4
[oracle@racdb1 ~]$ srvctl status listener -l listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): racdb1,racdb2
*/

-- Step 5
[oracle@racdb1 ~]$ srvctl stop database -d racdb
[oracle@racdb1 ~]$ srvctl status database -d racdb
/*
Instance racdb1 is not running on node racdb1
Instance racdb2 is not running on node racdb2
*/

-- Step 6
[root@racdb1 ~]# du -h /opt/ | sort -rh | head -10
/*
41G     /opt/app
41G     /opt/
29G     /opt/app/11.2.0.3/grid
29G     /opt/app/11.2.0.3
24G     /opt/app/11.2.0.3/grid/cdata/RAC-SCAN
24G     /opt/app/11.2.0.3/grid/cdata
12G     /opt/app/oracle
7.4G    /opt/app/oracle/product/11.2.0.3/db_1
7.4G    /opt/app/oracle/product/11.2.0.3
7.4G    /opt/app/oracle/product
*/

-- Step 7
[root@racdb1 ~]# cd /opt/app/11.2.0.3/grid/bin/
[root@racdb1 bin]# ./ocrconfig -showbackup
[root@racdb1 bin]# ./ocrconfig -manualbackup
[root@racdb1 bin]# ./ocrconfig -showbackup

-- Step 8
[root@racdb1 ~]# cd /opt/app/11.2.0.3/grid/bin/
[root@racdb1 bin]# ./crsctl stop cluster -all
[root@racdb1 bin]# ./crsctl check cluster -all

-- Step 9
[root@racdb1 ~]# cd /opt/app/11.2.0.3/grid/cdata/RAC-SCAN
[root@racdb1 bin]# tar --remove-files -czf node1_ocr_image.ocr.tar.gz -i [0-9]*.ocr

-- Step 10
[root@racdb1 ~]# cd /opt/app/11.2.0.3/grid/bin/
[root@racdb1 bin]# ./crsctl start crs
[root@racdb1 bin]# ./crsctl stat res -t
[root@racdb1 bin]# ./crsctl check cluster
/*
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
*/

-- Step 11
[root@racdb2 ~]# cd /opt/app/11.2.0.3/grid/bin/
[root@racdb2 bin]# ./crsctl start crs
[root@racdb2 bin]# ./crsctl stat res -t
[root@racdb2 bin]# ./crsctl check cluster
/*
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
*/

-- Step 12
[root@racdb1 bin]# ./crsctl check cluster -all
/*
**************************************************************
racdb1:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
racdb2:
CRS-4537: Cluster Ready Services is online
CRS-4529: Cluster Synchronization Services is online
CRS-4533: Event Manager is online
**************************************************************
*/

-- Step 13
[root@racdb1 ~]# du -h /opt/ | sort -rh | head -10 
[root@racdb1 ~]# cd /opt/app/11.2.0.3/grid/cdata/RAC-SCAN
[root@racdb1 RAC-SCAN]# ls
--[root@racdb1 RAC-SCAN]# rm -rf node1_ocr_image.ocr.tar.gz
--[root@racdb1 RAC-SCAN]# tar -xf node1_ocr_image.ocr.tar.gz

-- Step 14
[oracle@racdb1 ~]$ srvctl start database -d  racdb
[oracle@racdb1 ~]$ srvctl status database -d  racdb
/*
Instance racdb1 is running on node racdb1
Instance racdb2 is running on node racdb2
*/

-- Step 15
[oracle@racdb1 ~]$ srvctl status listener -l listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): racdb1,racdb2
*/