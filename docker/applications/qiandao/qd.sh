#!/usr/bin/env bash
# 一个自动签到服务跑跑张大妈签到 https://github.com/binux/qiandao
docker pull daocloud.io/fangzhengjin/qiandao
mkdir -p /root/docker/volumes/qiandao
docker run -d -p 80:80 --name qiandao
-v $HOME/docker/volumes/qiandao:/usr/src/app/volume daocloud.io/fangzhengjin/qiandao
docker exec -it qiandao bash
# 设置管理员 邮箱需先注册
python ./chrole.py 123456@qq.com admin
exit