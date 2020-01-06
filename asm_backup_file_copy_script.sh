#!/bin/sh

#########################################################################################
# File     : asm_backup_file_copy_script.sh
# Purpose  : The script is designed to copy the ASM oracle DB Backup files on the basis of RMAN DB log
#            The RAMN db log file should be 775 permission
# Usage    : ./asm_backup_file_copy_script.sh /home/oracle/backup/2020_01_06.log /home/grid/backup/
# Author   : Devesh Kumar Shrivastav
# Purpose  : POC
# Revision : 1.0
#########################################################################################

###########################BOF of the asm_backup_file_copy_script########################

# Export the oracle environment
export ORACLE_HOME=/u01/11.2.0.3.0/grid
export ORACLE_SID=+ASM1
export ORACLE_HOME ORACLE_SID
PATH=$ORACLE_HOME/bin:$PATH

# Take the argument as of rman backp log file name
input_filename=$1

# Take the argument as of rman backp copy location
dest_location=$2

#Create a directory
directory_name=${dest_location}`date +%Y_%m_%d`
mkdir -p ${directory_name}

# Copy the RMAN DB backup log file from Oracle to Grid User
cp -r ${input_filename} ${directory_name}

# To Fetch the relevant location of files
input_filename=`echo ${input_filename} |  sed 's/.*\///'`
temp_filename=${directory_name}/temp_filename.txt
output_filename=${directory_name}/output_filename.txt
cat ${directory_name}/${input_filename} | grep -i ^piece  > ${temp_filename}
sed -e s/"piece handle"//g -i ${temp_filename}
sed -e s/"="//g -i ${temp_filename}
sed 's/ .*//' ${temp_filename} > ${output_filename}

copy_log=${directory_name}/db_copy_`date +%Y_%m_%d`.log
touch $copy_log

for i in $(cat ${output_filename})
do
  asmcmd cp ${i}  ${directory_name}/
  #echo ${i}
done > $copy_log

# Remove the Temporary Files
rm -rf ${temp_filename} ${output_filename} ${directory_name}/${input_filename}

###########################EOF of the asm_backup_file_copy_script########################