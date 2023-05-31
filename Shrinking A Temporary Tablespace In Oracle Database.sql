--Shrinking A Temporary Tablespace In Oracle Database

--Step 1 (To Find the Free Space)
SELECT tablespace_name,
       SUM(tablespace_size)/1024/1024  total_size_in_mb,
       SUM(allocated_space )/1024/1024 used_space_in_mb,
       SUM(free_space)/1024/1024       space_free_in_mb 
FROM dba_temp_free_space
GROUP BY tablespace_name,tablespace_size,allocated_space,free_space;

--Step 2: (To Check the Temp Tablespace DataFile file_name,status,autoextensible and script)
SELECT 'ALTER TABLESPACE TEMP01 SHRINK TEMPFILE '''||FILE_NAME||''' KEEP 512M; ',file_name,status,autoextensible FROM dba_temp_files a;

--Step 3: (Run the Script for Specific temfile name)
ALTER TABLESPACE TEMP01 SHRINK TEMPFILE '+DATA/database/tempfile/temp01.567.1234567891' KEEP 512M;
ALTER TABLESPACE TEMP01 SHRINK TEMPFILE '+DATA/database/tempfile/temp01.568.1234567891' KEEP 512M;
ALTER TABLESPACE TEMP01 SHRINK TEMPFILE '+DATA/database/tempfile/temp01.569.1234567891' KEEP 512M;
ALTER TABLESPACE TEMP01 SHRINK TEMPFILE '+DATA/database/tempfile/temp01.579.1234567891' KEEP 512M;

--OR--
--Step 4: (Run the Script for Temp Tablespace DataFile)
ALTER TABLESPACE TEMP01 SHRINK SPACE KEEP 512M;
ALTER TABLESPACE TEMP01 SHRINK SPACE;

