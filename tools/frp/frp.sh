#!/usr/bin/env bash
mkdir -p /home/frp
cd /home/frp
wget https://github.com/fatedier/frp/releases/download/v0.25.3/frp_0.25.3_linux_amd64.tar.gz
tar -zxvf frp_0.25.3_linux_amd64.tar.gz
mv frp_0.25.3 frp
cd frp/
nohup ./frpc -c ./frpc.ini > /dev/null 2>&1 &