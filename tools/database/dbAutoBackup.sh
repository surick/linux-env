#!/usr/bin/env bash
# Database info
DB_USER="root"
DB_PASS="root123"
DB_HOST="127.0.0.1"
DB_NAME="test"

# Others vars
mkdir -p /home/data/test/mysqlBackup
BIN_DIR="/usr/bin"            #the mysql bin path
BCK_DIR="/home/data/test/mysqlBackup"    #the backup file directory
DATE=`date +%F`

# TODO
$BIN_DIR/mysqldump --opt -u$DB_USER -p$DB_PASS -h$DB_HOST $DB_NAME > $BCK_DIR/db_$DATE.sql

# Find backup file and delete（save 30 days）
find $BCK_DIR -name "db_*.sql" -type f -mtime +30 -exec rm {} \; > /dev/null 2>&1

# 还原数据库
# 把 *.sql.gz 使用gunzip 或 本地的解压软件 解压为 *.sql 文件
# 用mysql-front导入前一天的 *.sql 文件即可恢复数据
