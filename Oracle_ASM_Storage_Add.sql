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


