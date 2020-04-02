#!/bin/sh

#########################################################################################
# File     : rman_db_full_backup.ksh
# Purpose  : The script groups together RMAN commands in a RUN block to take a 
#            full backup of a database,  archivelogs, parameter and control file
#            using RMAN four channels. 
# Usage    : ./rman_db_full_backup.sh /home/oracle/backup/
# Author   : Devesh Kumar Shrivastav
# Purpose  : POC
# Revision : 1.0
#########################################################################################

###########################BOF of the rman_db_full_backup################################

# Export the oracle environment
export ORACLE_HOME=/opt/app/oracle/product/11.2.0.3.0/db_1
export ORACLE_SID=racdb1
export PATH=$PATH:$ORACLE_HOME/bin

# Take the argument as of location
backup_location=$1

# Create a backup folder out side the ASM
mkdir -p ${backup_location}`date +%Y_%m_%d`
backup_location=$(echo ${backup_location}`date +%Y_%m_%d`)

db_log=${backup_location}/`date +%Y_%m_%d`.log
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

###########################EOF of the rman_db_full_backup################################
