#!/bin/sh

REPO_URL="https://raw.githubusercontent.com/DoNBaLooN/router-info-page/main"
WWW_DIR="/www"

echo "Downloading files from GitHub..."
wget -O "$WWW_DIR/ip.html" "$REPO_URL/ip.html"
wget -O "$WWW_DIR/wanip.sh" "$REPO_URL/wanip.sh"

echo "Making wanip.sh executable..."
chmod +x "$WWW_DIR/wanip.sh"

echo "Checking uhttpd configuration for .sh support..."
if ! uci get uhttpd.main.interpreter 2>/dev/null | grep -q "/bin/sh"; then
    echo "Adding .sh interpreter support to uhttpd..."
    uci add_list uhttpd.main.interpreter='.sh=/bin/sh'
    uci commit uhttpd
else
    echo ".sh interpreter support is already enabled."
fi

echo "Restarting uhttpd..."
/etc/init.d/uhttpd restart

echo "Installation completed. Open in your browser: http://<router_ip>/ip.html"
