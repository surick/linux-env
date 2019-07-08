#!/usr/bin/env bash
# sudo yum -y install git
mkdir -p /home/git
cd /home/git
wget https://github.com/git/git/archive/v2.1.2.tar.gz -O git.tar.gz
tar -zxf git.tar.gz
cd git-*
make configure
./configure --prefix=/usr/local
# if make error,try sudo yum install gcc at first
sudo make install
