#!/bin/sh

#########################################################################################
# File     : rman_db_full_backup_asm.sh
# Purpose  : The script groups together RMAN commands in a RUN block to take a 
#            full backup of a database,  archivelogs, parameter and control file
#            using RMAN four channels. 
# Usage    : ./rman_db_full_backup_asm.sh
# Author   : Devesh Kumar Shrivastav
# Purpose  : POC
# Revision : 1.0
#########################################################################################

###########################BOF of the rman_db_full_backup_asm################################

# Export the oracle environment
export ORACLE_HOME=/u01/app/oracle/product/11.2.0.3.0/db_1
export ORACLE_SID=racdb1
export PATH=$PATH:$ORACLE_HOME/bin

# Take the argument as of location
backup_location='+FRA/RACDB'
db_log=/home/oracle/backup/`date +%Y_%m_%d`.log
touch $db_log

$ORACLE_HOME/bin/rman target / nocatalog log =$db_log  append << EOF

run
{
        ALLOCATE CHANNEL c1 DEVICE TYPE DISK MAXPIECESIZE 10G;
        ALLOCATE CHANNEL c2 DEVICE TYPE DISK MAXPIECESIZE 10G;
        ALLOCATE CHANNEL c3 DEVICE TYPE DISK MAXPIECESIZE 10G;
        ALLOCATE CHANNEL c4 DEVICE TYPE DISK MAXPIECESIZE 10G;

        CONFIGURE CONTROLFILE AUTOBACKUP ON;
        CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '${backup_location}/control_auto_%F';

        #To Catch Old Archive Files
        SQL "ALTER SYSTEM SWITCH LOGFILE";

        #DB Backup
        BACKUP AS COMPRESSED BACKUPSET  INCREMENTAL LEVEL 0 DATABASE FORMAT '${backup_location}/database_db_%U_%T' tag='fullbkp';

        #Archive Backup
        BACKUP AS COMPRESSED BACKUPSET  ARCHIVELOG ALL FORMAT '${backup_location}/archivefile_arc_%U_%T' NOT BACKED UP 2 TIMES SKIP INACCESSIBLE;

        #Enable the DELETE command below on confirmation with client.
        #DELETE NOPROMPT ARCHIVELOG ALL BACKED UP 1  TIMES TO DISK;
        #DELETE NOPROMPT OBSOLETE REDUNDANCY = 1;

        #Perameter File Backup
        BACKUP SPFILE FORMAT '${backup_location}/spfile_sp_%U_%T';

        #Control File Backup
        BACKUP CURRENT CONTROLFILE FORMAT '${backup_location}/controlfile_cf_%d_%u_%s_%T';

        RELEASE CHANNEL c1;
        RELEASE CHANNEL c2;
        RELEASE CHANNEL c3;
        RELEASE CHANNEL c4;
}

EXIT;

EOF

# To find the error from RMAN log
error_log=`cat ${db_log} | grep -i "error" | wc -w`
if [[ ${error_log} -eq "0" ]]; then

  # To Fetch the relevant location of files
  input_filename=`echo ${db_log} |  sed 's/.*\///'`
  directory_name=`echo ${db_log} |  sed 's/\(.*\)\/.*/\1/'`\/
  temp_filename=${directory_name}/temp_filename.txt
  output_filename=${directory_name}/output_filename.txt
  cat ${directory_name}/${input_filename} | grep -i ^piece  > ${temp_filename}
  sed -e s/"piece handle"//g -i ${temp_filename}
  sed -e s/"="//g -i ${temp_filename}
  sed 's/ .*//' ${temp_filename} > ${output_filename}

  # Copy the RMAN DB backup log file from Oracle to Grid User
  directory_name=/home/grid/rman_log/
  cp -r ${output_filename} ${directory_name}

  # Remove the Temporary Files
  rm -rf ${temp_filename} ${output_filename}

fi
###########################EOF of the rman_db_full_backup_asm################################