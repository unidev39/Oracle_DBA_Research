#!/bin/sh

#########################################################################################
# File     : asm_backup_file_copy_script_integration.sh
# Purpose  : The script groups together RMAN commands in a RUN block to take a 
#            full backup of a database,  archivelogs, parameter and control file
#            using RMAN four channels. 
# Usage    : ./asm_backup_file_copy_script_integration.sh
# Author   : Devesh Kumar Shrivastav
# Date     : January 17, 2020
# Purpose  : Copy the file from ASM storage
# Revision : 1.0
#########################################################################################

###################BOF of the asm_backup_file_copy_script_integration####################

# Export the oracle environment
export ORACLE_HOME=/u01/11.2.0.3.0/grid
export ORACLE_SID=+ASM1
export ORACLE_HOME ORACLE_SID
PATH=$ORACLE_HOME/bin:$PATH

# Take the argument as of rman backp log file name
input_filename=/home/grid/rman_log/output_filename.txt

# Take the argument as of rman backp copy location
dest_location=/home/grid/backup/

#Create a directory
directory_name=${dest_location}`date +%Y_%m_%d`
mkdir -p ${directory_name}

#Copy file from ASM Storage based on RMAN Log
copy_log=${directory_name}/db_copy_`date +%Y_%m_%d`.log
touch $copy_log

for i in $(cat ${input_filename})
do
  asmcmd cp ${i}  ${directory_name}/
done > $copy_log

###################EOF of the asm_backup_file_copy_script_integration####################
