-- To find the free and occupied size by tablespace
WITH tbs_auto AS
(
 SELECT DISTINCT 
      tablespace_name,
      autoextensible
 FROM dba_data_files
 WHERE autoextensible = 'YES'
),
files AS
(
 SELECT 
       tablespace_name,
       COUNT(*)              tbs_files,
       SUM(BYTES/1024/1024)  total_tbs_mb
 FROM dba_data_files
 GROUP BY tablespace_name
),
fragments AS
(
 SELECT
      tablespace_name,
      COUNT(*)               tbs_fragments,
      SUM(bytes)/1024/1024   total_tbs_free_mb,
      MAX(bytes)/1024/1024   max_free_chunk_mb
 FROM dba_free_space
 GROUP BY tablespace_name
),
autoextend AS
(
 SELECT
      tablespace_name,
      SUM(size_to_grow) total_growth_tbs
 FROM (
       SELECT 
            tablespace_name,
            SUM(maxbytes)/1024/1024  size_to_grow
       FROM dba_data_files
       WHERE autoextensible = 'YES'
       GROUP BY tablespace_name
       UNION
       SELECT 
            tablespace_name,
            SUM(bytes)/1024/1024  size_to_grow
       FROM dba_data_files
       WHERE autoextensible = 'NO'
       GROUP BY tablespace_name
     )
 GROUP BY tablespace_name
)
SELECT
     --c.instance_name,
     a.tablespace_name tablespace,
     CASE tbs_auto.autoextensible
          WHEN 'YES' THEN 'YES'
     ELSE 'NO'
     END AS autoextensible,
     files.tbs_files                                                                               files_in_tablespace_count,
     Round(files.total_tbs_mb/(1024),1)                                                            total_tablespace_space_gb,
     Round((files.total_tbs_mb - fragments.total_tbs_free_mb)/(1024),1)                            total_used_space_gb,
     Round(fragments.total_tbs_free_mb/(1024),1)                                                   total_tablespace_free_space_gb
     --round((((files.total_tbs_mb - fragments.total_tbs_free_mb)/files.total_tbs_mb)*100),1)        total_used_pct_mb,
     --round(((fragments.total_tbs_free_mb/files.total_tbs_mb)*100),1)                               total_free_pct_mb
FROM 
    dba_tablespaces a,
    --v$instance c,
    files, 
    fragments, 
    autoextend, 
    tbs_auto
WHERE 
    a.tablespace_name = files.tablespace_name
AND a.tablespace_name = fragments.tablespace_name
AND a.tablespace_name = autoextend.tablespace_name
AND a.tablespace_name = tbs_auto.tablespace_name(+)
--AND (((files.total_tbs_bytes - fragments.total_tbs_free_bytes)/ files.total_tbs_bytes))* 100 > 90
order by 5 desc;

-- RMAN Backup status
SELECT 
     a.input_type,a.file_input_type, a.backup_type, a.backup_status, a.backup_day, a.start_time, a.end_time, a.total_execution_time, a.backup_input_size, a.backup_output_size
FROM (
      SELECT
           ROW_NUMBER() OVER (ORDER BY end_time)           sn,
           input_type,
           CASE 
              WHEN input_bytes_display LIKE '%T' 
              THEN 'DB Full' 
           ELSE 
              input_type END                               file_input_type,
           'Compressed'                                    backup_type,
           status                                          backup_status,
           TO_CHAR(start_time,'Day')                       backup_day,
           TO_CHAR(start_time,'DD-MON-YYYY HH24:MI:SS PM') start_time, 
           TO_CHAR(end_time,'DD-MON-YYYY HH24:MI:SS PM')   end_time,
           time_taken_display                              total_execution_time,
           input_bytes_display                             backup_input_size,
           output_bytes_display                            backup_output_size 
      FROM v$rman_backup_job_details 
    ) a
ORDER BY a.sn desc;

-- To Find number of sessions, event & status wise  
SELECT COUNT(*),event FROM gv$session WHERE username IS NOT NULL AND username!='SYS' GROUP BY event;
SELECT COUNT(*),status from gv$session where username is not null and username NOT LIKE '%SYS%' GROUP BY status;

-- To find the current status of DB
SELECT * from v$asm_diskgroup;
SELECT name,open_mode FROM gv$database;
SELECT * FROM v$flash_recovery_area_usage;
archive log list;
SELECT MAX(sequence#),inst_id from gv$archived_log group by inst_id;
SELECT MAX(sequence#),inst_id from gv$archived_log where applied='YES' group by inst_id;
SELECT * FROM gv$archive_gap;


-- To find the inactive sessions
SELECT
     --'ALTER SYSTEM KILL SESSION '''||ssn.sid||','||ssn.serial#||''''|| ' IMMEDIATE;' " ", 
     --'ALTER SYSTEM KILL SESSION '''||ssn.sid||','||ssn.serial#||',@'||ssn.inst_id||''' IMMEDIATE;' " ",
     ssn.sid,
     ssn.serial#,
     ssn.username,
     ssn.schemaname,
     ssn.osuser,
     TO_CHAR((se1.VALUE/1024)/1024, '999G999G990D00') || ' MB' current_size,
     TO_CHAR((se2.VALUE/1024)/1024, '999G999G990D00') || ' MB' maximum_size,
     ssn.program
FROM 
     v$sesstat se1, v$sesstat se2, gv$session ssn, v$bgprocess bgp, v$process prc, v$instance ins, v$statname stat1, v$statname stat2
WHERE 
     se1.statistic# = stat1.statistic# and stat1.name = 'session pga memory'
AND  se2.statistic# = stat2.statistic# and stat2.name = 'session pga memory max'
AND  se1.sid = ssn.sid
AND  se2.sid = ssn.sid
AND  ssn.paddr = bgp.paddr (+)
AND  ssn.paddr = prc.addr (+)
AND  (ssn.username IS NOT NULL AND ssn.username NOT LIKE 'SYS%') 
AND  ssn.status ='INACTIVE' 
--AND  regexp_like(Upper(ssn.osuser),'ADMINISTRATOR')
ORDER BY 7 DESC;

--CPU used by this session details
SELECT
   --'ALTER SYSTEM KILL SESSION '''||t.sid||','||s.serial#||',@'||s.inst_id||''' IMMEDIATE;' " ",
   s.machine,
   s.status,
   s.terminal,
   s.prev_exec_start,
   S.MODULE,
   S.LOGON_TIME,
   s.program,
   s.osuser,
   s.username,
   t.sid,
   s.serial#,
   SUM(VALUE/100) as "cpu usage (seconds)"
FROM
   gv$session s,
   gv$sesstat t,
   gv$statname n
WHERE
   t.STATISTIC# = n.STATISTIC#
AND
   MACHINE LIKE '%CIB%'
AND
   NAME like '%CPU used by this session%'
AND
   t.SID = s.SID
AND
   s.username is not null
GROUP BY s.inst_id,s.machine,s.status,s.terminal,username, s.prev_exec_start,S.MODULE,S.LOGON_TIME,s.program,t.sid,s.serial#,s.osuser
order by "cpu usage (seconds)" desc;

-- To find the locks
SELECT 
     lo.session_id,
     lo.oracle_username,
     lo.os_user_name,
     ob.owner,
     ob.object_name,
     ob.object_type,
     lo.locked_mode
FROM (
      SELECT
           a.object_id,
           a.session_id,
           a.oracle_username,
           a.os_user_name,
           a.locked_mode
      FROM
           gv$locked_object a
     ) lo 
     JOIN
     (
      SELECT
           b.object_id,
           b.owner,
           b.object_name,
           b.object_type
      FROM
           all_objects b
     ) ob
ON (lo.object_id = ob.object_id);

-- The blocking session is:
SELECT
    --'ALTER SYSTEM KILL SESSION '''||sid||','||serial#||''''|| ' IMMEDIATE;' " ",
    --'ALTER SYSTEM KILL SESSION '''||sid||','||serial#||',@'||inst_id||''' IMMEDIATE;' " ",
    username,
    blocking_session,
    sid,    serial#,
    wait_class,
    seconds_in_wait 
from
    gv$session 
where
    blocking_session is not NULL
order by
    blocking_session;
    
    
-- To find the current query run time
SELECT 
     l.opname                             opname,
     l.target                             target,
     l.message                            message,
     ROUND((l.sofar/l.totalwork),4) * 100 Percentage_Complete,
     l.start_time                         start_time,
     CEIL(l.time_remaining/60)            Max_Time_Remaining_In_Min,
     l.time_remaining                     time_remaining_in_second,
     FLOOR( l.elapsed_seconds / 60 )      Time_Spent_In_Min,
     ar.sql_fulltext                      sql_fulltext,
     ar.parsing_schema_name               parsing_schema_name,
     ar.module                            Client_Tool
FROM 
     gv$session_longops l, gv$sqlarea ar
WHERE 
     l.sql_id = ar.sql_id
AND  l.totalwork > 0
AND  ar.users_executing > 0
AND  l.sofar != l.totalwork;

-- To find Current running query (from sys user)
SELECT
     --'ALTER SYSTEM KILL SESSION '''||s.sid||','||s.serial#||''''|| ' IMMEDIATE;' " ", 
     --'ALTER SYSTEM KILL SESSION '''||s.sid||','||s.serial#||',@'||s.inst_id||''' IMMEDIATE;' " ",
     s.status,
     s.username,
     s.osuser,
     s.sid,
     s.serial#,
     t.sql_id,
     t.sql_text
FROM 
     gv$sqlarea t, gv$session s
WHERE 
     t.address = s.sql_address
AND  t.hash_value = s.sql_hash_value
AND  s.status IN  ('ACTIVE')
--AND  s.username IN ('CIB')
AND  s.username NOT IN (USER)
--AND  s.username  IN ('SYSTEM')

ORDER BY 
     s.sid;
                                                             
-- To find the query process time
SELECT
     --a.sql_text
     a.inst_id,
     a.first_load_time,
     a.elapsed_time,
     a.executions
     --,a.elapsed_time/executions  averagetime
FROM 
     gv$sqlarea a
WHERE 
     a.sql_id IN ('dkpwh7qhaxzm1');
--   a.sql_id IN (
--                SELECT 
--                     b.sql_id 
--                FROM 
--                     gv$sqlarea b
--                WHERE 
--                    regexp_like(UPPER(b.sql_text),'(INSERT|TEST)') 
--                AND b.parsing_schema_name = USER
--               );

-- To find disk intensive full table scans query
SELECT
     timestamp
     ,parsing_schema_name
     ,operation
     ,options 
     ,disk_reads
     ,executions
     ,cpu_cost     
     ,io_cost
     ,sql_fulltext
     --,sql_id
     --,inst_id
     --,module 
FROM (
      SELECT 
           disk_reads
          ,executions
          ,sql_id
          ,sql_fulltext
          ,operation
          ,options
          ,inst_id  
          ,cpu_cost 
          ,io_cost
          ,timestamp
          ,parsing_schema_name
          ,module
          ,ROW_NUMBER() OVER (PARTITION BY sql_text ORDER BY disk_reads * executions DESC) keephighsql
      FROM (
           SELECT 
                AVG(disk_reads) OVER (PARTITION BY sql_text) disk_reads
               ,MAX(executions) OVER (PARTITION BY sql_text) executions
               ,t.sql_id
               ,sql_text
               ,sql_fulltext
               ,p.operation
               ,p.options
                 ,p.inst_id  
               ,p.cpu_cost 
               ,p.io_cost
               ,p.timestamp
               ,t.parsing_schema_name
               ,t.module
           FROM 
                gv$sqlarea t, gv$sql_plan p
           WHERE 
                t.hash_value = p.hash_value
          AND p.operation IN ('TABLE ACCESS')
          AND p.options = 'FULL'
          AND NOT regexp_like(p.object_owner, '(^SYSTEM$|^SYSMAN$|^SYS$|^WMSYS$|^DBMS_SPACE$|^DBMS_WORKLOAD_REPOSITORY$|^DBSNMP$)')
          AND t.executions > 1
          AND TRUNC(TIMESTAMP)=TO_DATE('01.12.2019','dd.mm.yyyy')
          )
      ORDER BY (disk_reads * executions) DESC
       )
WHERE 
     keephighsql = 1
--AND ROWNUM <= 10 
--AND PARSING_SCHEMA_NAME <> 'CIB'
--AND PARSING_SCHEMA_NAME ='CIB'
ORDER BY disk_reads DESC;


-- To find the status of scheduler jobs
SELECT OWNER, JOB_NAME,START_DATE, END_DATE, ENABLED, STATE, RAISE_EVENTS FROM dba_scheduler_jobs WHERE owner = '<<OWNER_NAME>>' AND Upper(JOB_NAME) LIKE '%%';
SELECT * FROM dba_scheduler_running_jobs WHERE JOB_NAME ='<<JOB_NAME>>';
SELECT * FROM dba_scheduler_job_run_details WHERE owner = '<<OWNER_NAME>>' AND job_name LIKE '%<<JOB_NAME>>%' ORDER BY log_date DESC;
SELECT * FROM dba_scheduler_job_run_details WHERE owner = '<<OWNER_NAME>>' AND job_name LIKE '%%' ORDER BY log_date DESC;
SELECT * FROM dba_scheduler_job_run_details WHERE owner IN ('<<OWNER_NAME>>') AND job_name LIKE '%%' ORDER BY log_date DESC;

-- To Create a scheduler jobs
BEGIN
    DBMS_SCHEDULER.CREATE_JOB
    (
     job_name             => '<<JOB_NAME>>',
     job_type             => 'PLSQL_BLOCK',
     job_action           => 'BEGIN <<SP_PKG>>; END;',
     start_date           => systimestamp,
     repeat_interval      => 'FREQ=DAILY', 
     --repeat_interval => 'FREQ=DAILY;BYHOUR=13;BYMINUTE=0;BYSECOND=0',
     end_date             => systimestamp + 30,
     enabled              =>  TRUE,
     comments             => 'Execute the job'
    );
END;
/

-- To Disble a scheduler jobs
BEGIN
   DBMS_SCHEDULER.DISABLE(job_name => '<<JOB_NAME>>'); 
END;
/

-- To stop a scheduler jobs
BEGIN
    DBMS_SCHEDULER.STOP_JOB(job_name => '<<JOB_NAME>>'); 
END;
/

-- To drop a scheduler jobs
BEGIN
  DBMS_SCHEDULER.DROP_JOB(job_name => '<<JOB_NAME>>');
END;
/

-- To find the degree of tables
SELECT Count(*),owner,DEGREE FROM dba_tables GROUP BY owner,DEGREE ORDER BY 3 desc;
SELECT owner,table_name,DEGREE FROM dba_tables ORDER BY 3 DESC;

-- To Change the degree of tables
SELECT 'ALTER TABLE <<USER>>.'||TABLE_NAME||' PARALLEL 8;' " ", OWNER,TABLE_NAME,DEGREE FROM dba_tables WHERE table_name LIKE '%<<TABLE_NAME>>%'
AND owner ='RAS'
AND table_name  IN ('<<TABLE_NAME>>') 
AND DEGREE < 8;


-- To find Database Up Time
SELECT
    'Hostname       : ' ||host_name
    ,'Instance Name : ' ||instance_name
    ,'Started At    : ' ||TO_CHAR(startup_time,'DD-MON-YYYY HH24:MI:SS') stime
    ,'Uptime        : ' ||FLOOR(sysdate - startup_time)|| ' days(s) ' ||TRUNC( 24*((SYSDATE-startup_time) - TRUNC(SYSDATE-startup_time)))|| ' hour(s) ' ||MOD(TRUNC(1440*((SYSDATE-startup_time) - TRUNC(SYSDATE-startup_time))), 60)||' minute(s) '||
    MOD(TRUNC(86400*((sysdate-startup_time) - trunc(sysdate-startup_time))), 60)||' seconds' uptime
FROM sys.gv_$instance;


--To Find Oracle SID based on OS PID
SELECT 
    b.spid,
    a.sid,
    a.serial#,
    a.username,
    a.osuser
FROM v$session a, v$process b
WHERE a.paddr = b.addr AND b.spid = '23924'
ORDER BY b.spid;

--To Find Oracle Sessions based on OS SID
DECLARE
  l_sid    NUMBER;
  s        sys.v_$session%ROWTYPE;
  p        sys.v_$process%ROWTYPE;
  p_sid    NUMBER := 2187;
BEGIN
  BEGIN
    SELECT sid INTO l_sid FROM sys.v_$session s WHERE  sid=p_sid;
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN
      dbms_output.put_line('Unable to find SID '||p_sid||'!!!');
      RETURN;
    WHEN OTHERS THEN
      dbms_output.put_line(SQLERRM);
      RETURN;
  END;

  SELECT * INTO s FROM sys.v_$session WHERE sid=l_sid;
  SELECT * INTO p FROM sys.v_$process WHERE addr=s.paddr;

  dbms_output.put_line('=====================================================================');
  dbms_output.put_line('SID/Serial  : '|| s.sid||','||s.serial#);
  dbms_output.put_line('Foreground  : '|| 'PID: '||s.process||' - '||s.program);
  dbms_output.put_line('Shadow      : '|| 'PID: '||p.spid||' - '||p.program);
  dbms_output.put_line('Terminal    : '|| s.terminal || '/ ' || p.terminal);
  dbms_output.put_line('OS User     : '|| s.osuser||' on '||s.machine);
  dbms_output.put_line('Ora User    : '|| s.username);
  dbms_output.put_line('Status Flags: '|| s.status||' '||s.server||' '||s.type);
  dbms_output.put_line('Tran Active : '|| NVL(s.taddr, 'NONE'));
  dbms_output.put_line('Login Time  : '|| TO_CHAR(s.logon_time, 'Dy HH24:MI:SS'));
  dbms_output.put_line('Last Call   : '|| TO_CHAR(SYSDATE-(s.last_call_et/60/60/24), 'Dy HH24:MI:SS') || ' - ' || TO_CHAR(s.last_call_et/60, '9999999999.0') || ' min');
  dbms_output.put_line('Lock/ Latch : '|| NVL(s.lockwait, 'NONE')||'/ '||NVL(p.latchwait, 'NONE'));
  dbms_output.put_line('Latch Spin  : '|| NVL(p.latchspin, 'NONE'));
  dbms_output.put_line('Current SQL statement:');

  FOR c1 IN (SELECT * FROM sys.v_$sqltext WHERE hash_value=s.sql_hash_value ORDER BY piece) 
  LOOP
    dbms_output.put_line(CHR(9)||c1.sql_text);
  END LOOP;
  dbms_output.put_line('Previous SQL statement:');
  
  FOR c1 IN (SELECT * FROM sys.v_$sqltext WHERE hash_value=s.prev_hash_value ORDER BY piece) 
  LOOP
    dbms_output.put_line(CHR(9)||c1.sql_text);
  END LOOP;
  dbms_output.put_line('Session Waits:');

  FOR c1 IN (SELECT * FROM sys.v_$session_wait WHERE sid = s.sid) 
  LOOP
    dbms_output.put_line(CHR(9)||c1.state||': '||c1.event);
  END LOOP;
  dbms_output.put_line('Connect Info:');

  FOR c1 IN (SELECT * FROM sys.v_$session_connect_info WHERE sid = s.sid) 
  LOOP
    dbms_output.put_line(CHR(9)||': '||c1.network_service_banner);
  END LOOP;
  dbms_output.put_line('Locks:');
  
  FOR c1 IN (SELECT
                 DECODE(l.type,
                             -- Long locks
                             'TM', 'DML/DATA ENQ',   'TX', 'TRANSAC ENQ',
                             'UL', 'PLS USR LOCK',
                             -- Short locks
                             'BL', 'BUF HASH TBL',  'CF', 'CONTROL FILE',
                             'CI', 'CROSS INST F',  'DF', 'DATA FILE   ',
                             'CU', 'CURSOR BIND ',
                             'DL', 'DIRECT LOAD ',  'DM', 'MOUNT/STRTUP',
                             'DR', 'RECO LOCK   ',  'DX', 'DISTRIB TRAN',
                             'FS', 'FILE SET    ',  'IN', 'INSTANCE NUM',
                             'FI', 'SGA OPN FILE',
                             'IR', 'INSTCE RECVR',  'IS', 'GET STATE   ',
                             'IV', 'LIBCACHE INV',  'KK', 'LOG SW KICK ',
                             'LS', 'LOG SWITCH  ',
                             'MM', 'MOUNT DEF   ',  'MR', 'MEDIA RECVRY',
                             'PF', 'PWFILE ENQ  ',  'PR', 'PROCESS STRT',
                             'RT', 'REDO THREAD ',  'SC', 'SCN ENQ     ',
                             'RW', 'ROW WAIT    ',
                             'SM', 'SMON LOCK   ',  'SN', 'SEQNO INSTCE',
                             'SQ', 'SEQNO ENQ   ',  'ST', 'SPACE TRANSC',
                             'SV', 'SEQNO VALUE ',  'TA', 'GENERIC ENQ ',
                             'TD', 'DLL ENQ     ',  'TE', 'EXTEND SEG  ',
                             'TS', 'TEMP SEGMENT',  'TT', 'TEMP TABLE  ',
                             'UN', 'USER NAME   ',  'WL', 'WRITE REDO  ',
                             'TYPE='||l.type) type,
                 DECODE(l.lmode, 0, 'NONE', 1, 'NULL', 2, 'RS', 3, 'RX', 4, 'S',    5, 'RSX',  6, 'X', TO_CHAR(l.lmode) ) lmode,
                 DECODE(l.request, 0, 'NONE', 1, 'NULL', 2, 'RS', 3, 'RX', 4, 'S', 5, 'RSX', 6, 'X', TO_CHAR(l.request) ) lrequest,
                 DECODE(l.type, 'MR', o.object_name,
                                'TD', o.object_name,
                                'TM', o.object_name,
                                'RW', 'FILE#='||SUBSTR(l.id1,1,3)||' BLOCK#='||SUBSTR(l.id1,4,5)||' ROW='||l.id2,
                                'TX', 'RS+SLOT#'||l.id1||' WRP#'||l.id2,
                                'WL', 'REDO LOG FILE#='||l.id1,
                                'RT', 'THREAD='||l.id1,
                                'TS', DECODE(l.id2, 0, 'ENQUEUE', 'NEW BLOCK ALLOCATION'),
                                'ID1='||l.id1||' ID2='||l.id2) objname
       FROM  sys.v_$lock l, dba_objects o
       WHERE sid = s.sid
       AND l.id1 = o.object_id ) 
  LOOP
     dbms_output.put_line(CHR(9)||c1.type||' H: '||c1.lmode||' R: '||c1.lrequest||' - '||c1.objname);
  END LOOP;
  dbms_output.put_line('=====================================================================');
END;
/


