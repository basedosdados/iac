#!/bin/bash
set -euo pipefail

apt-get update
apt-get install -y squid apache2-utils

htpasswd -cb /etc/squid/passwd "${proxy_username}" "${proxy_password}"

cat > /etc/squid/squid.conf <<EOF
http_port ${proxy_port}
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd
auth_param basic realm proxy
acl authenticated proxy_auth REQUIRED
http_access allow authenticated
http_access deny all
EOF

systemctl restart squid
systemctl enable squid
