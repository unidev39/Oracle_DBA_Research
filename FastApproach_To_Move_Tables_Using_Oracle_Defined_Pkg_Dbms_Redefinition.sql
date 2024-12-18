--0 To Prepare the Test Environment
CREATE TABLESPACE tbs_source 
DATAFILE 'C:\APP\ADMINISTRATOR\ORADATA\ORCL\tbs_source.dbf'
SIZE 10m;

CREATE TABLESPACE tbs_dest 
DATAFILE 'C:\APP\ADMINISTRATOR\ORADATA\ORCL\tbs_dest.dbf'
SIZE 10m;

CREATE USER sourceuser IDENTIFIED BY oracle 
DEFAULT TABLESPACE tbs_source
QUOTA UNLIMITED ON tbs_source;

CREATE USER destuser IDENTIFIED BY oracle 
DEFAULT TABLESPACE tbs_dest
QUOTA UNLIMITED ON tbs_dest;

GRANT CONNECT,RESOURCE TO sourceuser;
GRANT CONNECT,RESOURCE TO destuser;

CREATE TABLE sourceuser.orignal_table TABLESPACE tbs_source
AS
SELECT 
     LEVEL sn
FROM dual
CONNECT BY LEVEL <= 10000;

--1 To Create The Interim Table In The Desired Tablespace
CREATE TABLE destuser.interim_table PARTITION BY RANGE (sn)
(PARTITION dummy VALUES less than (-1),PARTITION t1 VALUES LESS THAN (MAXVALUE)) TABLESPACE tbs_dest
AS 
SELECT * FROM sourceuser.orignal_table WHERE ROWNUM <1;

CREATE TABLE destuser.orignal_table TABLESPACE tbs_dest
AS
SELECT * FROM sourceuser.orignal_table WHERE ROWNUM <1;

--2 To verify the tables storage and data
SELECT owner,table_name,tablespace_name FROM dba_tables WHERE table_name IN ('ORIGNAL_TABLE','INTERIM_TABLE');
/*
OWNER      TABLE_NAME    TABLESPACE_NAME
---------- ------------- ---------------
SOURCEUSER ORIGNAL_TABLE TBS_SOURCE     
DESTUSER   ORIGNAL_TABLE TBS_DEST       
DESTUSER   INTERIM_TABLE                
*/

SELECT 'SOURCEUSER.ORIGNAL_TABLE' table_name, Count(*) row_count FROM SOURCEUSER.ORIGNAL_TABLE UNION ALL 
SELECT 'DESTUSER.ORIGNAL_TABLE' table_name, Count(*) row_count FROM DESTUSER.ORIGNAL_TABLE UNION ALL
SELECT 'DESTUSER.INTERIM_TABLE' table_name, Count(*) row_count FROM DESTUSER.INTERIM_TABLE; 
/*
TABLE_NAME               ROW_COUNT
------------------------ ---------
SOURCEUSER.ORIGNAL_TABLE     10000
DESTUSER.ORIGNAL_TABLE         0
DESTUSER.INTERIM_TABLE         0
*/

--3 To Move into Destination Schema
ALTER TABLE destuser.interim_table exchange PARTITION dummy WITH TABLE sourceuser.orignal_table iNCLUDING INDEXES WITHOUT VALIDATION;
ALTER TABLE destuser.interim_table exchange PARTITION dummy WITH TABLE destuser.orignal_table INCLUDING INDEXES WITHOUT VALIDATION;

--4 To verify the tables storage and data
SELECT owner,table_name,tablespace_name FROM dba_tables WHERE table_name IN ('ORIGNAL_TABLE','INTERIM_TABLE');
/*
OWNER      TABLE_NAME    TABLESPACE_NAME
---------- ------------- ---------------
DESTUSER   ORIGNAL_TABLE TBS_SOURCE     
SOURCEUSER ORIGNAL_TABLE TBS_DEST       
DESTUSER   INTERIM_TABLE                      
*/

SELECT 'SOURCEUSER.ORIGNAL_TABLE' table_name, Count(*) row_count FROM SOURCEUSER.ORIGNAL_TABLE UNION ALL 
SELECT 'DESTUSER.ORIGNAL_TABLE' table_name, Count(*) row_count FROM DESTUSER.ORIGNAL_TABLE UNION ALL
SELECT 'DESTUSER.INTERIM_TABLE' table_name, Count(*) row_count FROM DESTUSER.INTERIM_TABLE; 
/*
TABLE_NAME               ROW_COUNT
------------------------ ---------
SOURCEUSER.ORIGNAL_TABLE         0
DESTUSER.ORIGNAL_TABLE       10000
DESTUSER.INTERIM_TABLE           0
*/


--5 To Define a Integrity Constant (Temporary)
ALTER TABLE destuser.orignal_table ADD CONSTRAINT pk_record_id PRIMARY KEY (sn);

--6 To Determine If The Redefinition Can Be Done
EXEC Dbms_Redefinition.Can_Redef_Table('DESTUSER','ORIGNAL_TABLE');

--7 To Create The Interim Table In The Desired Tablespace
CREATE TABLE destuser.orignal_table_tpm  TABLESPACE tbs_dest
AS
SELECT * FROM destuser.orignal_table WHERE ROWNUM <1;

--8 To Start The Redefinition
EXEC dbms_redefinition.start_redef_table('DESTUSER','ORIGNAL_TABLE','ORIGNAL_TABLE_TPM');

--9 To Copy The Table Dependents From The Original Table To The Interim Table
DECLARE
   error_count pls_integer := 0;
BEGIN
    DBMS_REDEFINITION.COPY_TABLE_DEPENDENTS('DESTUSER', 'ORIGNAL_TABLE', 'ORIGNAL_TABLE_TPM', dbms_redefinition.cons_orig_params, TRUE,TRUE,TRUE,FALSE, error_count);
    dbms_output.put_line('errors := ' || TO_CHAR(error_count));
END;
/

--10 To Do One Final Synchronize Before Finishing The Redefinition
EXEC DBMS_REDEFINITION.SYNC_INTERIM_TABLE('DESTUSER', 'ORIGNAL_TABLE', 'ORIGNAL_TABLE_TPM');

--11 To Finish The Redefinition
EXEC dbms_redefinition.finish_redef_table('DESTUSER','ORIGNAL_TABLE', 'ORIGNAL_TABLE_TPM');

--12 To Drop The Interim Tables
DROP TABLE destuser.orignal_table_tpm PURGE;
DROP TABLE sourceuser.orignal_table PURGE;
DROP TABLE destuser.interim_table  PURGE;

--13 To verify the tables storage and data
SELECT owner,table_name,tablespace_name FROM dba_tables WHERE table_name IN ('ORIGNAL_TABLE');
/*
OWNER      TABLE_NAME        TABLESPACE_NAME
---------- ----------------- ---------------
DESTUSER   ORIGNAL_TABLE     TBS_DEST
*/

SELECT 'DESTUSER.ORIGNAL_TABLE' table_name, Count(*) row_count FROM DESTUSER.ORIGNAL_TABLE;
/*
TABLE_NAME               ROW_COUNT
------------------------ ---------
DESTUSER.ORIGNAL_TABLE       10000
*/  
