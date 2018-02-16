#!/bin/bash
# Simple script to backup MySQL databases, keep logs and delete the old ones

# Parent backup directory
backup_parent_dir="/srv/maintenance/mysql"

# MySQL settings
mysql_user="root"
mysql_password="myroot-mysqlpassword"

echo "BismillahirRahmanirRahim"

# Read MySQL password from stdin if empty
if [ -z "${mysql_password}" ]; then
  echo -n "Enter MySQL ${mysql_user} password: "
  read -s mysql_password
  echo
fi

# Check MySQL password
echo exit | mysql --user=${mysql_user} --password=${mysql_password} -B 2>/dev/null
if [ "$?" -gt 0 ]; then
  echo "MySQL ${mysql_user} password incorrect"
  exit 1
else
  echo "MySQL ${mysql_user} password correct."
fi

# Create backup directory and set permissions
backup_date=`date +%Y_%m_%d_%H_%M_%S`
log_date=`date +%Y_%m_%d`
backup_dir="${backup_parent_dir}"
logfile="$backup_dir/"backup_log_"$log_date".log
echo "*****************" >> "$logfile"
echo "BismillahirRahmanirRahim mysqlbackup.sh file run at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
echo "*****************" >> "$logfile"
echo "Backup directory: ${backup_dir}"
mkdir -p "${backup_dir}"
chmod 700 "${backup_dir}"

# Get MySQL databases
mysql_databases=`echo 'show databases' | mysql --user=${mysql_user} --password=${mysql_password} -B | sed /^Database$/d`

# Backup and compress each database
for database in $mysql_databases
do
  if [ "${database}" == "information_schema" ] || [ "${database}" == "performance_schema" ]; then
        additional_mysqldump_params="--skip-lock-tables"
  else
        additional_mysqldump_params=""
  fi
  echo "Creating backup of \"${database}\" database"
  echo "mysqldump started at $(date +'%d-%m-%Y %H:%M:%S') for ${database}" >> "$logfile"

  mysqldump ${additional_mysqldump_params} --user=${mysql_user} --password=${mysql_password} ${database} | bzip2 --best > "${backup_dir}/db_backup_${database}_${backup_date}.sql.bz2"
  echo "mysqldump finished at $(date +'%d-%m-%Y %H:%M:%S') for ${database}" >> "$logfile"

  chmod 600 "${backup_dir}/db_backup_${database}_${backup_date}.sql.bz2"
  echo "file permission changed for ${database}_${backup_date}.sql.bz2" >> "$logfile"
done

# Delete backups older than 30 days.
find "${backup_dir}/" -name db_backup_* -mtime +30 -exec rm {} \;
echo "old files deleted"
echo "old files deleted" >> "$logfile"
echo "operation finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
echo "*****************" >> "$logfile"
echo "Elhamdülillah" >> "$logfile"
echo "*****************" >> "$logfile"
exit 0

# SONUC CIKTISI 
# $ sudo mysql_backup.sh
# MySQL root password correct.
# Backup directory: /var/backups/mysql/2012_11_20_20_56
# Creating backup of "information_schema" database
# Creating backup of "notes" database
# Creating backup of "dokuwiki" database
# Creating backup of "kalkun" database
# Creating backup of "mysql" database
# Creating backup of "performance_schema" database
# Creating backup of "semantic" database
# Creating backup of "wordpress" database# 


# ESKİSİ
#!/bin/sh
#now="$(date +'%d_%m_%Y_%H_%M_%S')"
#filename="db_backup_$now".gz
#backupfolder="/srv/maintenance/backups/"
#fullpathbackupfile="$backupfolder/$filename"
#logfile="$backupfolder/"backup_log_"$(date +'%Y_%m')".txt
#echo "mysqldump started at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
#mysqldump --user=magento --password=3f1e199a-3afa-49fa-b934-649b3ca98cb2 --default-character-set=utf8 --single-transaction  magento | gzip > "$fullpathbackupfile"
#echo "mysqldump finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
#chown myuser "$fullpathbackupfile"
#chown myuser "$logfile"
#echo "file permission changed" >> "$logfile"
#find "$backupfolder" -name db_backup_* -mtime +90 -exec rm {} \;
#echo "old files deleted" >> "$logfile"
#echo "operation finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
#echo "*****************" >> "$logfile"
#exit 0
