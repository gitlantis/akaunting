#!bin/bash
cd /home/azureuser
if [ ! -d '/mnt/vmfileshare' ]; then
    sh ./vmfileshare.sh
else
    echo 'diraectory mounted already'
fi

export DBNAMES="db"
export DBPASS="pass"
export SERVER="db-db.mysql.database.azure.com"
export DBUSER="admin@db-db"
date=$(date +%s)
year=$(date +%Y)
month=$(date +%m)
day=$(date +%d)
hour=$(date +%H)
path=$year/$month/$day/$hour
echo $date
cd /mnt/vmfileshare
mkdir -p $path
cd $path

echo 'backup starting'
mysqldump --column-statistics=0 --databases $DBNAMES -h $SERVER -u $DBUSER --password=$DBPASS > back_$date.sql
echo 'turning off VM'
az vm deallocate -g akaunting-rg -n akauntvm
