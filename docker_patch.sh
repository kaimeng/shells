#!/usr/bin/env bash

mkdir -p /etc/systemd/system/docker.service.d

cat > /etc/systemd/system/docker.service.d/http-proxy.conf <<EOF
[Service] Environment="HTTP_PROXY=http://10.136.21.76:1080" "NO_PROXY=localhost,127.0.0.1"
EOF

cat > /etc/systemd/system/docker.service.d/https-proxy.conf <<EOF
[Service] Environment="HTTPS_PROXY=http://10.136.21.76:1080" "NO_PROXY=localhost,127.0.0.1"
EOF

systemctl daemon-reload
systemctl restart docker
