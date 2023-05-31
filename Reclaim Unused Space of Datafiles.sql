--Reclaim Unused Space of Datafiles

--Step 1: (To Find the Database block size)
SELECT value FROM v$parameter WHERE name = 'db_block_size';
/*
VALUE
-----
16384
*/


--Step 2: (To Find how much space can be reclaim) 
SELECT file_name,
       CEIL((NVL(block_id,1)*&&blksize)/1024/1024 ) smallest_in_mb,
       CEIL(blocks*&&blksize/1024/1024) currsize_in_mb,
       CEIL(blocks*&&blksize/1024/1024) - CEIL((NVL(block_id,1)*&&blksize)/1024/1024 ) savings_in_mb
FROM dba_data_files a LEFT JOIN 
     (SELECT file_id, MAX(block_id+blocks-1) block_id
      FROM dba_extents
      GROUP BY file_id ) b
ON (a.file_id = b.file_id)
WHERE  a.tablespace_name ='TBS_BACKUP';

/*
FILE_NAME                                         SMALLEST_IN_MB CURRSIZE_IN_MB SAVINGS_IN_MB
------------------------------------------------- -------------- -------------- -------------
+DATA/database/datafile/tbs_backup.786.1234567897          23617          25088          1471
*/


--Step3: (Script To reclaim unused space from the datafiles)
SELECT 
     'ALTER DATABASE DATAFILE '''||file_name||''' RESIZE ' || CEIL((NVL(block_id,1)*&&blksize)/1024/1024 )||'m;' script
FROM dba_data_files a LEFT JOIN 
     (SELECT file_id, MAX(block_id+blocks-1) block_id
      FROM dba_extents
      GROUP BY file_id ) b
ON (a.file_id = b.file_id) 
WHERE (CEIL(blocks*&&blksize/1024/1024) - CEIL((NVL(block_id,1)*&&blksize)/1024/1024 ) > 0)
AND a.tablespace_name ='TBS_BACKUP';

/*
SCRIPT
------------------------------------------------------------------------------------------
ALTER DATABASE DATAFILE '+DATA/database/datafile/tbs_backup.786.1234567897' RESIZE 23617m;
*/