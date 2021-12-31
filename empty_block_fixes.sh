#!/bin/bash

#####################################################################################################################################################
# Credit Information Bureau Nepal Limited its affiliates. All rights reserved.
# File          : empty_block_fixes.sh
# Purpose       : To Format Empty Corrupted Block
# Usage         : ./empty_block_fixes.sh <<datafilenumber>>
# Created By    : Devesh Kumar Shrivastav
# Created Date  : Dec 29, 2021
# Reviewed By   : Madhusudhan Raj Hada
# Purpose       : POC on UNIX
# Revision      : 1.0
# Remark        : Please repalce the objectes name <<ORACLE_HOME>>,<<ORACLE_SID>>,<<user_name>>,<<user_password>>,<<table_name>> and <<trigger_name>>
#####################################################################################################################################################
#######################################################BOF This is part of the empty_block_fixes#####################################################

export ORACLE_HOME="<<ORACLE_HOME>>"
export ORACLE_SID="<<ORACLE_SID>>"
export ORACLE_HOME ORACLE_SID
PATH=$ORACLE_HOME/bin:$PATH

datafilenumber=$1

para="set pagesize 0 \n set feedback off \n"; 
conn="$ORACLE_HOME/bin/sqlplus -L -S <<user_name>>/<<user_password>> "
#sysconn="$ORACLE_HOME/bin/sqlplus -L -S <<user_name>>/<<user_password>> as sysdba "

#Create a dummy table
#createtbldummy=$(echo -e "CREATE TABLE <<user_name>>.<<table_name>> 
#(
#  n number,
#  c varchar2(4000)
#) nologging TABLESPACE <<tablespace_name>> PCTFREE 99; " | $conn)
#echo $createtbldummy

blocknumber=$(echo -e "$para SELECT nvl(min(block#),0) min_block FROM v\$database_block_corruption WHERE file#=${datafilenumber} ;" | $conn)
while ($blocknumber !=0)

echo $blocknumber

#Create trigger on dummy table which throws exception once the corrupted block is reused
compiletrg=$(echo -e " 
CREATE OR REPLACE TRIGGER <<user_name>>.<<trigger_name>>
  AFTER INSERT ON <<user_name>>.<<table_name>> 
  REFERENCING OLD AS p_old NEW AS new_p 
  FOR EACH ROW 
DECLARE 
  corrupt EXCEPTION; 
BEGIN 
  IF (dbms_rowid.rowid_block_number(:new_p.rowid)=${blocknumber})
 and (dbms_rowid.rowid_relative_fno(:new_p.rowid)=${datafilenumber}) THEN 
     RAISE corrupt; 
  END IF; 
EXCEPTION 
  WHEN corrupt THEN 
     RAISE_APPLICATION_ERROR(-20000, 'Corrupt block has been formatted'); 
END;
/ " | $conn)

echo $compiletrg

#Insert data into dummy table to format the block
anonymousblock=$(echo -e " 
BEGIN
FOR i IN 1..1000000000 LOOP
INSERT /*+ APPEND */ INTO <<user_name>>.<<table_name>> SELECT i, LPAD('REFORMAT',3092, 'R') FROM dual;
COMMIT;
END LOOP;
END;
/ " | $conn)

echo $anonymousblock

#Confirm that the block is now corruption free
echo "validate datafile ${datafilenumber} block ${blocknumber};"|rman target /

#Truncate the dummy table
trunc=$(echo -e " 
TRUNCATE TABLE  <<user_name>>.<<table_name>>  DROP STORAGE; " | $conn)
echo $trunc

#Swith the archive log
#switclog=$(echo -e " 
#Alter system switch logfile ; " | $sysconn)
#echo $switclog

#Create check point
#checkpoint=$(echo -e " 
#Alter system checkpoint ; " | $sysconn)
#echo $checkpoint

blocknumber=$(echo -e "$para SELECT nvl(min(block#),0) min_block FROM v\$database_block_corruption where file#=${datafilenumber} ;" | $conn)

do :; done

#Drop Trigger
#dtrigger=$(echo -e " 
#DROP trigger <<user_name>>.<<trigger_name>> ; " | $conn)
#echo $dtrigger

#Drop dummy table
#dtable=$(echo -e " 
#DROP TABLE  <<user_name>>.<<table_name>> purge; " | $conn)
#echo $dtable


##################################################EOF This is part of the empty_block_fixes##########################################################

