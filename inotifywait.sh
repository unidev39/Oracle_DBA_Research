#!/bin/sh

#########################################################################################################################
# File     : inotifywait.sh
# Purpose  : Create the trigger to run the script if the file is created under the specified directory
# Usage    : To Schedule the job 
#              ./inotifywait.sh &
#               The Log file directory should have /home/grid/rman_log 775 permission & owneded by grid user
#            To Stop The Job
#              [root@rac_pdb ~]# ps -ef|grep inoti
#              grid     16560     1  0 13:21 pts/4    00:00:00 /bin/sh ./inotifywait.sh
#              grid     16561 16560  0 13:21 pts/4    00:00:00 inotifywait -m /home/grid/backup -e close_write,moved_to
#              grid     16562 16560  0 13:21 pts/4    00:00:00 /bin/sh ./inotifywait.sh
#              root     17106 17068  0 13:36 pts/4    00:00:00 grep inoti
#              [root@rac_pdb ~]# kill -9 16561
# Author   : Devesh Kumar Shrivastav
# Date     : January 17, 2020
# Purpose  : UNIX Triggering mechanism
# Revision : 1.0
#########################################################################################################################

##########################################BOF This is part of the inotifywait############################################

# Path for the file will be created
path=/home/grid/rman_log

# Path where the triggering script is located (triggering_script)
script_path=/home/grid/script
script_path="${script_path}/asm_backup_file_copy_script_integration.sh"

# UNIX Triggering mechanism when the movement of file under the directory
inotifywait -m "$path" -e close_write,moved_to |
while read path action file; do
 eval ${script_path}
done
##########################################BOF This is part of the inotifywait############################################