#!/bin/bash

ACME_DIR="$HOME/.acme.sh"
echo "🔍 正在检查 acme.sh 管理的所有证书..."
echo ""

# 表头
printf "%-30s %-25s %-25s %-10s\n" "域名" "签发日期" "到期日期" "剩余天数"
echo "----------------------------------------------------------------------------------------------------------"

# 遍历所有已注册的证书目录
for cert_dir in "$ACME_DIR"/*/; do
  [ -d "$cert_dir" ] || continue
  cert_file="$cert_dir/fullchain.cer"
  if [ -f "$cert_file" ]; then
    domain=$(basename "$cert_dir")
    not_before=$(openssl x509 -in "$cert_file" -noout -startdate | cut -d= -f2)
    not_after=$(openssl x509 -in "$cert_file" -noout -enddate | cut -d= -f2)
    # 剩余天数
    expire_date=$(date -d "$not_after" +%s)
    now_date=$(date +%s)
    left_days=$(( (expire_date - now_date) / 86400 ))
    # 输出
    printf "%-30s %-25s %-25s %-10s\n" "$domain" "$not_before" "$not_after" "$left_days"
  fi
done
