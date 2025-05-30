-- For ASMLiB

1. Create Disk in SAN Storage and mapping in appropriate location
2. Reboot the relevent server
   OR
   Use below commads to reflect partition without rebooting server:
   
   cat /proc/scsi/scsi | egrep –I ‘Host:’ | wc -l
   /*
   30
   */
   /usr/bin/rescan-scsi-bus.sh
   cat /proc/scsi/scsi | egrep –I ‘Host:’ | wc -l
   /*
   34
   */
3.[root@rac1 ~]# multipath -ll
/*
mpathg (360080e50003e06c4000013665ddf25f3) dm-5 IBM,1746 FAStT
size=40G features='3 queue_if_no_path pg_init_retries 50' hwhandler='1 rdac' wp=rw
`-+- policy='round-robin 0' prio=11 status=active
|- 3:0:0:5 sdg 8:96 active ready running
|- 4:0:0:5 sds 65:32 active ready running
|- 3:0:1:5 sdm 8:192 active ready running
`- 4:0:1:5 sdy 65:128 active ready running
*/

4. Add configuration in file /etc/multipath.conf
[root@rac1 ~]# vi /etc/multipath.conf
/*
multipath {
wwid 360080e50003e06c4000013665ddf25f3
alias data2_1
}
*/

5. Restart multipath service
[root@rac1 ~]# /etc/init.d/multipathd restart

6. [root@rac1 ~]# multipath -ll
/*
data2_1 (360080e50003e06c4000013665ddf25f3) dm-9 IBM,1746 FAStT
size=40G features='3 queue_if_no_path pg_init_retries 50' hwhandler='1 rdac' wp=rw
`-+- policy='round-robin 0' prio=11 status=active
|- 3:0:0:6 sdh 8:112 active ready running
|- 3:0:1:6 sdp 8:240 active ready running
|- 4:0:0:6 sdx 65:112 active ready running
`- 4:0:1:6 sdaf 65:240 active ready running
*/

7. [root@rac1 ~]# fdisk -l
8. [root@rac1 ~]# fdisk /dev/mapper/data2_1
/*
p
n
p
1
Enter
Enter
p 
w (write)
*/

9. [root@rac1 ~]# fdisk /dev/mapper/data2_1
/*
p (Check on both relevent Servers)
*/

10. [root@rac1 ~]# partprobe /dev/mapper/data2_1 

11. [root@rac1 ~]# fdisk -l
/*
Disk /dev/mapper/data2_1p1: 42.9 GB, 42944154624 bytes
255 heads, 63 sectors/track, 5220 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000
*/

-- After Adding disk
/*
fdisk -l /dev/sdy
fdisk /dev/sdy
https://oracleracdba1.wordpress.com/2012/10/12/how-to-add-disk-to-asm/
https://dbatricksworld.com/how-to-add-disk-to-asm-diskgroup-in-oracle-11g/
*/

-- Login as root user then issue the commnad
[root@rac1 ~]# /etc/init.d/oracleasm createdisk DATA_PRD2_1 /dev/mapper/data2_1p1
/*
Marking disk "DATA_PRD2_1" as an ASM disk:                      [  OK  ]
*/

-- Do scandisk on the all the nodes
[root@rac1 ~]# /etc/init.d/oracleasm scandisks
[root@rac1 ~]# /etc/init.d/oracleasm listdisk

[root@rac2 ~]# /etc/init.d/oracleasm scandisks
[root@rac2 ~]# /etc/init.d/oracleasm listdisk

-- The Location of created disks to add in ASM
[root@rac1 ~]# cd /dev/oracleasm/disks
[root@rac1 ~]# ls
/*
DATA_PRD2
DATA_PRD2_1
*/

-- Login as grid user then issue the commnad from sqlplus / as sysasm
-- First we identify the ASM diskgroup where we want to add the disk
col group_number for a60
select
   group_number,
   name
from
   v$asm_diskgroup;

-- Next, we identify the disks to see which disk should be added to the disk:
col path for a60
SELECT path,header_status,state FROM v$asm_disk;

-- Now, we can add the disk to the ASM diskgroup:
ALTER DISKGROUP DATA2 ADD DISK '/dev/oracleasm/disks/DATA_PRD2_1' NAME DATA_PRD2_1;
--Or--
/*
set lines 200;
col path format a40;
select name,path, group_number group_#, disk_number disk_#, mount_status,header_status, state, total_mb, free_mb from v$asm_disk order by group_number;

NAME                           PATH                                        GROUP_#     DISK_# MOUNT_S HEADER_STATU STATE      TOTAL_MB    FREE_MB
------------------------------ ---------------------------------------- ---------- ---------- ------- ------------ -------- ---------- ----------
                               ORCL:DATA_PRD2_1                                  0          0 CLOSED  PROVISIONED  NORMAL            0          0
ARC                            ORCL:ARC1                                         1          0 CACHED  MEMBER       NORMAL       204796     189930
DATA2                          ORCL:DATA2                                        2          0 CACHED  MEMBER       NORMAL       819197     148294
DATA1                          ORCL:DATA1                                        3          0 CACHED  MEMBER       NORMAL      1535992         60
FRA                            ORCL:FRA1                                         4          0 CACHED  MEMBER       NORMAL      1023992     538688
OCR                            ORCL:OCR1                                         5          0 CACHED  MEMBER       NORMAL        10236       9873

ALTER DISKGROUP DATA2 ADD DISK 'ORCL:DATA_PRD2_1' NAME DATA_PRD2_1;
*/

-- Next, we identify the disks to see which disk should be added to the diskgroup
col name for a60
SELECT name, total_mb/1024 total_gb, free_mb/1024 free_gb, free_mb/total_mb*100 free_pct FROM v$asm_diskgroup;

-- Next, to view the rebalancing status
col operation for a60
SELECT inst_id, operation, state, power, sofar, est_work, est_rate, est_minutes from GV$ASM_OPERATION;

-- Next, to change the rebalancing status
ALTER DISKGROUP DATA2 rebalance power 11;

-- Next, to view the rebalancing status
col operation for a60
SELECT inst_id, operation, state, power, sofar, est_work, est_rate, est_minutes from GV$ASM_OPERATION;

-- Note: After no rows returned by the query (rebalancing status) then we have to process the data operation over DATA2

-- For Oracle ASM Filter Driver
---------------------------------------------------------------------------------------------------------------
----------------------------------To Add Disks Using Oracle ASM Filter Driver----------------------------------
---------------------------------------------------------------------------------------------------------------
-- Step 1
  Create Disk in SAN Storage and mapping in appropriate location

-- Step 2
   Reboot the relevent server
   OR
   Use below commads to reflect partition without rebooting server:
   
   cat /proc/scsi/scsi | egrep –I ‘Host:’ | wc -l
   /*
   30
   */
   /usr/bin/rescan-scsi-bus.sh
   cat /proc/scsi/scsi | egrep –I ‘Host:’ | wc -l
   /*
   34
   */

-- Step 3 -->> On Both Node
[root@pdb1/pdb2 ~]# fdisk -ll | grep -E "sd"
/*
Disk /dev/sda: 222 GiB, 238370684928 bytes, 465567744 sectors
/dev/sda1  *       2048   4196351   4194304    2G 83 Linux
/dev/sda2       4196352 465567743 461371392  220G 8e Linux LVM
Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
/dev/sdb1        2048 41943039 41940992  20G 83 Linux
Disk /dev/sdc: 200 GiB, 214748364800 bytes, 419430400 sectors
/dev/sdc1        2048 419430399 419428352  200G 83 Linux
Disk /dev/sdd: 400 GiB, 429496729600 bytes, 838860800 sectors
/dev/sdd1        2048 838860799 838858752  400G 83 Linux
Disk /dev/sde: 10 GiB, 10737418240 bytes, 20971520 sectors
*/

-- Step 4  -->> On Node 1
[root@pdb1 ~]# fdisk /dev/sde
/*
Welcome to fdisk (util-linux 2.37.4).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0xfa8997a7.

Command (m for help): p
Disk /dev/sde: 10 GiB, 10737418240 bytes, 20971520 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xfa8997a7

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-20971519, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-20971519, default 20971519):

Created a new partition 1 of type 'Linux' and of size 10 GiB.

Command (m for help): p
Disk /dev/sde: 10 GiB, 10737418240 bytes, 20971520 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xfa8997a7

Device     Boot Start      End  Sectors Size Id Type
/dev/sde1        2048 20971519 20969472  10G 83 Linux

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 5  -->> On Node 1
[root@pdb1 ~]# mkfs.xfs -f /dev/sde1

-- Step 6  -->> On Both Node (If Necessary)
[root@pdb1/pdb2 ~]# partprobe /dev/sde1

-- Step 7  -->> On Both Node
[root@pdb1/pdb2 ~]# lsblk /dev/sde
/*
NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINTS
sde      8:64   0  10G  0 disk
└─sde1   8:65   0  10G  0 part
*/

-- Step 8  -->> On Both Node
[root@pdb1/pdb2 ~]# fdisk -ll | grep -E "sde"
/*
Disk /dev/sde: 10 GiB, 10737418240 bytes, 20971520 sectors
/dev/sde1        2048 20971519 20969472  10G 83 Linux
*/

-- Step 9  -->> On Both Node
[root@pdb1/pdb2 ~]# lsmod | grep oracleafd
/*
oracleafd             290816  52
*/

-- Step 10  -->> On Both Node
[root@pdb1/pdb2 ~]# ll /dev/oracleafd/disks/
/*
-rw-r--r-- 1 grid asmadmin 10 May 18 15:08 ARC
-rw-r--r-- 1 grid asmadmin 10 May 18 15:08 DATA
-rw-r--r-- 1 grid asmadmin 10 May 18 15:08 OCR
*/

-- Step 11  -->> On Both Node
[root@pdb1/pdb2 ~]# ll /dev/oracleafd/disks/*
/*
-rw-r--r-- 1 grid asmadmin 10 May 18 15:08 /dev/oracleafd/disks/ARC
-rw-r--r-- 1 grid asmadmin 10 May 18 15:08 /dev/oracleafd/disks/DATA
-rw-r--r-- 1 grid asmadmin 10 May 18 15:08 /dev/oracleafd/disks/OCR
*/

-- Step 12  -->> On Both Node
[root@pdb1/pdb2 ~]# export ORACLE_HOME=/opt/app/19c/grid
[root@pdb1/pdb2 ~]# export CV_ASSUME_DISTID=OEL7.8
[root@pdb1/pdb2 ~]# export ORACLE_BASE=/opt/app/oracle
[root@pdb1/pdb2 ~]# /opt/app/19c/grid/bin/asmcmd showclustermode
/*
ASM cluster : Flex mode enabled - Direct Storage Access
*/

-- Step 13  -->> On Both Node
[root@pdb1/pdb2 ~]# /opt/app/19c/grid/bin/asmcmd afd_state
/*
ASMCMD-9526: The AFD state is 'LOADED' and filtering is 'DISABLED' on host 'pdb1/pdb2.unidev.org.np'
*/

-- Step 14  -->> On Both Node
[root@pdb1/pdb2 ~]# /opt/app/19c/grid/bin/asmcmd afd_scan
[root@pdb1/pdb2 ~]# /opt/app/19c/grid/bin/asmcmd afd_lslbl
/*
--------------------------------------------------------------------------------
Label                     Duplicate  Path
================================================================================
ARC                                   /dev/sdd1
DATA                                  /dev/sdc1
OCR                                   /dev/sdb1
*/

-- Step 15 -->> On Node 1
[root@pdb1 ~]# /opt/app/19c/grid/bin/asmcmd afd_label DATA01 /dev/sde1
[root@pdb1 ~]# /opt/app/19c/grid/bin/asmcmd afd_scan
[root@pdb1 ~]# /opt/app/19c/grid/bin/asmcmd afd_lslbl
/*
--------------------------------------------------------------------------------
Label                     Duplicate  Path
================================================================================
ARC                                   /dev/sdd1
DATA                                  /dev/sdc1
DATA01                                /dev/sde1
OCR                                   /dev/sdb1
*/

-- Step 16 -->> On Node 2
[root@pdb2 ~]# /opt/app/19c/grid/bin/asmcmd afd_scan
[root@pdb2 ~]# /opt/app/19c/grid/bin/asmcmd afd_lslbl
/*
--------------------------------------------------------------------------------
Label                     Duplicate  Path
================================================================================
ARC                                   /dev/sdd1
DATA                                  /dev/sdc1
DATA01                                /dev/sde1
OCR                                   /dev/sdb1
*/

-- Step 17 -->> On Both Node
[root@pdb1/pdb2 ~]# ll /dev/oracleafd/disks/*
/*
-rw-rw-r-- 1 grid oinstall 10 May 18 15:44 /dev/oracleafd/disks/ARC
-rw-rw-r-- 1 grid oinstall 10 May 18 15:44 /dev/oracleafd/disks/DATA
-rw-rw-r-- 1 grid oinstall 10 May 18 16:05 /dev/oracleafd/disks/DATA01
-rw-rw-r-- 1 grid oinstall 10 May 18 15:44 /dev/oracleafd/disks/OCR
*/

-- Step 18 -->> On Both Node
[root@pdb1/pdb2 ~]# ll /dev/oracleafd/disks/
/*
-rw-rw-r-- 1 grid oinstall 10 May 18 15:44 ARC
-rw-rw-r-- 1 grid oinstall 10 May 18 15:44 DATA
-rw-rw-r-- 1 grid oinstall 10 May 18 16:05 DATA01
-rw-rw-r-- 1 grid oinstall 10 May 18 15:44 OCR
*/

-- Step 19 -->> On Node 1
-- Login as grid user then issue the commnad from sqlplus / as sysasm
-- First we identify the ASM diskgroup where we want to add the disk
[grid@pdb1 ~]$ sqlplus / as sysasm
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Mon May 26 12:13:35 2025
Version 19.27.0.0.0

Copyright (c) 1982, 2024, Oracle.  All rights reserved.

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0

SQL> set linesize 9999
SQL> col group_number for a60
SQL> select
        group_number,
        name
     from
        v$asm_diskgroup;

GROUP_NUMBER NAME
------------ -----
           0
           1 ARC
           2 DATA
           3 OCR

SQL> col path for a60
SQL> SELECT path,header_status,state FROM v$asm_disk;

PATH       HEADER_STATU STATE
---------- ------------ --------
AFD:DATA01 PROVISIONED  NORMAL
AFD:OCR    MEMBER       NORMAL
AFD:ARC    MEMBER       NORMAL
AFD:DATA   MEMBER       NORMAL

SQL> set lines 200;
SQL> col path format a40;
SQL> select name,path, group_number group_#, disk_number disk_#, mount_status,header_status, state, total_mb, free_mb from v$asm_disk order by group_number;

NAME PATH       GROUP_# DISK_# MOUNT_S HEADER_STATU STATE  TOTAL_MB FREE_MB
---- ---------- ------- ------ ------- ------------ ------ -------- -------
     AFD:DATA01       0      0 CLOSED  PROVISIONED  NORMAL        0       0
ARC  AFD:ARC          1      0 CACHED  MEMBER       NORMAL   409599  409256
DATA AFD:DATA         2      0 CACHED  MEMBER       NORMAL   204799  197926
OCR  AFD:OCR          3      0 CACHED  MEMBER       NORMAL    20476   20112

SQL> ALTER DISKGROUP DATA ADD DISK 'AFD:DATA01' NAME DATA01;

Diskgroup altered.

SQL> col name for a60
SQL> SELECT name, total_mb/1024 total_gb, free_mb/1024 free_gb, free_mb/total_mb*100 free_pct FROM v$asm_diskgroup;SQL>

NAME   TOTAL_GB    FREE_GB   FREE_PCT
---- ---------- ---------- ----------
ARC  399.999023 399.664063 99.9162596
DATA 209.998047 203.283203 96.8024256
OCR  19.9960938  19.640625  98.222309

SQL> col operation for a60
SQL> SELECT inst_id, operation, state, power, sofar, est_work, est_rate, est_minutes from GV$ASM_OPERATION;

-- Next, to view the rebalancing status
col operation for a60
SELECT inst_id, operation, state, power, sofar, est_work, est_rate, est_minutes from GV$ASM_OPERATION;

-- Next, to change the rebalancing status
ALTER DISKGROUP DATA rebalance power 11;

-- Next, to view the rebalancing status
col operation for a60
SELECT inst_id, operation, state, power, sofar, est_work, est_rate, est_minutes from GV$ASM_OPERATION;
-- Note: After no rows returned by the query (rebalancing status) then we have to process the data operation over DATA

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.27.0.0.0
*/

-- Step 20 -->> On Both Node
[grid@pdb1/pdb2 ~]$ asmcmd -p
/*
ASMCMD [+] > lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  1048576    409599   409256                0          409256              0             N  ARC/
MOUNTED  EXTERN  N         512             512   4096  1048576    215038   208162                0          208162              0             N  DATA/
MOUNTED  EXTERN  N         512             512   4096  4194304     20476    20112                0           20112              0             Y  OCR/
ASMCMD [+] > exit
*/ 


