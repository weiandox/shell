#!/bin/bash

# === 请根据你情况修改这三项 ===
CF_TOKEN="your-cloudflare-token"       # 填写你的 Cloudflare API Token
DOMAIN="www.test.com"           # 你的域名
EMAIL="your@email.com"                 # 可选：你的邮箱

# 设置默认 CA 为 Let's Encrypt
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt

# 可选：注册账号（用于证书续期提醒）
~/.acme.sh/acme.sh --register-account -m "$EMAIL"

# 设置 Cloudflare DNS API 环境变量
export CF_Token="$CF_TOKEN"
export CF_Account_ID=""

# 创建证书
~/.acme.sh/acme.sh --issue --dns dns_cf -d "$DOMAIN"

# 创建目标目录
sudo mkdir -p /etc/nginx/ssl/

# 安装证书 + 设置自动续期自动 reload nginx
~/.acme.sh/acme.sh --install-cert -d "$DOMAIN" \
  --key-file       /etc/nginx/ssl/$DOMAIN.key \
  --fullchain-file /etc/nginx/ssl/$DOMAIN.crt \
  --reloadcmd     "systemctl reload nginx"

echo "✅ 证书申请与安装完成，Nginx 已设置自动 reload。"
echo "📁 证书路径：/etc/nginx/ssl/$DOMAIN.crt"
echo "📁 私钥路径：/etc/nginx/ssl/$DOMAIN.key"
