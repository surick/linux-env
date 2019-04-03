#!/usr/bin/env bash
mkdir -p /home/redis
cd /home/redis
#wget http://download.redis.io/releases/redis-4.0.2.tar.gz
tar -zxvf redis-4.0.2.tar.gz
mv redis-4.0.2 redis
cd redis
make
# if make error, try sudo yum install gcc
sudo cp src/redis-server /usr/local/bin/
sudo cp src/redis-cli /usr/local/bin/
cd ../
nohup redis-server > /dev/null 2>&1 &
