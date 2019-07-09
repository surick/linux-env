#!/usr/bin/env bash
# Description: Set up MySQL Community Release 5.7

# Get the repo RPM and install it.
mkdir -p /home/mysql
cd /home/mysql
wget http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
yum -y install ./mysql57-community-release-el7-7.noarch.rpm

# Install the server and start it
yum -y install mysql-community-server
systemctl start mysqld
systemctl enable mysqld

# Get the temporary password
temp_password=$(grep password /var/log/mysqld.log | awk '{print $NF}')

# Set new password
new_password=surick-abc123@

# Set up a batch file with the SQL commands
echo "SET GLOBAL validate_password_policy = 0;SET GLOBAL validate_password_length = 6;SET GLOBAL validate_password_number_count = 0;ALTER USER 'root'@'localhost' IDENTIFIED BY '$new_password'; flush privileges;" > reset_pass.sql

# Set root can be accessed remotely
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$new_password' WITH GRANT OPTION; flush privileges;" >> reset_pass.sql

# Log in to the server with the temporary password, and pass the SQL file to it.
mysql -u root --password="$temp_password" --connect-expired-password < reset_pass.sql
