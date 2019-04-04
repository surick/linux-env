#!/usr/bin/env bash
# format console's chinese font
sudo locale-gen zh_CN.UTF-8
echo 'export LANG="zh_CN.UTF-8"' >> /etc/profile
source /etc/profile