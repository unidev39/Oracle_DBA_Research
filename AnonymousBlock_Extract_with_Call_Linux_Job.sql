-- To Create a Directory
CREATE OR REPLACE DIRECTORY DIR_NAME AS '/home/oracle/backup/';
-- To Provide access to directory
GRANT READ,WRITE ON DIRECTORY DIR_NAME TO public;

DECLARE
    -- Declare Variable to Genrate the Extact
    l_inhandler        utl_file.file_type;
    l_outhandle        VARCHAR2(32767);
    TYPE cursor_cr     IS REF cursor;
    l_cursor_cr        cursor_cr;
    l_sql              VARCHAR2(32767);
    l_composit_columns VARCHAR2(500);
    l_msg              VARCHAR2(100);
    l_source_file      VARCHAR2(32);

    -- Declare Variable to Run the Shell Script
    l_job               VARCHAR2(100);
    l_source_path       VARCHAR2(50);
    l_dest_user         VARCHAR2(10);
    l_dest_ip           VARCHAR2(20);
    l_dest_path         VARCHAR2(50);
    l_dest_password     VARCHAR2(10);  
BEGIN
    SELECT 
         'Extract_'||TO_CHAR(SYSDATE,'dd_mm_yyyy')||'.txt'  source_file,
         'oracle'                                           dest_user,
         '192.168.0.122'                                    dest_ip,
         '/home/oracle/backup'                              dest_path,
         'oracle'                                           dest_password,
         '/home/oracle/scripts/scp_extract.sh'              jobs 
         INTO 
            l_source_file,
            l_dest_user,
            l_dest_ip,
            l_dest_path,
            l_dest_password,
            l_job 
    FROM dual;

    -- Block to Generate the Extract
    BEGIN 
        l_inhandler := utl_file.fopen('DIR_NAME',''||l_source_file||'','W');
    
        l_outhandle := 'C1|C2|C3|C4|C5|C6|C7|C8|C9|C10|C11|C12|C13|C14';
        utl_file.put_line(l_inhandler,l_outhandle);
    
        l_sql := 'SELECT
                       a.c1||''|''||a.c2||''|''||a.c3||''|''||a.c4||''|''||a.c5||''|''||a.c6||''|''||a.c7||''|''||a.c8||''|''||a.c9||''|''||a.c10||''|''||a.c11||''|''||a.c12||''|''||a.c13||''|''||a.c14 composit_columns
                  FROM (
                        SELECT 
                             LEVEL     c1,
                             SYSDATE   c2,
                             ''TEST1'' c3,
                             ''TEST''  c4,
                             LEVEL     c5,
                             SYSDATE   c6,
                             ''KTM''   c7,
                             LEVEL     c8,
                             LEVEL     c9,
                             SYSDATE   c10,
                             SYSDATE   c11,
                             ''KTM''   c12,
                             LEVEL     c13,
                             LEVEL     c14
                        FROM dual
                        CONNECT BY LEVEL <= 10
                       ) a';  
            OPEN l_cursor_cr FOR l_sql;
            LOOP
               FETCH l_cursor_cr INTO l_composit_columns;
               EXIT WHEN l_cursor_cr%NOTFOUND;
                  BEGIN
                      utl_file.put_line(l_inhandler,l_composit_columns);
                  END;
            END LOOP;
            CLOSE l_cursor_cr;
            utl_file.fclose(l_inhandler);
    EXCEPTION WHEN NO_DATA_FOUND THEN
        utl_file.fclose(l_inhandler);
    END;

    BEGIN
        BEGIN
            DBMS_SCHEDULER.DROP_JOB('ExtractData');
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
    
        -- Find the Source Path
        BEGIN 
            EXECUTE IMMEDIATE 'SELECT RTRIM(directory_path,''/'') FROM dba_directories WHERE UPPER(directory_name) =''DIR_NAME''' INTO l_source_path;
            -- To Create Scheduler Job
            DBMS_SCHEDULER.CREATE_JOB(
               job_name             => 'ExtractData',
               job_type             => 'EXECUTABLE',
               number_of_arguments  => 6,
               job_action           => l_job,
               auto_drop            => true);
            -- To Pass The Six Relevant Arvuments
            DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE('ExtractData',1,l_source_path);
            DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE('ExtractData',2,l_source_file);
            DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE('ExtractData',3,l_dest_user);
            DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE('ExtractData',4,l_dest_ip);
            DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE('ExtractData',5,l_dest_path);
            DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE('ExtractData',6,l_dest_password);
            DBMS_SCHEDULER.ENABLE('ExtractData');
       EXCEPTION WHEN NO_DATA_FOUND THEN
           Dbms_Output.Put_Line(SQLERRM);
       END;
    END;
END;
/

-- To Verify the Status of Job
SELECT owner, job_name,start_date, end_date, enabled, state, raise_events FROM dba_scheduler_jobs WHERE owner = 'SYS' AND Upper(job_name) = 'EXTRACTDATA';
SELECT * FROM dba_scheduler_running_jobs WHERE UPPER(job_name) = 'EXTRACTDATA';
SELECT * FROM dba_scheduler_job_run_details WHERE owner = 'SYS' AND UPPER(job_name) = 'EXTRACTDATA' ORDER BY log_date DESC;

-- To Disable the Job
BEGIN
   DBMS_SCHEDULER.DISABLE(job_name => 'ExtractData'); 
END;
/

-- To Stop the Job  
BEGIN
    DBMS_SCHEDULER.STOP_JOB(job_name => 'ExtractData'); 
END;
/

-- To Drop the Job  
BEGIN
  DBMS_SCHEDULER.DROP_JOB(job_name => 'ExtractData');
END;
/

-- To Purge the Job Log  
BEGIN 
  DBMS_SCHEDULER.purge_log (job_name    => 'ExtractData');
END;
/