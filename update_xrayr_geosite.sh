#!/bin/bash

# 进入 XrayR 配置目录
cd /etc/XrayR || { echo "Failed to change directory to /etc/XrayR"; exit 1; }

# 下载 dlc.dat 文件
wget https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat -O dlc.dat || { echo "Failed to download dlc.dat"; exit 1; }

# 备份原 geosite.dat 文件
cp geosite.dat geosite.dat.back || { echo "Failed to backup geosite.dat"; exit 1; }

# 删除原 geosite.dat 文件
rm -rf geosite.dat || { echo "Failed to remove geosite.dat"; exit 1; }

# 将下载的 dlc.dat 重命名为 geosite.dat
mv dlc.dat geosite.dat || { echo "Failed to rename dlc.dat to geosite.dat"; exit 1; }

# 重启 XrayR 服务
systemctl restart XrayR || { echo "Failed to restart XrayR"; exit 1; }

echo "Successfully updated geosite.dat and restarted XrayR."
